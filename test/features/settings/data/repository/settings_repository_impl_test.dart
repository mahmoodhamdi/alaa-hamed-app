import 'package:eng_alaa_hammed/features/settings/data/repository/settings_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

void main() {
  late MockSharedPreferences mockPrefs;
  late MockGoogleSignIn mockGoogleSignIn;
  late SettingsRepositoryImpl repository;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    mockGoogleSignIn = MockGoogleSignIn();
    repository = SettingsRepositoryImpl(
      prefs: mockPrefs,
      googleSignIn: mockGoogleSignIn,
    );
  });

  group('SettingsRepositoryImpl', () {
    group('loadSettings', () {
      test('should load settings from SharedPreferences', () async {
        when(() => mockPrefs.getInt('theme_mode')).thenReturn(1);
        when(() => mockPrefs.getString('language')).thenReturn('en');
        when(() => mockPrefs.getBool('notifications_enabled')).thenReturn(false);
        when(() => mockPrefs.getString('video_quality')).thenReturn('720p');
        when(() => mockPrefs.getBool('auto_play_enabled')).thenReturn(true);

        final settings = await repository.loadSettings();

        expect(settings.themeMode, ThemeMode.light);
        expect(settings.languageCode, 'en');
        expect(settings.notificationsEnabled, false);
        expect(settings.videoQuality, '720p');
        expect(settings.autoPlayEnabled, true);
      });

      test('should return default values when no preferences are set',
          () async {
        when(() => mockPrefs.getInt('theme_mode')).thenReturn(null);
        when(() => mockPrefs.getString('language')).thenReturn(null);
        when(() => mockPrefs.getBool('notifications_enabled')).thenReturn(null);
        when(() => mockPrefs.getString('video_quality')).thenReturn(null);
        when(() => mockPrefs.getBool('auto_play_enabled')).thenReturn(null);

        final settings = await repository.loadSettings();

        expect(settings.themeMode, ThemeMode.system);
        expect(settings.languageCode, 'ar');
        expect(settings.notificationsEnabled, true);
        expect(settings.videoQuality, 'auto');
        expect(settings.autoPlayEnabled, false);
      });
    });

    group('setThemeMode', () {
      test('should save theme mode to SharedPreferences', () async {
        when(() => mockPrefs.setInt('theme_mode', any()))
            .thenAnswer((_) async => true);

        await repository.setThemeMode(ThemeMode.dark);

        verify(() => mockPrefs.setInt('theme_mode', 2)).called(1);
      });
    });

    group('setLanguage', () {
      test('should save language to SharedPreferences', () async {
        when(() => mockPrefs.setString('language', any()))
            .thenAnswer((_) async => true);

        await repository.setLanguage('en');

        verify(() => mockPrefs.setString('language', 'en')).called(1);
      });
    });

    group('setNotificationsEnabled', () {
      test('should save notifications preference to SharedPreferences',
          () async {
        when(() => mockPrefs.setBool('notifications_enabled', any()))
            .thenAnswer((_) async => true);

        await repository.setNotificationsEnabled(false);

        verify(() => mockPrefs.setBool('notifications_enabled', false))
            .called(1);
      });
    });

    group('setVideoQuality', () {
      test('should save video quality to SharedPreferences', () async {
        when(() => mockPrefs.setString('video_quality', any()))
            .thenAnswer((_) async => true);

        await repository.setVideoQuality('720p');

        verify(() => mockPrefs.setString('video_quality', '720p')).called(1);
      });
    });

    group('setAutoPlayEnabled', () {
      test('should save auto-play preference to SharedPreferences', () async {
        when(() => mockPrefs.setBool('auto_play_enabled', any()))
            .thenAnswer((_) async => true);

        await repository.setAutoPlayEnabled(true);

        verify(() => mockPrefs.setBool('auto_play_enabled', true)).called(1);
      });
    });

    group('signOut', () {
      test('should call GoogleSignIn.signOut', () async {
        when(() => mockGoogleSignIn.signOut())
            .thenAnswer((_) async {});

        await repository.signOut();

        verify(() => mockGoogleSignIn.signOut()).called(1);
      });
    });
  });
}
