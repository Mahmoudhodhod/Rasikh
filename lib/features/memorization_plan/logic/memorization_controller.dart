import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/memorization_plan_model.dart';
import '../../../../core/models/user_model.dart';
import '../../profile/repository/profile_repository.dart';
import '../repository/memorization_repository.dart';

final memorizationControllerProvider =
    StateNotifierProvider<
      MemorizationController,
      AsyncValue<MemorizationPlanModel?>
    >((ref) {
      final repo = ref.watch(memorizationRepositoryProvider);
      final userState = ref.watch(userProfileProvider);
      return MemorizationController(repo, userState);
    });

class MemorizationController
    extends StateNotifier<AsyncValue<MemorizationPlanModel?>> {
  final MemorizationRepository _repository;
  final AsyncValue<UserModel> _userState;

  MemorizationController(this._repository, this._userState)
    : super(const AsyncValue.loading()) {
    fetchCurrentPlan();
  }

  Future<void> fetchCurrentPlan() async {
    _userState.when(
      data: (user) async {
        try {
          if (state.value == null) state = const AsyncValue.loading();

          final plan = await _repository.getCurrentPlan(currentUser: user);
          state = AsyncValue.data(plan);
        } catch (e, stack) {
          state = AsyncValue.error(e, stack);
        }
      },
      loading: () => state = const AsyncValue.loading(),
      error: (e, s) => state = AsyncValue.error(e, s),
    );
  }

  Future<void> changeToPlan(int newPlanId) async {
    try {
      await _repository.changePlanStrict(newPlanId);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> incrementWritingCount() async {
    final currentPlan = state.value;
    if (currentPlan == null) return;
    if (currentPlan.isWritingCompleted) return;
    final updatedPlan = currentPlan.copyWith(isWritingCompleted: true);
    state = AsyncValue.data(updatedPlan);
    try {
      await _repository.setIsWritten(
        progressId: currentPlan.progressId,
        isWriting: true,
      );
    } catch (e) {
      state = AsyncValue.data(currentPlan);
    }
  }

  Future<void> incrementListeningCount() async {
    final currentPlan = state.value;
    if (currentPlan == null) return;
    final updatedPlan = currentPlan.copyWith(
      currentListening: currentPlan.currentListening + 1,
    );
    state = AsyncValue.data(updatedPlan);
    try {
      await _repository.incrementListen(currentPlan.progressId);
    } catch (e) {
      state = AsyncValue.data(currentPlan);
    }
  }

  Future<void> updateRepetition(int newValue) async {
    final currentPlan = state.value;
    if (currentPlan == null) return;
    final updatedPlan = currentPlan.copyWith(currentRepetition: newValue);
    state = AsyncValue.data(updatedPlan);
    try {
      await _repository.updateRepeatation(currentPlan.progressId);
    } catch (e) {
      state = AsyncValue.data(currentPlan);
    }
  }

  Future<void> completeMemorization() async {
    final currentPlan = state.value;
    if (currentPlan == null) return;

    try {
      await _repository.endPlan(
        planId: currentPlan.details.planId,
        progressId: currentPlan.progressId,
        isWriting: currentPlan.isWritingCompleted,
        isLink: currentPlan.isLinkCompleted,
        isReview: currentPlan.isReviewCompleted,
      );
      await fetchCurrentPlan();
    } catch (e) {}
  }

  Future<void> toggleReviewCompletion() async {
    final currentPlan = state.value;
    if (currentPlan == null) return;

    final newStatus = !currentPlan.isReviewCompleted;
    final updatedPlan = currentPlan.copyWith(isReviewCompleted: newStatus);
    state = AsyncValue.data(updatedPlan);

    try {
      await _repository.setReviewStatus(
        progressId: currentPlan.progressId,
        isCompleted: newStatus,
      );
    } catch (e) {
      state = AsyncValue.data(currentPlan);
    }
  }

  Future<void> toggleLinkCompletion() async {
    final currentPlan = state.value;
    if (currentPlan == null) return;

    final newStatus = !currentPlan.isLinkCompleted;
    final updatedPlan = currentPlan.copyWith(isLinkCompleted: newStatus);
    state = AsyncValue.data(updatedPlan);

    try {
      await _repository.setLinkStatus(
        progressId: currentPlan.progressId,
        isCompleted: newStatus,
      );
    } catch (e) {
      state = AsyncValue.data(currentPlan);
    }
  }
}
