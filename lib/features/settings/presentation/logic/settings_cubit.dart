import 'package:eng_alaa_hammed/core/helpers/logger_helper.dart';
import 'package:eng_alaa_hammed/features/settings/domain/entities/app_settings.dart';
import 'package:eng_alaa_hammed/features/settings/domain/repository/settings_repository.dart';
import 'package:eng_alaa_hammed/features/settings/presentation/logic/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit for managing app settings.
class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _repository;

  SettingsCubit(this._repository) : super(const SettingsState());

  /// Loads settings from persistent storage.
  Future<void> loadSettings() async {
    emit(state.copyWith(isLoading: true));
    try {
      final settings = await _repository.loadSettings();
      emit(state.copyWith(settings: settings, isLoading: false));
      LoggerHelper.info('Settings loaded successfully');
    } catch (e) {
      LoggerHelper.error('Failed to load settings', e);
      emit(state.copyWith(isLoading: false));
    }
  }

  /// Updates theme mode.
  Future<void> setThemeMode(ThemeMode themeMode) async {
    try {
      await _repository.setThemeMode(themeMode);
      emit(state.copyWith(
        settings: state.settings.copyWith(themeMode: themeMode),
      ));
    } catch (e) {
      LoggerHelper.error('Failed to set theme mode', e);
    }
  }

  /// Updates language.
  Future<void> setLanguage(String languageCode) async {
    try {
      await _repository.setLanguage(languageCode);
      emit(state.copyWith(
        settings: state.settings.copyWith(languageCode: languageCode),
      ));
    } catch (e) {
      LoggerHelper.error('Failed to set language', e);
    }
  }

  /// Updates notifications preference.
  Future<void> setNotificationsEnabled(bool enabled) async {
    try {
      await _repository.setNotificationsEnabled(enabled);
      emit(state.copyWith(
        settings: state.settings.copyWith(notificationsEnabled: enabled),
      ));
    } catch (e) {
      LoggerHelper.error('Failed to set notifications', e);
    }
  }

  /// Updates video quality preference.
  Future<void> setVideoQuality(String quality) async {
    try {
      await _repository.setVideoQuality(quality);
      emit(state.copyWith(
        settings: state.settings.copyWith(videoQuality: quality),
      ));
    } catch (e) {
      LoggerHelper.error('Failed to set video quality', e);
    }
  }

  /// Updates auto-play preference.
  Future<void> setAutoPlayEnabled(bool enabled) async {
    try {
      await _repository.setAutoPlayEnabled(enabled);
      emit(state.copyWith(
        settings: state.settings.copyWith(autoPlayEnabled: enabled),
      ));
    } catch (e) {
      LoggerHelper.error('Failed to set auto-play', e);
    }
  }

  /// Clears app cache.
  Future<void> clearCache() async {
    emit(state.copyWith(isLoading: true));
    try {
      await _repository.clearCache();
      emit(state.copyWith(
        isLoading: false,
        message: 'Cache cleared successfully',
      ));
    } catch (e) {
      LoggerHelper.error('Failed to clear cache', e);
      emit(state.copyWith(
        isLoading: false,
        message: 'Failed to clear cache',
      ));
    }
  }

  /// Signs out the user.
  Future<bool> signOut() async {
    emit(state.copyWith(isLoading: true));
    try {
      await _repository.signOut();
      emit(state.copyWith(
        isLoading: false,
        settings: const AppSettings(),
      ));
      return true;
    } catch (e) {
      LoggerHelper.error('Failed to sign out', e);
      emit(state.copyWith(
        isLoading: false,
        message: 'Failed to sign out',
      ));
      return false;
    }
  }

  /// Clears the current message.
  void clearMessage() {
    emit(state.copyWith(clearMessage: true));
  }
}
