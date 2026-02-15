import 'package:flutter/material.dart';
import 'app_colors.dart';

class TTextTheme {
  TTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: TextStyle(fontFamily: 'Tajawal',
      fontSize: 32.0,
      fontWeight: FontWeight.w700,
      color: TColors.textPrimary,
    ),
    headlineMedium: TextStyle(fontFamily: 'Tajawal',
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
      color: TColors.textPrimary,
    ),
    headlineSmall: TextStyle(fontFamily: 'Tajawal',
      fontSize: 18.0,
      fontWeight: FontWeight.w700,
      color: TColors.textPrimary,
    ),

    titleLarge: TextStyle(fontFamily: 'Tajawal',
      fontSize: 16.0,
      fontWeight: FontWeight.w700,
      color: TColors.textPrimary,
    ),
    titleMedium: TextStyle(fontFamily: 'Tajawal',
      fontSize: 16.0,
      fontWeight: FontWeight.w700,
      color: TColors.textPrimary,
    ),
    titleSmall: TextStyle(fontFamily: 'Tajawal',
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      color: TColors.textSecondary,
    ),

    bodyLarge: TextStyle(fontFamily: 'Tajawal',
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: TColors.textPrimary,
    ),
    bodyMedium: TextStyle(fontFamily: 'Tajawal',
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: TColors.textSecondary,
    ),
    bodySmall: TextStyle(fontFamily: 'Tajawal',
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      color: TColors.textPrimary.withOpacity(0.5),
    ),

    labelLarge: TextStyle(fontFamily: 'Tajawal',
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: TColors.textPrimary,
    ),
  );
}
