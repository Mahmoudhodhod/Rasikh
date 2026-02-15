import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/api/api_service.dart';
import '../../../core/api/api_exceptions.dart';
import '../../../core/models/memorization_plan_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/cache_service.dart';

import '../../profile/repository/profile_repository.dart';
import '../../auth/repository/auth_repository.dart';
import 'package:quran/quran.dart' as quran;
import 'archive_repository.dart';
import '../../home/repository/dashboard_repository.dart';
import '../../../core/constants/guest_data.dart';

final memorizationRepositoryProvider = Provider(
  (ref) => MemorizationRepository(
    ref.watch(apiServiceProvider),
    ref,
    ref.watch(cacheServiceProvider),
  ),
);

final currentPlanProvider = FutureProvider<MemorizationPlanModel>((ref) async {
  final userState = ref.watch(userProfileProvider);
  return userState.when(
    data: (user) async {
      final repo = ref.watch(memorizationRepositoryProvider);
      return repo.getCurrentPlan(currentUser: user);
    },
    loading: () => throw const AsyncLoading(),
    error: (err, stack) => throw err,
  );
});

class MemorizationRepository {
  final ApiService _apiService;
  final Ref _ref;
  final _secureStorage = const FlutterSecureStorage();
  final CacheService _cacheService;

  MemorizationRepository(this._apiService, this._ref, this._cacheService);

  Future<MemorizationPlanModel> getCurrentPlan({
    required UserModel currentUser,
  }) async {
    try {
      final planId = currentUser.planId ?? 0;
      final userId = currentUser.id;

      if (userId == 'guest') {
        return GuestData.memorizationPlan;
      }

      if (planId == 0) throw ApiException(ApiErrorType.planEmpty);

      final progressData = await _apiService.getStudentProgress(userId, planId);

      return await _enrichPlanData(progressData, currentUser);
    } catch (e) {
      if (e is ApiException && e.type == ApiErrorType.noDailyPlan) {
        final planId = currentUser.planId ?? 0;
        final bool hasContent = await _apiService.checkIfPlanHasContent(planId);

        if (hasContent)
          throw ApiException(ApiErrorType.planCompleted);
        else
          throw ApiException(ApiErrorType.planEmpty);
      }
      final cached = _getCachedPlan();
      if (cached != null) return cached;
      rethrow;
    }
  }

  Future<MemorizationPlanModel> _enrichPlanData(
    Map<String, dynamic> progressData,
    UserModel currentUser,
  ) async {
    var planModel = MemorizationPlanModel.fromJson(progressData);

    final verses = await _apiService.getVersesText(
      planModel.details.surahStartId,
    );
    print(verses);
    final allSurahs = await _apiService.getAllSurahs();
    final surahObj = allSurahs.firstWhere(
      (s) => s['id'] == planModel.details.surahStartId,
      orElse: () => {'name': 'سورة ${planModel.details.surahStartId}'},
    );

    int relativeStartAyah = planModel.details.verseStartNumber ?? 1;
    int relativeEndAyah = planModel.details.verseEndNumber ?? verses.length;

    int previousVersesCount = 0;
    if (planModel.details.surahStartId > 1) {
      for (int i = 1; i < planModel.details.surahStartId; i++) {
        previousVersesCount += quran.getVerseCount(i);
      }
    }

    if (relativeStartAyah >
            quran.getVerseCount(planModel.details.surahStartId) ||
        relativeStartAyah > 7) {
      relativeStartAyah = relativeStartAyah - previousVersesCount;
      relativeEndAyah = relativeEndAyah - previousVersesCount;
    }

    if (relativeStartAyah < 1) relativeStartAyah = 1;
    if (relativeEndAyah < relativeStartAyah)
      relativeEndAyah = relativeStartAyah;

    final completeModel = planModel.copyWith(
      fullVerseText: _buildVersesWithAyahNumbers(
        verses: verses,
        startAyah: relativeStartAyah,
        endAyah: relativeEndAyah,
      ),
      surahName: surahObj['name'],
      startAyah: relativeStartAyah,
      endAyah: relativeEndAyah,
      planName: currentUser.currentplanName ?? "خطة الحفظ",
    );

    await _cacheService.saveData(
      key: CacheKeys.memorizationPlan,
      data: completeModel.toJson(),
    );

    return completeModel;
  }

