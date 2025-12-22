import 'package:flutter/material.dart';

class AppColors {
  // Private constructor
  AppColors._();

  // Light Theme Colors
  static const Color lightPrimary = Color(0xFF6D4C41); // Rich brown
  static const Color lightPrimaryLight = Color(0xFF9C786C);
  static const Color lightPrimaryDark = Color(0xFF40241A);
  static const Color lightSecondary = Color(0xFFFFB74D); // Warm amber accent
  static const Color lightTertiary = Color(0xFF00897B); // Teal for actions
  static const Color lightBackground = Color(0xFFFAF8F5); // Warm off-white
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF5F0EB);
  static const Color lightText = Color(0xFF3E2723); // Deep brown
  static const Color lightTextSecondary = Color(0xFF6D4C41);
  static const Color lightTextTertiary = Color(0xFF8D6E63);
  static const Color lightDivider = Color(0xFFE0D6CF);
  static const Color lightCardBackground = Color(0xFFFFFFFF);

  // Dark Theme Colors
  static const Color darkPrimary = Color(0xFFBCAAA4); // Light brown for dark theme
  static const Color darkPrimaryLight = Color(0xFFD7CCC8);
  static const Color darkPrimaryDark = Color(0xFF8D6E63);
  static const Color darkSecondary = Color(0xFFFFB74D); // Amber
  static const Color darkTertiary = Color(0xFF4DB6AC); // Light teal
  static const Color darkBackground = Color(0xFF1C1C1E); // Near black
  static const Color darkSurface = Color(0xFF2C2C2E);
  static const Color darkSurfaceVariant = Color(0xFF3A3A3C);
  static const Color darkText = Color(0xFFF5F5F5); // Off-white
  static const Color darkTextSecondary = Color(0xFFD7CCC8);
  static const Color darkTextTertiary = Color(0xFFA1887F);
  static const Color darkDivider = Color(0xFF48484A);
  static const Color darkCardBackground = Color(0xFF2C2C2E);

  // Status Colors
  static const Color success = Color(0xFF66BB6A);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFFFB74D);
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color error = Color(0xFFEF5350);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color info = Color(0xFF42A5F5);
  static const Color infoLight = Color(0xFFE3F2FD);

  // Favorite Color
  static const Color favorite = Color(0xFFE91E63);
  static const Color favoriteLight = Color(0xFFFCE4EC);

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

  static const LinearGradient thumbnailGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      Color(0x00000000),
      Color(0x80000000),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // Card overlays
  static const Color cardOverlay = Color(0x99000000);
  static const Color cardOverlayLight = Color(0x40000000);
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  static const Color shimmerBaseDark = Color(0xFF424242);
  static const Color shimmerHighlightDark = Color(0xFF616161);

  // Shadow Colors
  static Color shadowLight = Colors.black.withValues(alpha: 0.08);
  static Color shadowDark = Colors.black.withValues(alpha: 0.2);
}
