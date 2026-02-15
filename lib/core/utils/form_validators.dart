import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class FormValidators {
  static String? validateFullName(String? value, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return localizations.validationEnterName;
    }
    final parts = value.trim().split(RegExp(r'\s+'));
    if (parts.length < 3) {
      return localizations.validationNameThreeParts;
    }
    final nameExp = RegExp(r'^[a-zA-Z\u0600-\u06FF]+$');
    for (var part in parts) {
      if (!nameExp.hasMatch(part)) {
        return localizations.validationNameCharsOnly;
      }
    }
    return null;
  }

  static Map<String, String> extractNameParts(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    String firstName = parts.isNotEmpty ? parts[0] : "";
    String middleName = parts.length > 1 ? parts[1] : "";
    String lastName = parts.length > 2 ? parts.sublist(2).join(' ') : "";
    return {
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
    };
  }

  static String? validateEmail(String? value, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (value == null) return null;
    final v = value.trim();

    if (v.isEmpty) {
      return null;
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      caseSensitive: false,
    );

    if (!emailRegex.hasMatch(v)) {
      return localizations.validationInvalidEmail;
    }

    return null;
  }

  static String? validatePhone(String? value, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return localizations.validationEnterPhone;
    }
    if (value.length < 6) {
      return localizations.validationEnterPhone;
    }
    final phoneRegex = RegExp(r'^\+?[0-9]{9,15}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return localizations.validationInvalidPhone;
    }
    return null;
  }

  static String? validatePassword(String? value, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return localizations.validationEnterPassword;
    }
    if (value.length < 6) {
      return localizations.validationPasswordLength;
    }
    final hasLetterOrSymbol = RegExp(r'[^0-9]').hasMatch(value);
    if (!hasLetterOrSymbol) {
      return localizations.validationPasswordWeak;
    }
    return null;
  }

  static String? validateAge(String? value, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return localizations.validationEnterAge;
    }
    final age = int.tryParse(value.trim());
    if (age == null) {
      return localizations.validationAgeNumberOnly;
    }
    if (age < 15 || age > 120) {
      return localizations.validationAgeRange;
    }
    return null;
  }

  static String? validateRequired(
    String? value,
    String fieldName,
    BuildContext context,
  ) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return localizations.validationFieldRequired(fieldName);
    }
    return null;
  }
}
