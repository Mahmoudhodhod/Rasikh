import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/api/api_service.dart';
import '../../../core/models/dashboard_stats_model.dart';
import '../../auth/repository/auth_repository.dart';
import '../../profile/repository/profile_repository.dart';
import '../../../core/models/user_model.dart';
import '../../../core/constants/guest_data.dart';

final dashboardRepositoryProvider = Provider(
  (ref) => DashboardRepository(ref.watch(apiServiceProvider), ref),
);

final dashboardStatsProvider = FutureProvider<DashboardStatsModel>((ref) async {
  final userState = ref.watch(userProfileProvider);
  return userState.when(
    data: (user) async {
      final repo = ref.watch(dashboardRepositoryProvider);
      return repo.getStats(currentUser: user);
    },
    loading: () {
      throw const AsyncLoading();
    },
    error: (err, stack) => throw err,
  );
});

class DashboardRepository {
  final ApiService _apiService;
  final Ref _ref;
  final _secureStorage = const FlutterSecureStorage();

  DashboardRepository(this._apiService, this._ref);

  Future<DashboardStatsModel> getStats({UserModel? currentUser}) async {
    final userId = await _secureStorage.read(key: 'user_id');

    // Check if guest
    final isGuest = await _secureStorage.read(key: 'is_guest') == 'true';
    if (isGuest) {
      return GuestData.dashboardStats;
    }

    if (userId == null) throw Exception("User not logged in");
    final userModel =
        currentUser ?? await _ref.read(userProfileProvider.future);
    final planId = userModel?.planId ?? 0;

    if (planId == 0) {
      return DashboardStatsModel(
        overallProgress: 0,
        completedParts: 0,
        totalSavedAyat: 0,
        totalWajah: 0,
        averageDailyMemorization: 0,
      );
    }

    final data = await _apiService.getStudentStatistics(userId, planId);
    return DashboardStatsModel.fromJson(data);
  }
}
