import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../core/api/api_service.dart';
import '../../../core/services/cache_service.dart';
import '../../../core/models/plan_summary_model.dart';

final dioProvider = Provider((ref) => Dio());
final secureStorageProvider = Provider((ref) => const FlutterSecureStorage());

final apiServiceProvider = Provider(
  (ref) => ApiService(ref.watch(dioProvider), ref.watch(secureStorageProvider)),
);

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    ref.watch(apiServiceProvider),
    ref.watch(secureStorageProvider),
    ref.watch(cacheServiceProvider),
  ),
);

class AuthRepository {
  final ApiService _apiService;
  final FlutterSecureStorage _secureStorage;
  final CacheService _cacheService;

  AuthRepository(this._apiService, this._secureStorage, this._cacheService);

  Future<void> _saveToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  Future<void> _saveUserId(String id) async {
    await _secureStorage.write(key: 'user_id', value: id);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  Future<String?> getUserId() async {
    return await _secureStorage.read(key: 'user_id');
  }

  Future<List<PlanSummaryModel>> getAvailablePlans() async {
    try {
      final response = await _apiService.getPlansList();

      final plans = response.map((e) => PlanSummaryModel.fromJson(e)).toList();

      if (plans.isEmpty) {
        return getStaticPlans();
      }
      return plans;
    } catch (e) {
      return getStaticPlans();
    }
  }

  List<PlanSummaryModel> getStaticPlans() {
    return [
      PlanSummaryModel(
        id: 1009,
        name: "خطة نصف وجه من البقرة",
        monthNumber: 0,
        isCompleted: false,
      ),
      PlanSummaryModel(
        id: 1008,
        name: "خطة نصف وجه من الناس",
        monthNumber: 0,
        isCompleted: false,
      ),
    ];
  }

  Future<void> initializeUserPlans(
    int selectedPlanId,
    List<PlanSummaryModel> allPlans,
  ) async {
    final selectedPlanIndex = allPlans.indexWhere(
      (p) => p.id == selectedPlanId,
    );

    if (selectedPlanIndex != -1) {
      final selectedPlan = allPlans.removeAt(selectedPlanIndex);

      allPlans.insert(0, selectedPlan);
    }
    final plansJson = allPlans.map((p) => p.toJson()).toList();
    await _cacheService.saveData(
      key: 'user_plans_queue',
      data: {'plans': plansJson},
    );

    await _secureStorage.write(
      key: 'current_plan_id',
      value: selectedPlanId.toString(),
    );
  }

  Future<void> register({required Map<String, dynamic> userData}) async {
    try {
      await _apiService.registerStudent(userData: userData);
      await Future.delayed(const Duration(seconds: 2));

      await login(email: userData['email'], password: userData['password']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      final responseData = await _apiService.login(
        email: email,
        password: password,
      );

      final token = responseData['token'];
      final userId = responseData['userId'];

      if (token != null && userId != null) {
        await _saveToken(token);
        await _saveUserId(userId);
        await _secureStorage.delete(key: 'is_guest');
      } else {
        throw Exception("Login failed: Missing token or userId");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;

      if (idToken != null || accessToken != null) {
        final appToken = await _apiService.socialLogin(
          provider: 'google',
          idToken: idToken ?? accessToken!,
          name: googleUser.displayName,
          email: googleUser.email,
        );
        await _saveToken(appToken);
        await _secureStorage.delete(key: 'is_guest');
      } else {
        throw Exception("Google Authentication failed");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loginWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final String? idToken = credential.identityToken;

      if (idToken != null) {
        String? name;
        if (credential.givenName != null) {
          name = "${credential.givenName} ${credential.familyName ?? ''}";
        }

        final appToken = await _apiService.socialLogin(
          provider: 'apple',
          idToken: idToken,
          name: name,
          email: credential.email,
        );
        await _saveToken(appToken);
        await _secureStorage.delete(key: 'is_guest');
      } else {
        throw Exception("Apple ID Token is null");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> requestPasswordReset(String email) async {
    await _apiService.requestPasswordReset(email);
  }

  Future<void> verifyResetCode(String email, String code) async {
    await _apiService.verifyResetCode(email, code);
  }

  Future<void> resetPassword(String email, String newPassword) async {
    await _apiService.resetPassword(email, newPassword);
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'auth_token');
    await _secureStorage.delete(key: 'user_id');
    // Set is_guest to true to fallback to guest mode
    await _secureStorage.write(key: 'is_guest', value: 'true');
    await _cacheService.clearUserData();
  }

  Future<void> deleteAccount() async {
    try {
      // Identity is verified via the authentication token
      await _apiService.deleteAccount();
      // Clear all local data
      await _secureStorage.deleteAll();
      await _cacheService.clearUserData();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loginAsGuest() async {
    await _secureStorage.write(key: 'is_guest', value: 'true');
  }

  Future<bool> isGuest() async {
    final value = await _secureStorage.read(key: 'is_guest');
    return value == 'true';
  }
}

enum AuthStatus { unknown, authenticated, unauthenticated, guest }

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthStatus>((
  ref,
) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthStateNotifier(authRepository);
});

class AuthStateNotifier extends StateNotifier<AuthStatus> {
  final AuthRepository _authRepository;

  AuthStateNotifier(this._authRepository) : super(AuthStatus.unknown) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      final token = await _authRepository.getToken();
      if (token != null && token.isNotEmpty) {
        state = AuthStatus.authenticated;
      } else {
        final isGuest = await _authRepository.isGuest();
        if (isGuest) {
          state = AuthStatus.guest;
        } else {
          state = AuthStatus.unauthenticated;
        }
      }
    } catch (e) {
      state = AuthStatus.unauthenticated;
    }
  }

  Future<void> register({required Map<String, dynamic> userData}) async {
    try {
      await _authRepository.register(userData: userData);
      state = AuthStatus.authenticated;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      await _authRepository.login(email: email, password: password);
      state = AuthStatus.authenticated;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      await _authRepository.loginWithGoogle();
      state = AuthStatus.authenticated;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loginWithApple() async {
    try {
      await _authRepository.loginWithApple();
      state = AuthStatus.authenticated;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loginAsGuest() async {
    await _authRepository.loginAsGuest();
    state = AuthStatus.guest;
  }

  Future<void> logout() async {
    await _authRepository.logout();
    state = AuthStatus.guest;
  }

  Future<void> deleteAccount() async {
    try {
      await _authRepository.deleteAccount();
      state = AuthStatus.unauthenticated;
    } catch (e) {
      rethrow;
    }
  }
}
