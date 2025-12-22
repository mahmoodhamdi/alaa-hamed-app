import 'package:bloc_test/bloc_test.dart';
import 'package:eng_alaa_hammed/features/settings/domain/entities/app_settings.dart';
import 'package:eng_alaa_hammed/features/settings/domain/repository/settings_repository.dart';
import 'package:eng_alaa_hammed/features/settings/presentation/logic/settings_cubit.dart';
import 'package:eng_alaa_hammed/features/settings/presentation/logic/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(ThemeMode.system);
  });

  late MockSettingsRepository mockRepository;
  late SettingsCubit settingsCubit;

  setUp(() {
    mockRepository = MockSettingsRepository();
    settingsCubit = SettingsCubit(mockRepository);
  });

  tearDown(() {
    settingsCubit.close();
  });

  group('SettingsCubit', () {
    test('initial state should be SettingsState with default values', () {
      expect(settingsCubit.state, const SettingsState());
    });

    group('loadSettings', () {
      const testSettings = AppSettings(
        themeMode: ThemeMode.dark,
        languageCode: 'en',
        notificationsEnabled: false,
        videoQuality: '720p',
        autoPlayEnabled: true,
      );

      blocTest<SettingsCubit, SettingsState>(
        'emits [loading, loaded] when loadSettings is successful',
        build: () {
          when(() => mockRepository.loadSettings())
              .thenAnswer((_) async => testSettings);
          return SettingsCubit(mockRepository);
        },
        act: (cubit) => cubit.loadSettings(),
        expect: () => [
          const SettingsState(isLoading: true),
          const SettingsState(settings: testSettings, isLoading: false),
        ],
        verify: (_) {
          verify(() => mockRepository.loadSettings()).called(1);
        },
      );

      blocTest<SettingsCubit, SettingsState>(
        'emits [loading, loaded with default] when loadSettings fails',
        build: () {
          when(() => mockRepository.loadSettings())
              .thenThrow(Exception('Failed to load'));
          return SettingsCubit(mockRepository);
        },
        act: (cubit) => cubit.loadSettings(),
        expect: () => [
          const SettingsState(isLoading: true),
          const SettingsState(isLoading: false),
        ],
      );
    });

    group('setThemeMode', () {
      blocTest<SettingsCubit, SettingsState>(
        'emits state with updated themeMode when successful',
        build: () {
          when(() => mockRepository.setThemeMode(ThemeMode.dark))
              .thenAnswer((_) async {});
          return SettingsCubit(mockRepository);
        },
        act: (cubit) => cubit.setThemeMode(ThemeMode.dark),
        expect: () => [
          const SettingsState(
            settings: AppSettings(themeMode: ThemeMode.dark),
          ),
        ],
        verify: (_) {
          verify(() => mockRepository.setThemeMode(ThemeMode.dark)).called(1);
        },
      );

      blocTest<SettingsCubit, SettingsState>(
        'does not emit when setThemeMode fails',
        build: () {
          when(() => mockRepository.setThemeMode(any()))
              .thenThrow(Exception('Failed'));
          return SettingsCubit(mockRepository);
        },
        act: (cubit) => cubit.setThemeMode(ThemeMode.dark),
        expect: () => [],
      );
    });

    group('setLanguage', () {
      blocTest<SettingsCubit, SettingsState>(
        'emits state with updated languageCode when successful',
        build: () {
          when(() => mockRepository.setLanguage('en'))
              .thenAnswer((_) async {});
          return SettingsCubit(mockRepository);
        },
        act: (cubit) => cubit.setLanguage('en'),
        expect: () => [
          const SettingsState(
            settings: AppSettings(languageCode: 'en'),
          ),
        ],
        verify: (_) {
          verify(() => mockRepository.setLanguage('en')).called(1);
        },
      );

      blocTest<SettingsCubit, SettingsState>(
        'does not emit when setLanguage fails',
        build: () {
          when(() => mockRepository.setLanguage(any()))
              .thenThrow(Exception('Failed'));
          return SettingsCubit(mockRepository);
        },
        act: (cubit) => cubit.setLanguage('en'),
        expect: () => [],
      );
    });

    group('setNotificationsEnabled', () {
      blocTest<SettingsCubit, SettingsState>(
        'emits state with updated notificationsEnabled when successful',
        build: () {
          when(() => mockRepository.setNotificationsEnabled(false))
              .thenAnswer((_) async {});
          return SettingsCubit(mockRepository);
        },
        act: (cubit) => cubit.setNotificationsEnabled(false),
        expect: () => [
          const SettingsState(
            settings: AppSettings(notificationsEnabled: false),
          ),
        ],
        verify: (_) {
          verify(() => mockRepository.setNotificationsEnabled(false)).called(1);
        },
      );
    });

    group('setVideoQuality', () {
      blocTest<SettingsCubit, SettingsState>(
        'emits state with updated videoQuality when successful',
        build: () {
          when(() => mockRepository.setVideoQuality('720p'))
              .thenAnswer((_) async {});
          return SettingsCubit(mockRepository);
        },
        act: (cubit) => cubit.setVideoQuality('720p'),
        expect: () => [
          const SettingsState(
            settings: AppSettings(videoQuality: '720p'),
          ),
        ],
        verify: (_) {
          verify(() => mockRepository.setVideoQuality('720p')).called(1);
        },
      );
    });

    group('setAutoPlayEnabled', () {
      blocTest<SettingsCubit, SettingsState>(
        'emits state with updated autoPlayEnabled when successful',
        build: () {
          when(() => mockRepository.setAutoPlayEnabled(true))
              .thenAnswer((_) async {});
          return SettingsCubit(mockRepository);
        },
        act: (cubit) => cubit.setAutoPlayEnabled(true),
        expect: () => [
          const SettingsState(
            settings: AppSettings(autoPlayEnabled: true),
          ),
        ],
        verify: (_) {
          verify(() => mockRepository.setAutoPlayEnabled(true)).called(1);
        },
      );
    });

    group('clearCache', () {
      blocTest<SettingsCubit, SettingsState>(
        'emits [loading, success message] when clearCache is successful',
        build: () {
          when(() => mockRepository.clearCache()).thenAnswer((_) async {});
          return SettingsCubit(mockRepository);
        },
        act: (cubit) => cubit.clearCache(),
        expect: () => [
          const SettingsState(isLoading: true),
          const SettingsState(
            isLoading: false,
            message: 'Cache cleared successfully',
          ),
        ],
        verify: (_) {
          verify(() => mockRepository.clearCache()).called(1);
        },
      );

      blocTest<SettingsCubit, SettingsState>(
        'emits [loading, error message] when clearCache fails',
        build: () {
          when(() => mockRepository.clearCache())
              .thenThrow(Exception('Failed'));
          return SettingsCubit(mockRepository);
        },
        act: (cubit) => cubit.clearCache(),
        expect: () => [
          const SettingsState(isLoading: true),
          const SettingsState(
            isLoading: false,
            message: 'Failed to clear cache',
          ),
        ],
      );
    });

    group('signOut', () {
      blocTest<SettingsCubit, SettingsState>(
        'emits [loading, reset settings] and returns true when signOut is successful',
        build: () {
          when(() => mockRepository.signOut()).thenAnswer((_) async {});
          return SettingsCubit(mockRepository);
        },
        act: (cubit) async {
          final result = await cubit.signOut();
          expect(result, true);
        },
        expect: () => [
          const SettingsState(isLoading: true),
          const SettingsState(
            isLoading: false,
            settings: AppSettings(),
          ),
        ],
        verify: (_) {
          verify(() => mockRepository.signOut()).called(1);
        },
      );

      blocTest<SettingsCubit, SettingsState>(
        'emits [loading, error message] and returns false when signOut fails',
        build: () {
          when(() => mockRepository.signOut()).thenThrow(Exception('Failed'));
          return SettingsCubit(mockRepository);
        },
        act: (cubit) async {
          final result = await cubit.signOut();
          expect(result, false);
        },
        expect: () => [
          const SettingsState(isLoading: true),
          const SettingsState(
            isLoading: false,
            message: 'Failed to sign out',
          ),
        ],
      );
    });

    group('clearMessage', () {
      blocTest<SettingsCubit, SettingsState>(
        'emits state with null message',
        build: () => SettingsCubit(mockRepository),
        seed: () => const SettingsState(message: 'Test message'),
        act: (cubit) => cubit.clearMessage(),
        expect: () => [
          const SettingsState(message: null),
        ],
      );
    });
  });
}
