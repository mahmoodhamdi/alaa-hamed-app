import 'package:eng_alaa_hammed/core/helpers/logger_helper.dart';
import 'package:eng_alaa_hammed/features/settings/domain/entities/app_settings.dart';
import 'package:eng_alaa_hammed/features/settings/domain/repository/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implementation of SettingsRepository using SharedPreferences.
class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferences _prefs;
  final GoogleSignIn _googleSignIn;

  // Keys for SharedPreferences
  static const String _themeModeKey = 'theme_mode';
  static const String _languageKey = 'language';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _videoQualityKey = 'video_quality';
  static const String _autoPlayKey = 'auto_play_enabled';

  SettingsRepositoryImpl({
    required SharedPreferences prefs,
    required GoogleSignIn googleSignIn,
  })  : _prefs = prefs,
        _googleSignIn = googleSignIn;

  @override
  Future<AppSettings> loadSettings() async {
    LoggerHelper.debug('Loading settings from SharedPreferences');

    final themeModeIndex = _prefs.getInt(_themeModeKey) ?? 0;
    final languageCode = _prefs.getString(_languageKey) ?? 'ar';
    final notificationsEnabled = _prefs.getBool(_notificationsKey) ?? true;
    final videoQuality = _prefs.getString(_videoQualityKey) ?? 'auto';
    final autoPlayEnabled = _prefs.getBool(_autoPlayKey) ?? false;

    return AppSettings(
      themeMode: ThemeMode.values[themeModeIndex],
      languageCode: languageCode,
      notificationsEnabled: notificationsEnabled,
      videoQuality: videoQuality,
      autoPlayEnabled: autoPlayEnabled,
    );
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    LoggerHelper.debug('Saving all settings');
    await _prefs.setInt(_themeModeKey, settings.themeMode.index);
    await _prefs.setString(_languageKey, settings.languageCode);
    await _prefs.setBool(_notificationsKey, settings.notificationsEnabled);
    await _prefs.setString(_videoQualityKey, settings.videoQuality);
    await _prefs.setBool(_autoPlayKey, settings.autoPlayEnabled);
  }

  @override
  Future<void> setThemeMode(ThemeMode themeMode) async {
    LoggerHelper.info('Setting theme mode to: ${themeMode.name}');
    await _prefs.setInt(_themeModeKey, themeMode.index);
  }

  @override
  Future<void> setLanguage(String languageCode) async {
    LoggerHelper.info('Setting language to: $languageCode');
    await _prefs.setString(_languageKey, languageCode);
  }

  @override
  Future<void> setNotificationsEnabled(bool enabled) async {
    LoggerHelper.info('Setting notifications enabled: $enabled');
    await _prefs.setBool(_notificationsKey, enabled);
  }

  @override
  Future<void> setVideoQuality(String quality) async {
    LoggerHelper.info('Setting video quality to: $quality');
    await _prefs.setString(_videoQualityKey, quality);
  }

  @override
  Future<void> setAutoPlayEnabled(bool enabled) async {
    LoggerHelper.info('Setting auto-play enabled: $enabled');
    await _prefs.setBool(_autoPlayKey, enabled);
  }

  @override
  Future<void> clearCache() async {
    LoggerHelper.info('Clearing app cache');
    await DefaultCacheManager().emptyCache();
    LoggerHelper.info('Cache cleared successfully');
  }

  @override
  Future<void> signOut() async {
    LoggerHelper.info('Signing out user');
    await _googleSignIn.signOut();
    LoggerHelper.info('User signed out successfully');
  }
}
