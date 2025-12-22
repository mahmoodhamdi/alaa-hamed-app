import 'package:eng_alaa_hammed/features/settings/domain/entities/app_settings.dart';
import 'package:eng_alaa_hammed/features/settings/presentation/logic/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SettingsState', () {
    group('constructor', () {
      test('should have correct default values', () {
        const state = SettingsState();

        expect(state.settings, const AppSettings());
        expect(state.isLoading, false);
        expect(state.message, null);
      });

      test('should accept custom values', () {
        const customSettings = AppSettings(themeMode: ThemeMode.dark);
        const state = SettingsState(
          settings: customSettings,
          isLoading: true,
          message: 'Test message',
        );

        expect(state.settings, customSettings);
        expect(state.isLoading, true);
        expect(state.message, 'Test message');
      });
    });

    group('getters', () {
      test('themeMode should return settings themeMode', () {
        const state = SettingsState(
          settings: AppSettings(themeMode: ThemeMode.dark),
        );
        expect(state.themeMode, ThemeMode.dark);
      });

      test('languageCode should return settings languageCode', () {
        const state = SettingsState(
          settings: AppSettings(languageCode: 'en'),
        );
        expect(state.languageCode, 'en');
      });

      test('locale should return Locale from languageCode', () {
        const state = SettingsState(
          settings: AppSettings(languageCode: 'ar'),
        );
        expect(state.locale, const Locale('ar'));
      });

      test('notificationsEnabled should return settings notificationsEnabled',
          () {
        const state = SettingsState(
          settings: AppSettings(notificationsEnabled: false),
        );
        expect(state.notificationsEnabled, false);
      });

      test('videoQuality should return settings videoQuality', () {
        const state = SettingsState(
          settings: AppSettings(videoQuality: '720p'),
        );
        expect(state.videoQuality, '720p');
      });

      test('autoPlayEnabled should return settings autoPlayEnabled', () {
        const state = SettingsState(
          settings: AppSettings(autoPlayEnabled: true),
        );
        expect(state.autoPlayEnabled, true);
      });
    });

    group('copyWith', () {
      test('should return new instance with updated settings', () {
        const original = SettingsState();
        const newSettings = AppSettings(themeMode: ThemeMode.dark);
        final updated = original.copyWith(settings: newSettings);

        expect(updated.settings, newSettings);
        expect(updated.isLoading, original.isLoading);
        expect(updated.message, original.message);
      });

      test('should return new instance with updated isLoading', () {
        const original = SettingsState();
        final updated = original.copyWith(isLoading: true);

        expect(updated.settings, original.settings);
        expect(updated.isLoading, true);
        expect(updated.message, original.message);
      });

      test('should return new instance with updated message', () {
        const original = SettingsState();
        final updated = original.copyWith(message: 'New message');

        expect(updated.settings, original.settings);
        expect(updated.isLoading, original.isLoading);
        expect(updated.message, 'New message');
      });

      test('should clear message when clearMessage is true', () {
        const original = SettingsState(message: 'Existing message');
        final updated = original.copyWith(clearMessage: true);

        expect(updated.message, null);
      });

      test('should keep existing message when clearMessage is false', () {
        const original = SettingsState(message: 'Existing message');
        final updated = original.copyWith(clearMessage: false);

        expect(updated.message, 'Existing message');
      });

      test('should prefer new message over clearMessage', () {
        const original = SettingsState(message: 'Existing message');
        final updated = original.copyWith(
          message: 'New message',
          clearMessage: true,
        );

        expect(updated.message, null);
      });

      test('should return unchanged instance when no parameters provided', () {
        const original = SettingsState(
          settings: AppSettings(themeMode: ThemeMode.dark),
          isLoading: true,
          message: 'Test',
        );
        final updated = original.copyWith();

        expect(updated.settings, original.settings);
        expect(updated.isLoading, original.isLoading);
        expect(updated.message, original.message);
      });
    });
  });
}
