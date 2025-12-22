import 'package:flutter/material.dart';

class AppColors {
  // Private constructor
  AppColors._();

  // Light Theme Colors
  static const Color lightPrimary = Color(0xFF8D6E63); // بني فاتح كمحور رئيسي
  static const Color lightPrimaryLight = Color(0xFFBE9C91);
  static const Color lightPrimaryDark = Color(0xFF5F4339);
  static const Color lightSecondary = Color(0xFFD7CCC8); // بيج ناعم كلون ثانوي
  static const Color lightBackground = Color(0xFFFFFBF5); // خلفية بيضاء دافئة
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF5D4037); // نص بني داكن
  static const Color lightTextSecondary = Color(0xFF8D6E63);
  static const Color lightDivider = Color(0xFFE0E0E0);

  // Dark Theme Colors
  static const Color darkPrimary = Color(0xFF4E342E); // بني غامق
  static const Color darkPrimaryLight = Color(0xFF795548);
  static const Color darkPrimaryDark = Color(0xFF3E2723);
  static const Color darkSecondary = Color(0xFF795548); // بني متوسط
  static const Color darkBackground = Color(0xFF2C2C2C); // خلفية رمادية داكنة
  static const Color darkSurface = Color(0xFF3C3C3C);
  static const Color darkText = Color(0xFFECECEC); // نص أبيض مريح
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkDivider = Color(0xFF4A4A4A);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF2196F3);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightPrimary, lightPrimaryDark],
  );

  static const LinearGradient darkPrimaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkPrimaryLight, darkPrimary],
  );

  // Card overlays
  static const Color cardOverlay = Color(0x99000000);
  static const Color cardOverlayLight = Color(0x66000000);
}
