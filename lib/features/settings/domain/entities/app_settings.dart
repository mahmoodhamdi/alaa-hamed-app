import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Application settings entity.
class AppSettings extends Equatable {
  final ThemeMode themeMode;
  final String languageCode;
  final bool notificationsEnabled;
  final String videoQuality;
  final bool autoPlayEnabled;

  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.languageCode = 'ar',
    this.notificationsEnabled = true,
    this.videoQuality = 'auto',
    this.autoPlayEnabled = false,
  });

  @override
  List<Object?> get props => [
        themeMode,
        languageCode,
        notificationsEnabled,
        videoQuality,
        autoPlayEnabled,
      ];

  AppSettings copyWith({
    ThemeMode? themeMode,
    String? languageCode,
    bool? notificationsEnabled,
    String? videoQuality,
    bool? autoPlayEnabled,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      videoQuality: videoQuality ?? this.videoQuality,
      autoPlayEnabled: autoPlayEnabled ?? this.autoPlayEnabled,
    );
  }

  /// Available video quality options.
  static const List<String> videoQualityOptions = [
    'auto',
    '1080p',
    '720p',
    '480p',
    '360p',
  ];

  /// Theme mode display name.
  String get themeModeDisplayName {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  /// Language display name.
  String get languageDisplayName {
    switch (languageCode) {
      case 'ar':
        return 'العربية';
      case 'en':
        return 'English';
      default:
        return languageCode;
    }
  }
}
