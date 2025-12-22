import 'package:flutter/material.dart';

import '../entities/app_settings.dart';

/// Repository interface for settings operations.
abstract class SettingsRepository {
  /// Loads settings from persistent storage.
  Future<AppSettings> loadSettings();

  /// Saves settings to persistent storage.
  Future<void> saveSettings(AppSettings settings);

  /// Updates theme mode preference.
  Future<void> setThemeMode(ThemeMode themeMode);

  /// Updates language preference.
  Future<void> setLanguage(String languageCode);

  /// Updates notifications preference.
  Future<void> setNotificationsEnabled(bool enabled);

  /// Updates video quality preference.
  Future<void> setVideoQuality(String quality);

  /// Updates auto-play preference.
  Future<void> setAutoPlayEnabled(bool enabled);

  /// Clears all cached data.
  Future<void> clearCache();

  /// Signs out the user.
  Future<void> signOut();
}