  String _toArabicIndicDigits(int number) {
    const map = {
      '0': '٠',
      '1': '١',
      '2': '٢',
      '3': '٣',
      '4': '٤',
      '5': '٥',
      '6': '٦',
      '7': '٧',
      '8': '٨',
      '9': '٩',
    };
    final s = number.toString();
    return s.split('').map((ch) => map[ch] ?? ch).join();
  }

  String _ayahNumberOrnate(int ayahNumber) {
    return '\uFD3F${_toArabicIndicDigits(ayahNumber)}\uFD3E';
  }

  String _buildVersesWithAyahNumbers({
    required List<String> verses,
    required int startAyah,
    required int endAyah,
  }) {
    if (verses.isEmpty) return "";

    final safeStart = startAyah < 1 ? 1 : startAyah;
    final safeEnd = endAyah < safeStart ? safeStart : endAyah;

    final startIndex = safeStart - 1;
    final endIndexExclusive = safeEnd;

    final sliceStart = startIndex.clamp(0, verses.length);
    final sliceEnd = endIndexExclusive.clamp(0, verses.length);

    final selected = verses.sublist(sliceStart, sliceEnd);

    final buffer = StringBuffer();
    for (int i = 0; i < selected.length; i++) {
      final ayahNo = safeStart + i;
      final ayahText = selected[i].trim();

      if (ayahText.isEmpty) continue;

      buffer.write(ayahText);
      buffer.write(' ');
      buffer.write(_ayahNumberOrnate(ayahNo));
      buffer.write('  ');
    }

    return buffer.toString().trim();
  }

  MemorizationPlanModel? _getCachedPlan() {
    final cachedData = _cacheService.getData(key: CacheKeys.memorizationPlan);
    if (cachedData != null) return MemorizationPlanModel.fromJson(cachedData);
    return null;
  }

  Future<void> updateRepeatation(int progressId) async {
    await _apiService.updateRepeatation(progressId);
  }

  Future<void> incrementListen(int progressId) async {
    await _apiService.incrementListen(progressId);
  }

  Future<void> setIsWritten({required int progressId, bool? isWriting}) async {
    final userId = await _secureStorage.read(key: 'user_id');
    if (userId == null) throw Exception("User ID not found");

    await _apiService.setWritingProgress(
      userId: userId,
      progressId: progressId,
      isWriting: isWriting,
    );
  }

  Future<MemorizationPlanModel?> endPlan({
    required int planId,
    required int progressId,
    required bool isWriting,
    required bool isLink,
    required bool isReview,
  }) async {
    final userId = await _secureStorage.read(key: 'user_id');
    if (userId == null) throw Exception("User ID not found");

    try {
      final savePayload = {
        'id': progressId,
        'userId': userId,
        'isWriting': isWriting,
        'isLink': isLink,
        'isReview': isReview,
        'isCompleted': true,
      };

      print("______________________________________________");
      print(" 📤 [Repository] Sending Completion Payload: $savePayload");

      await _apiService.saveProgress(savePayload);
    } catch (e) {
      print(" ⚠️ [Repository] SaveProgress failed: $e");
    }

    try {
      final nextPlanData = await _apiService.getStudentProgress(userId, planId);

      if (nextPlanData is Map<String, dynamic> && nextPlanData.isNotEmpty) {
        if (nextPlanData['id'] != progressId) {
          print(
            " ✨ [Repository] Plan advanced to new ID: ${nextPlanData['id']}",
          );

          final userState = _ref.read(userProfileProvider);
          final user = userState.value;
          if (user != null) {
            return await _enrichPlanData(nextPlanData, user);
          }
        } else {
          print(
            " ⚠️ [Repository] Plan ID did not change ($progressId). Still on same day.",
          );
        }
      }
    } catch (e) {
      print(" ⚠️ [Repository] Get next plan failed: $e");
    }

    return null;
  }

