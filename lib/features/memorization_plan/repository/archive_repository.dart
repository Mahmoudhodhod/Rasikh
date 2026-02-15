import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/api/api_service.dart';
import '../../../core/models/archive_day_model.dart';
import '../../auth/repository/auth_repository.dart';
import '../../profile/repository/profile_repository.dart';
import '../../../core/services/cache_service.dart';

final archiveRepositoryProvider = Provider(
  (ref) => ArchiveRepository(
    ref.watch(apiServiceProvider),
    ref,
    ref.watch(cacheServiceProvider),
  ),
);

final archivePlanProvider = FutureProvider<List<ArchiveDayModel>>((ref) async {
  final userState = ref.watch(userProfileProvider);

  return userState.when(
    data: (user) {
      final repo = ref.watch(archiveRepositoryProvider);
      return repo.getArchivePlan(passedPlanId: user.planId);
    },
    loading: () => [],
    error: (e, s) => [],
  );
});

final planNameProvider = Provider<AsyncValue<String>>((ref) {
  final userAsync = ref.watch(userProfileProvider);
  return userAsync.whenData((user) => user.currentplanName ?? '');
});

class ArchiveRepository {
  final ApiService _apiService;
  final Ref _ref;
  final _secureStorage = const FlutterSecureStorage();
  final CacheService _cacheService;

  ArchiveRepository(this._apiService, this._ref, this._cacheService);

  Future<List<ArchiveDayModel>> getArchivePlan({
    bool forceRefresh = false,
    int? passedPlanId,
  }) async {
    int planId = passedPlanId ?? 0;

    if (planId == 0) {
      final userModel = await _ref.read(userProfileProvider.future);
      planId = userModel.planId ?? 0;
    }

    if (planId == 0) return [];

    if (!forceRefresh) {
      final cachedData = _cacheService.getData(key: CacheKeys.archivePlan);
      if (cachedData != null && cachedData['list'] != null) {
        print(" [ARCHIVE] Loaded from Cache");
        final list = cachedData['list'] as List;
        return list.map((e) => ArchiveDayModel.fromJson(e)).toList();
      }
    }

    try {
      final userId = await _secureStorage.read(key: 'user_id');
      if (userId == null) throw Exception("User ID not found");


      final response = await _apiService.getStudentProgressList(
        userId: userId,
        planId: planId,
      );

      List<dynamic> listData = [];
      if (response['data'] != null && response['data'] is List) {
        listData = response['data'];
      // ignore: unnecessary_type_check
      } else if (response is Map && response.containsKey('data')) {
        listData = [];
      } else {
      }

      final archiveList = listData
          .map((e) => ArchiveDayModel.fromJson(e))
          .toList();

      await _cacheService.saveData(
        key: CacheKeys.archivePlan,
        data: {'list': listData},
      );

      return archiveList;
    } catch (e) {
      final cachedData = _cacheService.getData(key: CacheKeys.archivePlan);
      if (cachedData != null && cachedData['list'] != null) {
        final list = cachedData['list'] as List;
        return list.map((e) => ArchiveDayModel.fromJson(e)).toList();
      }
      return [];
    }
  }
}
