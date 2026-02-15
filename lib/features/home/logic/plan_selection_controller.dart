import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/repository/auth_repository.dart';
import '../../profile/repository/profile_repository.dart';
import '../../memorization_plan/repository/memorization_repository.dart';
import '../repository/dashboard_repository.dart';

class PlanUiModel {
  final int id;
  final String name;
  final bool isSelected;
  final bool isLocked;
  final bool isCompleted;

  PlanUiModel({
    required this.id,
    required this.name,
    required this.isSelected,
    required this.isLocked,
    required this.isCompleted,
  });
}

final planSelectionControllerProvider =
    StateNotifierProvider<
      PlanSelectionController,
      AsyncValue<List<PlanUiModel>>
    >((ref) => PlanSelectionController(ref));

class PlanSelectionController
    extends StateNotifier<AsyncValue<List<PlanUiModel>>> {
  final Ref _ref;

  PlanSelectionController(this._ref) : super(const AsyncValue.loading()) {
    loadPlans();
  }
  Future<void> loadPlans() async {
    try {
      // 1. Fast Load (Static Data)
      final userAsync = _ref.read(userProfileProvider);
      final staticPlans = _ref.read(authRepositoryProvider).getStaticPlans();

      if (userAsync.hasValue && userAsync.value != null) {
        // Show static plans immediately with cached user data
        final initialUiPlans = _mapToUiPlans(
          staticPlans,
          userAsync.value!,
          canSwitchToNext: false, // Default for instant load
        );
        state = AsyncValue.data(initialUiPlans);
      } else {
        state = const AsyncValue.loading();
      }

      // 2. Fresh Data Fetch
      final allPlans = await _ref
          .read(authRepositoryProvider)
          .getAvailablePlans();

      // Ensure static plans are present if API returns empty or missing them
      // (Though getAvailablePlans handles empty, we want to be sure about merging if needed)
      // For now, trust getAvailablePlans as it falls back to static.

      final user = await _ref.read(userProfileProvider.future);
      final currentPlanId = user.planId ?? 0;

      bool canSwitchToNext = false;
      try {
        final stats = await _ref
            .read(dashboardRepositoryProvider)
            .getStats(currentUser: user);
        if (stats.overallProgress >= 99.0) {
          canSwitchToNext = true;
        }

        if (!canSwitchToNext) {
          final hasContent = await _ref
              .read(apiServiceProvider)
              .checkIfPlanHasContent(currentPlanId);
          if (!hasContent) {
            canSwitchToNext = true;
          }
        }
      } catch (e) {
        canSwitchToNext = true;
      }

      final uiPlans = _mapToUiPlans(
        allPlans,
        user,
        canSwitchToNext: canSwitchToNext,
      );

      state = AsyncValue.data(uiPlans);
    } catch (e, st) {
      if (state.hasValue) {
        // If we already showed data, maybe just keep it or show a snackbar in UI?
        // But for StateNotifier, we might default to error or keep data.
        // Let's keep data if we have it, but here we set error.
        // To be "smart", if we have static data, we might not want to show full error screen.
        // But let's follow standard pattern for now.
      }
      state = AsyncValue.error(e, st);
    }
  }

  List<PlanUiModel> _mapToUiPlans(
    List<dynamic> plans, // Using dynamic or PlanSummaryModel if imported
    dynamic user, { // User type
    required bool canSwitchToNext,
  }) {
    final currentPlanId = user.planId ?? 0;

    return plans.map<PlanUiModel>((plan) {
      final isSelected = plan.id == currentPlanId;
      final isPrevious = plan.id < currentPlanId;
      final isNextAvailable = (plan.id == currentPlanId + 1) && canSwitchToNext;

      final isLocked = !isPrevious && !isSelected && !isNextAvailable;

      return PlanUiModel(
        id: plan.id,
        name: plan.name,
        isSelected: isSelected,
        isCompleted: isPrevious || (isSelected && canSwitchToNext),
        isLocked: isLocked,
      );
    }).toList();
  }

  Future<void> selectPlan(int planId) async {
    // 1. Perform the plan switch (Critical Operation)
    try {
      await _ref.read(memorizationRepositoryProvider).changePlanStrict(planId);
    } catch (e) {
      // If this fails, the plan was NOT switched. Rethrow to show error.
      rethrow;
    }

    // 2. Refresh UI (Non-Critical Operation)
    try {
      await loadPlans();
    } catch (e) {
      // If this fails, the plan WAS switched successfully, but the UI failed to refresh.
      // We log this but do NOT rethrow, so the user doesn't see "Failed to switch plan".
      print("Plan switched successfully, but failed to refresh UI: $e");
    }
  }
}
