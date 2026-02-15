import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/archive_day_model.dart';
import '../../profile/repository/profile_repository.dart';
import '../../auth/repository/auth_repository.dart';
import '../models/linking_state.dart';
import '../../../core/constants/guest_data.dart';

final linkingRepositoryProvider = Provider(
  (ref) => LinkingRepository(ref, ref.watch(apiServiceProvider)),
);

final linkingStateProvider = FutureProvider<LinkingState>((ref) async {
  return ref.watch(linkingRepositoryProvider).loadLinkingState();
});

class LinkingRepository {
  final Ref _ref;
  final ApiService _apiService;
  final _secureStorage = const FlutterSecureStorage();

  LinkingRepository(this._ref, this._apiService);

  Future<LinkingState> loadLinkingState() async {
    final user = await _ref.read(userProfileProvider.future);
    if (user.userId == 'guest') {
      return GuestData.linkingState;
    }
    final planId = user.planId ?? 0;

    if (planId == 0) return const LinkingState();

    try {
      final response = await _apiService.getStudentProgressList(
        userId: user.id,
        planId: planId,
        pageSize: 500,
      );

      final List<dynamic> listData = response['data'] ?? [];
      final List<ArchiveDayModel> allDays = listData
          .map((e) => ArchiveDayModel.fromJson(e))
          .toList();

      final linkingDays = allDays.where((d) => d.hasLinkRange).toList();

      final pendingLinks = linkingDays.where((d) {
        return !d.isCompleted && (d.linkedAyatCount ?? 0) == 0;
      }).toList();

      final completedLinks = linkingDays.where((d) {
        return d.isCompleted || (d.linkedAyatCount ?? 0) > 0;
      }).toList();

      return LinkingState(
        pendingLinks: pendingLinks,
        completedLinks: completedLinks,
      );
    } catch (e) {
      print("❌ [LinkingRepository] Error: $e");
      return const LinkingState();
    }
  }

  Future<void> markAsLinked(int progressId) async {
    final user = await _ref.read(userProfileProvider.future);
    if (user.userId == 'guest') return;

    final userId = await _secureStorage.read(key: 'user_id');
    final payload = {
      'id': progressId,
      'userId': userId,
      'isWriting': false,
      'isLink': true,
      'isReview': false,
      'isCompleted': true,
    };
    await _apiService.saveProgress(payload);
  }
}
