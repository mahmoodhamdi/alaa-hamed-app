import 'package:eng_alaa_hammed/core/constants/colors.dart';
import 'package:flutter/material.dart';

class AppThemes {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.lightPrimary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightPrimary,
      foregroundColor: AppColors.lightText,
      elevation: 0,
    ),
    textTheme: _textTheme(AppColors.lightText),
    colorScheme: ColorScheme.light(
      primary: AppColors.lightPrimary,
      secondary: AppColors.lightSecondary,
      surface: AppColors.lightBackground,
      onSurface: AppColors.lightText,
    ),
    iconTheme: IconThemeData(color: AppColors.lightPrimary),
    fontFamily: 'Cairo',
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.darkPrimary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkPrimary,
      foregroundColor: AppColors.darkText,
      elevation: 0,
    ),
    textTheme: _textTheme(AppColors.darkText),
    colorScheme: ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkSecondary,
      surface: AppColors.darkBackground,
      onSurface: AppColors.darkText,
    ),
    iconTheme: IconThemeData(color: AppColors.darkSecondary),
    fontFamily: 'Cairo',
  );

  // Updated TextTheme
  static TextTheme _textTheme(Color textColor) {
    return TextTheme(
      displayLarge: TextStyle(
          fontSize: 32.0, fontWeight: FontWeight.bold, color: textColor),
      displayMedium: TextStyle(
          fontSize: 28.0, fontWeight: FontWeight.bold, color: textColor),
      displaySmall: TextStyle(
          fontSize: 24.0, fontWeight: FontWeight.w600, color: textColor),
      headlineMedium: TextStyle(
          fontSize: 20.0, fontWeight: FontWeight.w500, color: textColor),
      headlineSmall: TextStyle(
          fontSize: 18.0, fontWeight: FontWeight.w400, color: textColor),
      titleLarge: TextStyle(
          fontSize: 16.0, fontWeight: FontWeight.w400, color: textColor),
      bodyLarge: TextStyle(
          fontSize: 14.0, fontWeight: FontWeight.w400, color: textColor),
      bodyMedium: TextStyle(
          fontSize: 12.0, fontWeight: FontWeight.w400, color: textColor),
      titleMedium: TextStyle(
          fontSize: 14.0, fontWeight: FontWeight.w500, color: textColor),
      titleSmall: TextStyle(
          fontSize: 12.0, fontWeight: FontWeight.w500, color: textColor),
      bodySmall: TextStyle(
          fontSize: 10.0, fontWeight: FontWeight.w300, color: textColor),
    );
  }
}
