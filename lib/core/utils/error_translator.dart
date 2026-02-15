import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../api/api_exceptions.dart';

String getErrorMessage(ApiException error, BuildContext context) {
  final localizations = AppLocalizations.of(context)!;

  switch (error.type) {
    case ApiErrorType.connectionTimeout:
    case ApiErrorType.sendTimeout:
    case ApiErrorType.receiveTimeout:
      return localizations.apiConnectionTimeout;

    case ApiErrorType.badRequest:
      return localizations.apiBadRequest;

    case ApiErrorType.unauthorized:
      return localizations.apiUnauthorized;

    case ApiErrorType.notFound:
      return localizations.apiNotFound;
    case ApiErrorType.noActivePlan:
      return localizations.apiNoActivePlan;

    case ApiErrorType.phoneNumberExists:
      return localizations.apiPhoneNumberExists;

    case ApiErrorType.serverError:
      return localizations.apiServerError;

    case ApiErrorType.cancel:
      return localizations.apiRequestCancelled;

    case ApiErrorType.noInternet:
      return localizations.apiNoInternetConnection;

    case ApiErrorType.oldPasswordIncorrect:
      return localizations.apiOldPasswordIncorrect;

    case ApiErrorType.unexpectedWithCode:
      return localizations.apiUnexpectedErrorWithCode(
        error.statusCode.toString(),
      );

    case ApiErrorType.unknown:
      return localizations.apiUnknownError;

    case ApiErrorType.unexpected:
    default:
      return localizations.apiUnexpectedError;
  }
}
