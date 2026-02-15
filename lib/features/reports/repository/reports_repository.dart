import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/api/api_service.dart';
import '../../../core/models/report_model.dart';
import '../../auth/repository/auth_repository.dart';
import '../../profile/repository/profile_repository.dart';
import '../../../core/constants/guest_data.dart';

final reportsRepositoryProvider = Provider(
  (ref) => ReportsRepository(ref.watch(apiServiceProvider), ref),
);

final reportProvider = FutureProvider<ReportModel>((ref) async {
  final userState = ref.watch(userProfileProvider);

  return userState.when(
    data: (user) async {
      final repo = ref.watch(reportsRepositoryProvider);
      return repo.getReport();
    },
    loading: () => throw const AsyncLoading(),
    error: (error, stack) => throw error,
  );
});

class ReportsRepository {
  final ApiService _apiService;
  final Ref _ref;
  final FlutterSecureStorage _secureStorage;

  ReportsRepository(this._apiService, this._ref)
    : _secureStorage = const FlutterSecureStorage();

  Future<ReportModel> getReport() async {
    final userId = await _secureStorage.read(key: 'user_id');
    if (userId == null || userId.trim().isEmpty) {
      throw Exception("User is not authenticated (ID is null/empty)");
    }

    final userModel = await _ref.read(userProfileProvider.future);

    if (userModel.userId == 'guest') {
      return GuestData.reportData;
    }

    final planId = userModel.planId ?? 0;

    if (planId == 0) {
      return const ReportModel(
        savedVersesCount: 0,
        savedPagesCount: 0,
        savedJuzCount: 0,
        dailyAverage: 0.0,
        totalParts: 0,
        linkedVersesCount: 0,
        reviewedVersesCount: 0,
        completionPercentage: 0.0,
        completedDays: 0,
        performance: 0.0,
      );
    }

    final data = await _apiService.getStudentStatistics(userId, planId);

    final json = Map<String, dynamic>.from(data as Map);

    return ReportModel.fromJson(json);
  }
}
