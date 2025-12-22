import 'package:eng_alaa_hammed/features/settings/domain/entities/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppSettings', () {
    group('constructor', () {
      test('should have correct default values', () {
        const settings = AppSettings();

        expect(settings.themeMode, ThemeMode.system);
        expect(settings.languageCode, 'ar');
        expect(settings.notificationsEnabled, true);
        expect(settings.videoQuality, 'auto');
        expect(settings.autoPlayEnabled, false);
      });

      test('should accept custom values', () {
        const settings = AppSettings(
          themeMode: ThemeMode.dark,
          languageCode: 'en',
          notificationsEnabled: false,
          videoQuality: '720p',
          autoPlayEnabled: true,
        );

        expect(settings.themeMode, ThemeMode.dark);
        expect(settings.languageCode, 'en');
        expect(settings.notificationsEnabled, false);
        expect(settings.videoQuality, '720p');
        expect(settings.autoPlayEnabled, true);
      });
    });

    group('copyWith', () {
      test('should return new instance with updated themeMode', () {
        const original = AppSettings();
        final updated = original.copyWith(themeMode: ThemeMode.dark);

        expect(updated.themeMode, ThemeMode.dark);
        expect(updated.languageCode, original.languageCode);
        expect(updated.notificationsEnabled, original.notificationsEnabled);
        expect(updated.videoQuality, original.videoQuality);
        expect(updated.autoPlayEnabled, original.autoPlayEnabled);
      });

      test('should return new instance with updated languageCode', () {
        const original = AppSettings();
        final updated = original.copyWith(languageCode: 'en');

        expect(updated.themeMode, original.themeMode);
        expect(updated.languageCode, 'en');
        expect(updated.notificationsEnabled, original.notificationsEnabled);
        expect(updated.videoQuality, original.videoQuality);
        expect(updated.autoPlayEnabled, original.autoPlayEnabled);
      });

      test('should return new instance with updated notificationsEnabled', () {
        const original = AppSettings();
        final updated = original.copyWith(notificationsEnabled: false);

        expect(updated.themeMode, original.themeMode);
        expect(updated.languageCode, original.languageCode);
        expect(updated.notificationsEnabled, false);
        expect(updated.videoQuality, original.videoQuality);
        expect(updated.autoPlayEnabled, original.autoPlayEnabled);
      });

      test('should return new instance with updated videoQuality', () {
        const original = AppSettings();
        final updated = original.copyWith(videoQuality: '1080p');

        expect(updated.themeMode, original.themeMode);
        expect(updated.languageCode, original.languageCode);
        expect(updated.notificationsEnabled, original.notificationsEnabled);
        expect(updated.videoQuality, '1080p');
        expect(updated.autoPlayEnabled, original.autoPlayEnabled);
      });

      test('should return new instance with updated autoPlayEnabled', () {
        const original = AppSettings();
        final updated = original.copyWith(autoPlayEnabled: true);

        expect(updated.themeMode, original.themeMode);
        expect(updated.languageCode, original.languageCode);
        expect(updated.notificationsEnabled, original.notificationsEnabled);
        expect(updated.videoQuality, original.videoQuality);
        expect(updated.autoPlayEnabled, true);
      });

      test('should return unchanged instance when no parameters provided', () {
        const original = AppSettings(
          themeMode: ThemeMode.dark,
          languageCode: 'en',
          notificationsEnabled: false,
          videoQuality: '720p',
          autoPlayEnabled: true,
        );
        final updated = original.copyWith();

        expect(updated.themeMode, original.themeMode);
        expect(updated.languageCode, original.languageCode);
        expect(updated.notificationsEnabled, original.notificationsEnabled);
        expect(updated.videoQuality, original.videoQuality);
        expect(updated.autoPlayEnabled, original.autoPlayEnabled);
      });
    });

    group('videoQualityOptions', () {
      test('should contain expected quality options', () {
        expect(AppSettings.videoQualityOptions, contains('auto'));
        expect(AppSettings.videoQualityOptions, contains('1080p'));
        expect(AppSettings.videoQualityOptions, contains('720p'));
        expect(AppSettings.videoQualityOptions, contains('480p'));
        expect(AppSettings.videoQualityOptions, contains('360p'));
      });

      test('should have auto as first option', () {
        expect(AppSettings.videoQualityOptions.first, 'auto');
      });
    });

    group('themeModeDisplayName', () {
      test('should return Light for ThemeMode.light', () {
        const settings = AppSettings(themeMode: ThemeMode.light);
        expect(settings.themeModeDisplayName, 'Light');
      });

      test('should return Dark for ThemeMode.dark', () {
        const settings = AppSettings(themeMode: ThemeMode.dark);
        expect(settings.themeModeDisplayName, 'Dark');
      });

      test('should return System for ThemeMode.system', () {
        const settings = AppSettings(themeMode: ThemeMode.system);
        expect(settings.themeModeDisplayName, 'System');
      });
    });

    group('languageDisplayName', () {
      test('should return Arabic name for ar', () {
        const settings = AppSettings(languageCode: 'ar');
        expect(settings.languageDisplayName, 'العربية');
      });

      test('should return English name for en', () {
        const settings = AppSettings(languageCode: 'en');
        expect(settings.languageDisplayName, 'English');
      });

      test('should return language code for unknown language', () {
        const settings = AppSettings(languageCode: 'fr');
        expect(settings.languageDisplayName, 'fr');
      });
    });
  });
}
