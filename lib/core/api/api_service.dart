import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../navigation/navigation_service.dart';
import '../widgets/guest_dialog.dart';
import 'api_exceptions.dart';

class ApiService {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  static const String _baseUrl = 'https://rasekh.app/be/';

  ApiService(this._dio, this._secureStorage) {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': '*/*',
    };
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          bool requiresToken = options.headers['requiresToken'] ?? true;
          options.headers.remove('requiresToken');
          if (requiresToken) {
            final token = await _secureStorage.read(key: 'auth_token');
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
            final context = navigatorKey.currentState?.context;
            if (context != null) {
              await showGuestDialog(context);
            }
          }
          if (e.response?.data != null) return handler.next(e);
          return handler.next(e);
        },
      ),
    );
  }
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        'api/Account/Login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          message: 'Invalid response from server',
        );
      }
    } catch (e) {
      throw DioExceptionHandler.handle(e);
    }
  }

  Future<void> registerStudent({required Map<String, dynamic> userData}) async {
    try {
      await _dio.post(
        'api/Account/Register',
        data: userData,
        options: Options(headers: {'requiresToken': false}),
      );
    } catch (e) {
      if (e is DioException) {}
      throw DioExceptionHandler.handle(e);
    }
  }

  Future<void> register({required Map<String, dynamic> userData}) async {
    return registerStudent(userData: userData);
  }

  Future<String> socialLogin({
    required String provider,
    required String idToken,
    String? name,
    String? email,
  }) async {
    try {
      final response = await _dio.post(
        'api/Auth/SocialLogin',
        data: {
          'provider': provider,
          'id_token': idToken,
          'name': name,
          'email': email,
        },
      );

      if (response.statusCode == 200 && response.data['token'] != null) {
        return response.data['token'];
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          message: 'Social login failed',
        );
      }
    } catch (e) {
      throw DioExceptionHandler.handle(e);
    }
  }

  Future<void> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _dio.post(
        'api/Account/ChangePassword',
        data: {
          'userId': userId,
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
    } catch (e) {
      throw DioExceptionHandler.handle(e);
    }
  }

  Future<void> requestPasswordReset(String email) async {
    try {
      final encodedEmail = Uri.encodeComponent(email);
      await _dio.get('api/Account/SendCodeConfirm/$encodedEmail');
    } catch (e) {
      throw DioExceptionHandler.handle(e);
    }
  }

  Future<void> verifyResetCode(String email, String code) async {
    try {
      await _dio.post(
        'api/Account/ConfirmEmail',
        data: {'email': email, 'code': int.parse(code)},
      );
    } catch (e) {
      throw DioExceptionHandler.handle(e);
    }
  }

  Future<void> resetPassword(String email, String newPassword) async {
    try {
      await _dio.post(
        'api/Account/ResetPassword',
        data: {'email': email, 'newPassword': newPassword},
      );
    } catch (e) {
      throw DioExceptionHandler.handle(e);
    }
  }

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      final response = await _dio.get('api/Account/Details/$userId');
      if (response.statusCode == 200 && response.data != null) {
        return response.data;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          message: 'Failed to load profile',
        );
      }
    } catch (e) {
      throw DioExceptionHandler.handle(e);
    }
  }

  Future<void> updateUserInfo(String userId, Map<String, dynamic> data) async {
    try {
      await _dio.put('api/Account/UserInfo/$userId', data: data);
    } catch (e) {
      throw DioExceptionHandler.handle(e);
    }
  }

  Future<void> updateUserAddress(
    String userId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _dio.put('api/Account/UserAddress/$userId', data: data);
    } catch (e) {
      throw DioExceptionHandler.handle(e);
    }
  }

  Future<String> uploadProfileImage(String userId, File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "formFile": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });
      final response = await _dio.put(
        'api/Account/UserImage/$userId',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      if (response.data is String) {
        return response.data;
      }
      if (response.data is Map<String, dynamic>) {
        if (response.data.containsKey('imageUrl')) {
          return response.data['imageUrl'];
        }
        return '';
      }
      return '';
    } catch (e) {
      throw DioExceptionHandler.handle(e);
    }
  }

  Future<List<dynamic>> getCountries() async {
    try {
      final response = await _dio.get(
        'api/Account/Countires',
        options: Options(headers: {'requiresToken': false}),
      );
      return response.data;
    } catch (e) {
      throw DioExceptionHandler.handle(e);
    }
  }

  Future<List<dynamic>> getContactTypes() async {
    try {
      final response = await _dio.get(
        'api/Contacts/ContactTypes',
        options: Options(headers: {'requiresToken': false}),
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw ApiException(
          ApiErrorType.unknown,
          message: "فشل جلب البيانات: ${response.statusMessage}",
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw DioExceptionHandler.handle(e);
    }
  }

  Future<void> sendContactMessage({
    required String userId,
    required String description,
    required int contactTypeId,
  }) async {
    try {
      final response = await _dio.post(
        'api/Contacts/Create',
        data: {
          "id": 0,
          "userId": userId,
          "description": description,
          "contactTypeId": contactTypeId,
        },
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiException(
          ApiErrorType.unknown,
          message: "فشل الإرسال: ${response.statusMessage}",
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw DioExceptionHandler.handle(e);
    }
  }

  Future<Map<String, dynamic>> getStudentStatistics(
    String userId,
    int planId,
  ) async {
    try {
      final response = await _dio.get(
        'api/Report/StudentStatistics/$userId/$planId',
      );
      if (response.statusCode == 200 && response.data != null) {
        return response.data;
      }
      return {};
    } catch (e) {
      throw DioExceptionHandler.handle(e);
    }
  }

  Future<List<Map<String, dynamic>>> getCertificates(
    String userId, {
    int page = 1,
  }) async {
    try {
      final response = await _dio.get(
        'api/Certificates/GetTo/$page/30/$userId',
      );
      if (response.statusCode == 200 && response.data != null) {
        if (response.data['data'] is List) {
          return List<Map<String, dynamic>>.from(response.data['data']);
        }
        return [];
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          message: 'Failed certificates',
        );
      }
    } catch (e) {
      throw DioExceptionHandler.handle(e);
    }
  }

  Future<Map<String, dynamic>> getStudentProgressList({
    required String userId,
    required int planId,
    int page = 1,
    int pageSize = 500,
  }) async {
    try {
      final response = await _dio.get(
        'api/StudentProgress/GetStudentProgress/$page/$pageSize/$userId/$planId',
      );
      if (response.statusCode == 200 && response.data != null) {
        return response.data;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          message: 'Failed to load archive',
        );
      }
    } catch (e) {
      throw DioExceptionHandler.handle(e);
    }
  }

  Future<List<String>> getVersesText(int surahId) async {
    try {
      final response = await _dio.get(
        'api/DailyPlans/Verses/$surahId/$surahId',
      );
      print(response.data);
      if (response.data is List && response.data.isNotEmpty) {
        final surahData = response.data[0];
        final versesList = surahData['verses'] as List;
        return versesList.map((v) => _extractVerseText(v)).toList();
      }
      return [];
    } catch (e) {
      throw DioExceptionHandler.handle(e);
    }
  }

  String _extractVerseText(dynamic v) {
    if (v is String) return v;
    if (v is Map) {
      if (v.isNotEmpty) {
        // Try to find the text value
        if (v.containsKey('text')) return v['text'].toString();
        if (v.containsKey('content')) return v['content'].toString();
        // If single key-value pair, return the value
        if (v.length == 1) return v.values.first.toString();

        // If multiple keys and no obvious text key, look for the first String value
        for (final value in v.values) {
          if (value is String) return value;
        }
        //just return the first value
        return v.values.first.toString();
      }
    }
    return v.toString();
  }

  Future<void> updateRepeatation(int progressId) async {
    try {
      await _dio.put('api/StudentProgress/Repeat/$progressId');
    } catch (e) {
      throw DioExceptionHandler.handle(e);
    }
  }

  Future<void> incrementListen(int progressId) async {
    try {
      await _dio.put('api/StudentProgress/Listen/$progressId');
    } catch (e) {
      throw DioExceptionHandler.handle(e);
    }
  }

  Future<void> setWritingProgress({
    required String userId,
    required int progressId,
    bool? isWriting,
  }) async {
    try {
      await _dio.post(
        'api/StudentProgress/SaveProgress',
        data: {
          'id': progressId,
          'userId': userId,
          'isWriting': isWriting ?? false,
          'isLink': false,
          'isReview': false,
        },
      );
    } catch (e) {
      throw DioExceptionHandler.handle(e);
    }
  }

  Future<void> endPlan(String userId, int planId) async {
    try {
      // ignore: unused_local_variable
      final res = await _dio.get(
        'api/StudentProgress/$userId/$planId',
        options: Options(headers: {'Accept': 'application/json'}),
      );
    } on DioException catch (e) {
      throw DioExceptionHandler.handle(e);
    }
  }

  Future<Map<String, dynamic>> saveProgress(
    Map<String, dynamic> progressData,
  ) async {
    try {
      final res = await _dio.post(
        'api/StudentProgress/SaveProgress',
        data: progressData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      if (res.data is Map<String, dynamic>) {
        return Map<String, dynamic>.from(res.data);
      }
      return {'raw': res.data};
    } on DioException catch (e) {
      throw DioExceptionHandler.handle(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getStudentProgress(String userId, int planId) async {
    try {
      final url = 'api/StudentProgress/$userId/$planId';
      final response = await _dio.get(url);
      if (response.data is String) {
        throw ApiException(ApiErrorType.noDailyPlan);
      }
      if (response.data is Map<String, dynamic>) {
        return response.data;
      }
      throw ApiException(
        ApiErrorType.unexpected,
        message: "Invalid data format received",
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw DioExceptionHandler.handle(e);
    }
  }

  Future<bool> checkIfPlanHasContent(int planId) async {
    try {
      final response = await _dio.get('api/DailyPlans/getAll/$planId/1/1');
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List).isNotEmpty;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<List<dynamic>> getAllSurahs() async {
    try {
      final response = await _dio.get('api/Surahs/List');
      return response.data;
    } catch (e) {
      throw DioExceptionHandler.handle(e);
    }
  }

  Future<Map<String, dynamic>> getTafsirList({
    int page = 1,
    int pageSize = 20,
    int? surahId,
    int? verseId,
    String? word,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (surahId != null && surahId != 0) queryParams['surahId'] = surahId;
      if (verseId != null && verseId != 0) queryParams['verseId'] = verseId;
      if (word != null && word.isNotEmpty) queryParams['word'] = word;

      final response = await _dio.get(
        'api/Tafsir/GetAll/$page/$pageSize',
        queryParameters: queryParams,
      );

      return response.data;
    } catch (e) {
      throw DioExceptionHandler.handle(e);
    }
  }

  Future<Map<String, dynamic>> getTafsirDetails(int id) async {
    try {
      final response = await _dio.get('api/Tafsir/Details/$id');
      return response.data;
    } catch (e) {
      throw DioExceptionHandler.handle(e);
    }
  }

  Future<List<dynamic>> getVerseNumbers(int surahId) async {
    try {
      final response = await _dio.get('api/Verses/VerserNumber/$surahId');
      return response.data;
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getPlansList() async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final url = 'api/Plans/List?t=$timestamp';

      final response = await _dio.get(
        url,
        options: Options(headers: {'requiresToken': false}),
      );

      if (response.statusCode == 200 && response.data != null) {
        dynamic rawData = response.data;
        List<dynamic>? listData;

        if (rawData is List) {
          listData = rawData;
        } else if (rawData is Map) {
          listData = rawData['data'] ?? rawData['result'] ?? rawData['items'];
        }

        if (listData != null) {
          return listData
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();
        }
      }
      return [];
    } catch (e) {
      throw DioExceptionHandler.handle(e);
    }
  }

  Future<void> updateAccount(String userId, Map<String, dynamic> data) async {
    try {
      await _dio.put('api/Account/$userId', data: data);
    } catch (e) {
      throw DioExceptionHandler.handle(e);
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _dio.delete('api/Account/DeleteMyAccount');
    } catch (e) {
      throw DioExceptionHandler.handle(e);
    }
  }

  Future<Map<String, dynamic>> getTajweedRules({int? id}) async {
    try {
      final response = await _dio.get(
        'api/Tajweed/Get',
        queryParameters: id != null ? {'id': id} : null,
      );
      if (response.statusCode == 200 && response.data != null) {
        return response.data;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to load tajweed rules',
        );
      }
    } catch (e) {
      if (e is DioException) {}
      throw DioExceptionHandler.handle(e);
    }
  }
}
