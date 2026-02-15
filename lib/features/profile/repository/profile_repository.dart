import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_service.dart';
import '../../../core/models/user_model.dart';
import '../../../core/constants/guest_data.dart';
import '../../../features/auth/repository/auth_repository.dart';
import '../../../core/services/cache_service.dart';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(
    ref.watch(cacheServiceProvider),
    apiService: ref.watch(apiServiceProvider),
  ),
);

final userProfileProvider = FutureProvider<UserModel>((ref) {
  final authStatus = ref.watch(authStateProvider);
  if (authStatus == AuthStatus.guest) {
    return GuestData.userProfile;
  }
  if (authStatus != AuthStatus.authenticated) {
    throw Exception('User is not authenticated');
  }
  final profileRepository = ref.watch(profileRepositoryProvider);
  return profileRepository.getUserProfile();
});

class ProfileRepository {
  final ApiService _apiService;
  final CacheService _cacheService;
  final _secureStorage = const FlutterSecureStorage();

  ProfileRepository(this._cacheService, {required ApiService apiService})
    : _apiService = apiService;

  Future<UserModel> getUserProfile({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final isGuest = await _secureStorage.read(key: 'is_guest') == 'true';
      if (isGuest) return GuestData.userProfile;

      final cachedData = _cacheService.getData(key: CacheKeys.userProfile);
      if (cachedData != null) {
        final user = UserModel.fromJson(cachedData);
        print("👤 [PROFILE REPO] Loaded from Cache. PlanID: ${user.planId}");
        return user;
      }
    }

    try {
      final userId = await _secureStorage.read(key: 'user_id');
      if (userId == null) throw Exception("User ID not found");

      print("🌐 [PROFILE REPO] Fetching from API...");
      final result = await _apiService.getUserProfile(userId);

      await _cacheService.saveData(key: CacheKeys.userProfile, data: result);
      final user = UserModel.fromJson(result);
      print("✅ [PROFILE REPO] API Success. PlanID: ${user.planId}");
      return user;
    } catch (e) {
      final cachedData = _cacheService.getData(key: CacheKeys.userProfile);
      if (cachedData != null) return UserModel.fromJson(cachedData);
      rethrow;
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> userData) async {
    final userId = await _secureStorage.read(key: 'user_id');
    userData['userId'] = userId;

    await _apiService.updateUserInfo(userId!, userData);
    await _cacheService.removeData(key: CacheKeys.userProfile);
  }

  Future<void> updateAddress(Map<String, dynamic> addressData) async {
    final userId = await _secureStorage.read(key: 'user_id');
    addressData['userId'] = userId;
    await _apiService.updateUserAddress(userId!, addressData);
    await _cacheService.removeData(key: CacheKeys.userProfile);
  }

  Future<void> uploadProfileImage(File imageFile) async {
    try {
      final userId = await _secureStorage.read(key: 'user_id');

      await _apiService.uploadProfileImage(userId!, imageFile);

      final freshProfileData = await _apiService.getUserProfile(userId);

      final String? serverImageUrl =
          freshProfileData['image'] ?? freshProfileData['profileImage'];

      if (serverImageUrl == null || serverImageUrl.isEmpty) {
        return;
      }

      await CachedNetworkImage.evictFromCache(serverImageUrl);

      final String separator = serverImageUrl.contains('?') ? '&' : '?';
      final String timestampedUrl =
          "$serverImageUrl${separator}v=${DateTime.now().millisecondsSinceEpoch}";

      freshProfileData['image'] = timestampedUrl;

      await _cacheService.saveData(
        key: CacheKeys.userProfile,
        data: freshProfileData,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await _apiService.changePassword(
        userId: await _secureStorage.read(key: 'user_id') ?? '',
        currentPassword: oldPassword,
        newPassword: newPassword,
      );
    } catch (e) {
      rethrow;
    }
  }
}
