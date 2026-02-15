import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rasikh/main.dart';

final cacheServiceProvider = Provider<CacheService>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return CacheService(sharedPreferences);
});

class CacheKeys {
  static const String userProfile = 'userProfile';
  static const String memorizationPlan = 'memorizationPlan';
  static const String archivePlan = 'archivePlan';
  static const String dashboardStats = 'dashboardStats';
  static const List<String> userSpecificKeys = [
    userProfile,
    memorizationPlan,
    archivePlan,
    dashboardStats,
  ];
}

class CacheService {
  final SharedPreferences _prefs;
  CacheService(this._prefs);

  Future<void> saveData<T>({
    required String key,
    required Map<String, dynamic> data,
  }) async {
    final jsonString = json.encode(data);
    await _prefs.setString(key, jsonString);
  }

  Map<String, dynamic>? getData({required String key}) {
    final jsonString = _prefs.getString(key);
    if (jsonString != null) {
      return json.decode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> removeData({required String key}) async {
    await _prefs.remove(key);
  }

  Future<void> clearUserData() async {
    for (final key in CacheKeys.userSpecificKeys) {
      await _prefs.remove(key);
    }
  }
}
