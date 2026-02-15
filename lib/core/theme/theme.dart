import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'text_theme.dart';
import 'mushaf_styles.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Tajawal',
    brightness: Brightness.light,
    primaryColor: TColors.primary,
    scaffoldBackgroundColor: TColors.light, 
    textTheme: TTextTheme.lightTextTheme,

    extensions: <ThemeExtension<dynamic>>[
      const MushafStyles(
        quranTextStyle: TextStyle(
          fontFamily: 'Amiri',
          fontWeight: FontWeight.w600,
          height: 2.15,
        ),
      ),
    ],


    dialogTheme: DialogThemeData(
      backgroundColor: TColors.lightContainer,
      surfaceTintColor:
          Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: TColors.textPrimary, size: 24),
      actionsIconTheme: const IconThemeData(
        color: TColors.textPrimary,
        size: 24,
      ),
      titleTextStyle:
          TTextTheme.lightTextTheme.headlineSmall,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: TColors.textWhite,
        backgroundColor: TColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 16,
          color: TColors.textWhite,
          fontWeight: FontWeight.w700,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: TColors.lightContainer,
      selectedItemColor: TColors.secondary,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
    ),

    cardTheme: CardThemeData(
      color: TColors.lightContainer,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          16.0,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: TColors.lightContainer,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(width: 2, color: TColors.primary),
      ),
    ),
  );
}
