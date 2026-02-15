import 'package:dio/dio.dart';

enum ApiErrorType {
  connectionTimeout,
  sendTimeout,
  receiveTimeout,
  badRequest,
  unauthorized,
  notFound,
  noActivePlan,
  phoneNumberExists,
  serverError,
  cancel,
  noInternet,
  unknown,
  unexpected,
  oldPasswordIncorrect, 
  unexpectedWithCode,
  planCompleted,
  planEmpty,
  noDailyPlan
}

class ApiException implements Exception {
  final ApiErrorType type;
  final String? message; 
  final int? statusCode;

  ApiException(this.type, {this.message, this.statusCode});

  @override
  String toString() => "ApiException: $type (Code: $statusCode)";
}

class DioExceptionHandler {
  static ApiException handle(dynamic error) {
    print("🚨 [ExceptionHandler] Raw Error: $error");
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return ApiException(ApiErrorType.connectionTimeout);
        case DioExceptionType.sendTimeout:
          return ApiException(ApiErrorType.sendTimeout);
        case DioExceptionType.receiveTimeout:
          return ApiException(ApiErrorType.receiveTimeout);

        case DioExceptionType.badResponse:
          switch (error.response?.statusCode) {
            case 400:
              return ApiException(ApiErrorType.badRequest);
            case 401:
              return ApiException(ApiErrorType.unauthorized);
             case 404:
              if (error.response?.data is Map &&
                  error.response?.data['message'] == "No plan for today") {
                return ApiException(ApiErrorType.noActivePlan);
              }
              return ApiException(ApiErrorType.notFound);
            case 409:
              return ApiException(ApiErrorType.phoneNumberExists);
            case 500:
            case 502:
              return ApiException(ApiErrorType.serverError);
            default:
              return ApiException(
                ApiErrorType.unexpectedWithCode,
                statusCode: error.response?.statusCode,
              );
          }

        case DioExceptionType.cancel:
          return ApiException(ApiErrorType.cancel);

        case DioExceptionType.unknown:
        default:
          if (error.message != null &&
              error.message!.contains('SocketException')) {
            return ApiException(ApiErrorType.noInternet);
          }
          return ApiException(ApiErrorType.unknown);
      }
    } else if (error is ApiException) {
      return error;
    } else {
      return ApiException(ApiErrorType.unexpected, message: error.toString());
    }
  }
}
