import 'package:flutter_screenutil/flutter_screenutil.dart';

/// App dimensions for consistent spacing and sizing
/// Uses flutter_screenutil for responsive design
/// Design based on iPhone X (375 x 812)
class AppDimensions {
  // Private constructor to prevent instantiation
  AppDimensions._();

  // Responsive Spacing
  static double get spacingXs => 4.h;
  static double get spacingSm => 8.h;
  static double get spacingMd => 16.h;
  static double get spacingLg => 24.h;
  static double get spacingXl => 32.h;
  static double get spacingXxl => 48.h;

  // Responsive Padding
  static double get paddingXs => 4.w;
  static double get paddingSm => 8.w;
  static double get paddingMd => 16.w;
  static double get paddingLg => 24.w;
  static double get paddingXl => 32.w;

  // Responsive Border Radius
  static double get radiusXs => 4.r;
  static double get radiusSm => 8.r;
  static double get radiusMd => 12.r;
  static double get radiusLg => 16.r;
  static double get radiusXl => 24.r;
  static double get radiusFull => 100.r;

  // Card dimensions
  static double get cardElevation => 4.h;
  static double get cardElevationHover => 8.h;

  // Thumbnail dimensions
  static double get thumbnailHeight => 180.h;
  static double get thumbnailHeightSmall => 90.h;
  static double get thumbnailWidth => 120.w;

  // Icon sizes
  static double get iconSizeXs => 14.w;
  static double get iconSizeSm => 18.w;
  static double get iconSizeMd => 24.w;
  static double get iconSizeLg => 32.w;
  static double get iconSizeXl => 48.w;
  static double get iconSizeXxl => 60.w;

  // App bar
  static double get appBarHeight => 56.h;
  static double get tabBarHeight => 48.h;

  // Button dimensions
  static double get buttonHeight => 48.h;
  static double get buttonHeightSmall => 36.h;

  // Avatar sizes
  static double get avatarSizeSm => 32.w;
  static double get avatarSizeMd => 48.w;
  static double get avatarSizeLg => 64.w;

  // Font sizes
  static double get fontSizeXs => 10.sp;
  static double get fontSizeSm => 12.sp;
  static double get fontSizeMd => 14.sp;
  static double get fontSizeLg => 16.sp;
  static double get fontSizeXl => 18.sp;
  static double get fontSizeXxl => 24.sp;
  static double get fontSizeTitle => 20.sp;
  static double get fontSizeHeading => 28.sp;

  // Play button
  static double get playButtonSize => 48.w;
  static double get playButtonIconSize => 32.w;
  static double get playButtonPadding => 12.w;

  // Static values (for places that need constants)
  static const double thumbnailHeightValue = 180.0;
  static const double thumbnailHeightSmallValue = 90.0;
  static const double thumbnailWidthValue = 120.0;
  static const double cardElevationValue = 4.0;
  static const double radiusMdValue = 12.0;
  static const double radiusSmValue = 8.0;
}
