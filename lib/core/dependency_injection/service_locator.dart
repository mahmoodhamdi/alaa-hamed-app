import 'package:eng_alaa_hammed/core/helpers/logger_helper.dart';
import 'package:eng_alaa_hammed/core/network/dio_client.dart';
import 'package:eng_alaa_hammed/features/auth/data/repository/google_auth_repository_impl.dart';
import 'package:eng_alaa_hammed/features/auth/domain/repository/auth_repository.dart';
import 'package:eng_alaa_hammed/features/auth/domain/usecases/oauth_use_case.dart';
import 'package:eng_alaa_hammed/features/auth/presentation/logic/auth_cubit.dart';
import 'package:eng_alaa_hammed/features/settings/data/repository/settings_repository_impl.dart';
import 'package:eng_alaa_hammed/features/settings/domain/repository/settings_repository.dart';
import 'package:eng_alaa_hammed/features/settings/presentation/logic/settings_cubit.dart';
import 'package:eng_alaa_hammed/features/videos/data/data_sources/youtube_service.dart';
import 'package:eng_alaa_hammed/features/videos/data/repository/video_repository_impl.dart';
import 'package:eng_alaa_hammed/features/videos/domain/repository/video_repository.dart';
import 'package:eng_alaa_hammed/features/videos/domain/usecases/get_videos_use_case.dart';
import 'package:eng_alaa_hammed/features/videos/presentation/logic/all_videos_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;
// lib/core/service_locator.dart

Future<void> setupServiceLocator() async {
  LoggerHelper.debug('Setting up service locator...');

  // Registering SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  LoggerHelper.info('SharedPreferences registered.');

  // Registering DioClient
  getIt.registerLazySingleton<DioClient>(() => DioClient());
  LoggerHelper.info('DioClient registered.');

  // Registering YouTubeService
  getIt.registerLazySingleton<YouTubeService>(
      () => YouTubeService(dioClient: getIt<DioClient>()));
  LoggerHelper.info('YouTubeService registered.');

  // Registering VideoRepository
  getIt.registerLazySingleton<VideoRepository>(
      () => VideoRepositoryImpl(youTubeService: getIt<YouTubeService>()));
  LoggerHelper.info('VideoRepository registered.');

  // Registering GetVideosUseCase
  getIt.registerLazySingleton<GetVideosUseCase>(
      () => GetVideosUseCase(getIt<VideoRepository>()));
  LoggerHelper.info('GetVideosUseCase registered.');

  // Registering VideoCubit
  getIt
      .registerFactory<VideoCubit>(() => VideoCubit(getIt<GetVideosUseCase>()));
  LoggerHelper.info('VideoCubit registered.');

  // Registering GoogleSignIn instance
  getIt.registerLazySingleton<GoogleSignIn>(
      () => GoogleSignIn(scopes: ['email']));
  LoggerHelper.info('GoogleSignIn instance registered.');

  // Registering AuthRepository (for OAuth)
  getIt.registerLazySingleton<AuthRepository>(
      () => GoogleAuthRepositoryImpl(getIt<GoogleSignIn>()));
  LoggerHelper.info('GoogleAuthRepository registered.');

  // Registering OAuthUseCase
  getIt.registerLazySingleton<OAuthUseCase>(
      () => OAuthUseCase(getIt<AuthRepository>()));
  LoggerHelper.info('OAuthUseCase registered.');

  // Registering AuthCubit
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<OAuthUseCase>()));
  LoggerHelper.info('AuthCubit registered.');

  // Registering SettingsRepository
  getIt.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(
        prefs: getIt<SharedPreferences>(),
        googleSignIn: getIt<GoogleSignIn>(),
      ));
  LoggerHelper.info('SettingsRepository registered.');

  // Registering SettingsCubit (singleton to share state across app)
  getIt.registerLazySingleton<SettingsCubit>(
      () => SettingsCubit(getIt<SettingsRepository>()));
  LoggerHelper.info('SettingsCubit registered.');

  LoggerHelper.debug('Service locator setup completed.');
}
