import 'package:eng_alaa_hammed/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppThemes {
  // Private constructor
  AppThemes._();

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.lightPrimary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightPrimary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    textTheme: _textTheme(AppColors.lightText),
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      primaryContainer: AppColors.lightPrimaryLight,
      secondary: AppColors.lightSecondary,
      tertiary: AppColors.lightTertiary,
      surface: AppColors.lightSurface,
      surfaceContainerHighest: AppColors.lightSurfaceVariant,
      onSurface: AppColors.lightText,
      onSurfaceVariant: AppColors.lightTextSecondary,
      error: AppColors.error,
      errorContainer: AppColors.errorLight,
    ),
    iconTheme: const IconThemeData(color: AppColors.lightPrimary),
    fontFamily: 'Cairo',
    cardTheme: CardThemeData(
      elevation: 2,
      shadowColor: AppColors.shadowLight,
      color: AppColors.lightCardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: AppColors.shadowLight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.lightPrimary,
        side: const BorderSide(color: AppColors.lightPrimary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.lightPrimary,
        textStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white70,
      indicatorColor: Colors.white,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightSurface,
      selectedItemColor: AppColors.lightPrimary,
      unselectedItemColor: AppColors.lightTextTertiary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.lightSurfaceVariant,
      selectedColor: AppColors.lightPrimary,
      labelStyle: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.lightDivider,
      thickness: 1,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.lightText,
      contentTextStyle: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 14,
        color: Colors.white,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.lightPrimary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: const TextStyle(
        fontFamily: 'Cairo',
        color: AppColors.lightTextTertiary,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.lightSecondary,
      foregroundColor: AppColors.lightText,
      elevation: 4,
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.darkPrimary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkText,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.darkText,
      ),
      iconTheme: const IconThemeData(color: AppColors.darkText),
    ),
    textTheme: _textTheme(AppColors.darkText),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      primaryContainer: AppColors.darkPrimaryDark,
      secondary: AppColors.darkSecondary,
      tertiary: AppColors.darkTertiary,
      surface: AppColors.darkSurface,
      surfaceContainerHighest: AppColors.darkSurfaceVariant,
      onSurface: AppColors.darkText,
      onSurfaceVariant: AppColors.darkTextSecondary,
      error: AppColors.error,
      errorContainer: AppColors.errorLight,
    ),
    iconTheme: const IconThemeData(color: AppColors.darkPrimary),
    fontFamily: 'Cairo',
    cardTheme: CardThemeData(
      elevation: 2,
      shadowColor: AppColors.shadowDark,
      color: AppColors.darkCardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkBackground,
        elevation: 2,
        shadowColor: AppColors.shadowDark,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.darkPrimary,
        side: const BorderSide(color: AppColors.darkPrimary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.darkPrimary,
        textStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: AppColors.darkText,
      unselectedLabelColor: AppColors.darkTextSecondary,
      indicatorColor: AppColors.darkPrimary,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      selectedItemColor: AppColors.darkPrimary,
      unselectedItemColor: AppColors.darkTextTertiary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.darkSurfaceVariant,
      selectedColor: AppColors.darkPrimary,
      labelStyle: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.darkDivider,
      thickness: 1,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.darkSurfaceVariant,
      contentTextStyle: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 14,
        color: AppColors.darkText,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.darkPrimary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: const TextStyle(
        fontFamily: 'Cairo',
        color: AppColors.darkTextTertiary,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.darkSecondary,
      foregroundColor: AppColors.darkBackground,
      elevation: 4,
    ),
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