  Future<void> changePlanStrict(int targetPlanId) async {
    final currentUser = await _ref.read(userProfileProvider.future);
    final currentPlanId = currentUser.planId ?? 0;
    if (targetPlanId == currentPlanId) return;
    if (targetPlanId > currentPlanId) {
      try {
        final hasContent = await _apiService.checkIfPlanHasContent(
          currentPlanId,
        );

        if (hasContent) {
          final stats = await _apiService.getStudentStatistics(
            currentUser.id,
            currentPlanId,
          );
          final completionPercentage = stats['completionPercentage'] ?? 0.0;
          if (completionPercentage < 99.0) {
            throw ApiException(
              ApiErrorType.unexpected,
              message: "يجب إكمال الخطة الحالية 100% أولاً",
            );
          }
        } else {
          print(
            " ℹ️ [changePlanStrict] Current plan $currentPlanId is empty. Allowing free switch.",
          );
        }
      } catch (e) {
        if (e is ApiException) rethrow;
        print(
          " [changePlanStrict] Stats check failed or bypass required (possibly empty plan): $e",
        );
      }
    }
    String newPlanName = "الخطة المختارة";
    try {
      final plansList = await _apiService.getPlansList();
      final targetPlan = plansList.firstWhere(
        (p) => p['id'] == targetPlanId,
        orElse: () => {},
      );
      if (targetPlan.isNotEmpty && targetPlan['name'] != null) {
        newPlanName = targetPlan['name'];
      }
    } catch (e) {
      print("Could not fetch plan name: $e");
    }

    final Map<String, dynamic> editDto = {
      'UserId': currentUser.userId,
      'Email': currentUser.email,
      'FirstName': currentUser.firstName,
      'MiddleName': currentUser.middleName ?? "",
      'LastName': currentUser.lastName,
      'PhoneNumber': currentUser.phoneNumber,
      'CountryId': (currentUser.countryId ?? "1").toString(),
      'Age': currentUser.age ?? 0,
      'PlanId': targetPlanId,
    };

    print(
      " 🚀 [changePlanStrict] Sending Update Data (updateAccount): $editDto",
    );

    await _apiService.updateAccount(currentUser.userId, editDto);

    try {
      final Map<String, dynamic> updatedUserJson = currentUser.toJson();
      updatedUserJson['planId'] = targetPlanId;
      updatedUserJson['currentplanName'] = newPlanName;

      await _cacheService.saveData(
        key: CacheKeys.userProfile,
        data: updatedUserJson,
      );

      await _cacheService.removeData(key: CacheKeys.memorizationPlan);
      await _cacheService.removeData(key: CacheKeys.archivePlan);
      await _cacheService.removeData(key: CacheKeys.dashboardStats);

      _ref.invalidate(userProfileProvider);
      _ref.invalidate(currentPlanProvider);
      _ref.invalidate(archivePlanProvider);
      _ref.invalidate(dashboardStatsProvider);
    } catch (e) {
      print(
        " ⚠️ [changePlanStrict] Plan switched on server, but local update failed: $e",
      );
    }
  }

  Future<void> setReviewStatus({
    required int progressId,
    required bool isCompleted,
  }) async {
    final userId = await _secureStorage.read(key: 'user_id');
    if (userId == null) throw Exception("User ID not found");

    await _apiService.saveProgress({
      'id': progressId,
      'userId': userId,
      'isReview': isCompleted,
    });
  }

  Future<void> setLinkStatus({
    required int progressId,
    required bool isCompleted,
  }) async {
    final userId = await _secureStorage.read(key: 'user_id');
    if (userId == null) throw Exception("User ID not found");

    await _apiService.saveProgress({
      'id': progressId,
      'userId': userId,
      'isLink': isCompleted,
    });
  }
}
