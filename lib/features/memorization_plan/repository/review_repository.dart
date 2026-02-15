import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/models/archive_day_model.dart';
import '../../profile/repository/profile_repository.dart';
import '../models/review_state.dart';
import '../../../core/api/api_service.dart';
import '../../auth/repository/auth_repository.dart';
import '../../../core/constants/guest_data.dart';

final reviewStateRepositoryProvider = Provider<ReviewStateRepository>((ref) {
  return ReviewStateRepository(ref, ref.watch(apiServiceProvider));
});

final reviewStateProvider = FutureProvider<ReviewState>((ref) async {
  final repo = ref.watch(reviewStateRepositoryProvider);
  return repo.loadReviewState();
});

class ReviewStateRepository {
  final Ref _ref;
  final ApiService _apiService;
  final _secureStorage = const FlutterSecureStorage();

  ReviewStateRepository(this._ref, this._apiService);

  Future<ReviewState> loadReviewState() async {
    final user = await _ref.read(userProfileProvider.future);
    if (user.userId == 'guest') {
      return GuestData.reviewState;
    }
    final planId = user.planId ?? 0;

    if (planId == 0) return const ReviewState();

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

      final reviewDays = allDays.where((d) => d.hasReviewRange).toList();

      final pendingReviews = reviewDays.where((d) {
        return !d.isCompleted && (d.reviewedAyatCount ?? 0) == 0;
      }).toList();

      final completedReviews = reviewDays.where((d) {
        return d.isCompleted || (d.reviewedAyatCount ?? 0) > 0;
      }).toList();

      return ReviewState(
        pendingReviews: pendingReviews,
        completedReviews: completedReviews,
      );
    } catch (e) {
      print("❌ [ReviewRepository] Error: $e");
      return const ReviewState();
    }
  }

  Future<void> markReviewed(int progressId) async {
    final userId = await _secureStorage.read(key: 'user_id');
    if (userId == null) throw Exception("User not authenticated");
    final payload = {
      'id': progressId,
      'userId': userId,
      'isWriting': false,
      'isLink': false,
      'isReview': true,
    };

    try {
      final res = await _apiService.saveProgress(payload);

      if (res.containsKey('succeeded') && res['succeeded'] == false) {
        throw Exception(res['messages']?.toString() ?? 'Failed to mark review');
      }
    } catch (e) {
      rethrow;
    }
  }
}
