import 'package:eng_alaa_hammed/core/helpers/logger_helper.dart';
import 'package:eng_alaa_hammed/core/network/dio_client.dart';
import 'package:eng_alaa_hammed/core/services/connectivity_service.dart';
import 'package:eng_alaa_hammed/core/services/favorites_service.dart';
import 'package:eng_alaa_hammed/core/services/secure_storage_service.dart';
import 'package:eng_alaa_hammed/core/services/video_cache_service.dart';
import 'package:eng_alaa_hammed/core/services/watch_history_service.dart';
import 'package:eng_alaa_hammed/features/auth/data/repository/google_auth_repository_impl.dart';
import 'package:eng_alaa_hammed/features/auth/domain/repository/auth_repository.dart';
import 'package:eng_alaa_hammed/features/auth/domain/usecases/check_auth_use_case.dart';
import 'package:eng_alaa_hammed/features/auth/domain/usecases/oauth_use_case.dart';
import 'package:eng_alaa_hammed/features/auth/presentation/logic/auth_cubit.dart';
import 'package:eng_alaa_hammed/features/favorites/presentation/logic/favorites_cubit.dart';
import 'package:eng_alaa_hammed/features/playlists/data/repository/playlist_repository_impl.dart';
import 'package:eng_alaa_hammed/features/playlists/domain/repository/playlist_repository.dart';
import 'package:eng_alaa_hammed/features/playlists/domain/usecases/get_playlist_videos_use_case.dart';
import 'package:eng_alaa_hammed/features/playlists/domain/usecases/get_playlists_use_case.dart';
import 'package:eng_alaa_hammed/features/playlists/presentation/logic/playlist_videos_cubit.dart';
import 'package:eng_alaa_hammed/features/playlists/presentation/logic/playlists_cubit.dart';
import 'package:eng_alaa_hammed/features/settings/data/repository/settings_repository_impl.dart';
import 'package:eng_alaa_hammed/features/settings/domain/repository/settings_repository.dart';
import 'package:eng_alaa_hammed/features/settings/presentation/logic/settings_cubit.dart';
import 'package:eng_alaa_hammed/features/splash/logic/splash_cubit.dart';
import 'package:eng_alaa_hammed/features/videos/data/data_sources/youtube_service.dart';
import 'package:eng_alaa_hammed/features/videos/data/repository/video_repository_impl.dart';
import 'package:eng_alaa_hammed/features/videos/domain/repository/video_repository.dart';
import 'package:eng_alaa_hammed/features/videos/domain/usecases/get_videos_use_case.dart';
import 'package:eng_alaa_hammed/features/videos/presentation/logic/all_videos_cubit.dart';
import 'package:eng_alaa_hammed/features/watch_history/presentation/logic/watch_history_cubit.dart';
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

  // Registering SecureStorageService
  getIt.registerLazySingleton<SecureStorageService>(
      () => SecureStorageService());
  LoggerHelper.info('SecureStorageService registered.');

  // Registering ConnectivityService
  getIt.registerLazySingleton<ConnectivityService>(
      () => ConnectivityService());
  LoggerHelper.info('ConnectivityService registered.');

  // Registering VideoCacheService
  final videoCacheService = VideoCacheService();
  await videoCacheService.init();
  getIt.registerSingleton<VideoCacheService>(videoCacheService);
  LoggerHelper.info('VideoCacheService registered.');

  // Registering FavoritesService
  final favoritesService = FavoritesService();
  await favoritesService.init();
  getIt.registerSingleton<FavoritesService>(favoritesService);
  LoggerHelper.info('FavoritesService registered.');

  // Registering WatchHistoryService
  final watchHistoryService = WatchHistoryService();
  await watchHistoryService.init();
  getIt.registerSingleton<WatchHistoryService>(watchHistoryService);
  LoggerHelper.info('WatchHistoryService registered.');

  // Registering DioClient
  getIt.registerLazySingleton<DioClient>(() => DioClient());
  LoggerHelper.info('DioClient registered.');

  // Registering YouTubeService
  getIt.registerLazySingleton<YouTubeService>(
      () => YouTubeService(dioClient: getIt<DioClient>()));
  LoggerHelper.info('YouTubeService registered.');

  // Registering VideoRepository
  getIt.registerLazySingleton<VideoRepository>(() => VideoRepositoryImpl(
        youTubeService: getIt<YouTubeService>(),
        cacheService: getIt<VideoCacheService>(),
        connectivityService: getIt<ConnectivityService>(),
      ));
  LoggerHelper.info('VideoRepository registered.');

  // Registering GetVideosUseCase
  getIt.registerLazySingleton<GetVideosUseCase>(
      () => GetVideosUseCase(getIt<VideoRepository>()));
  LoggerHelper.info('GetVideosUseCase registered.');

  // Registering VideoCubit
  getIt
      .registerFactory<VideoCubit>(() => VideoCubit(getIt<GetVideosUseCase>()));
  LoggerHelper.info('VideoCubit registered.');

  // Registering PlaylistRepository
  getIt.registerLazySingleton<PlaylistRepository>(
      () => PlaylistRepositoryImpl(youTubeService: getIt<YouTubeService>()));
  LoggerHelper.info('PlaylistRepository registered.');

  // Registering GetPlaylistsUseCase
  getIt.registerLazySingleton<GetPlaylistsUseCase>(
      () => GetPlaylistsUseCase(getIt<PlaylistRepository>()));
  LoggerHelper.info('GetPlaylistsUseCase registered.');

  // Registering GetPlaylistVideosUseCase
  getIt.registerLazySingleton<GetPlaylistVideosUseCase>(
      () => GetPlaylistVideosUseCase(getIt<PlaylistRepository>()));
  LoggerHelper.info('GetPlaylistVideosUseCase registered.');

  // Registering PlaylistsCubit
  getIt.registerFactory<PlaylistsCubit>(
      () => PlaylistsCubit(getIt<GetPlaylistsUseCase>()));
  LoggerHelper.info('PlaylistsCubit registered.');

  // Registering PlaylistVideosCubit
  getIt.registerFactory<PlaylistVideosCubit>(
      () => PlaylistVideosCubit(getIt<GetPlaylistVideosUseCase>()));
  LoggerHelper.info('PlaylistVideosCubit registered.');

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

  // Registering CheckAuthUseCase
  getIt.registerLazySingleton<CheckAuthUseCase>(
      () => CheckAuthUseCase(getIt<AuthRepository>()));
  LoggerHelper.info('CheckAuthUseCase registered.');

  // Registering AuthCubit
  getIt.registerFactory<AuthCubit>(() => AuthCubit(
        oAuthUseCase: getIt<OAuthUseCase>(),
        secureStorageService: getIt<SecureStorageService>(),
      ));
  LoggerHelper.info('AuthCubit registered.');

  // Registering SplashCubit
  getIt.registerFactory<SplashCubit>(
      () => SplashCubit(getIt<CheckAuthUseCase>()));
  LoggerHelper.info('SplashCubit registered.');

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

  // Registering FavoritesCubit (singleton to share state across app)
  getIt.registerLazySingleton<FavoritesCubit>(
      () => FavoritesCubit(getIt<FavoritesService>()));
  LoggerHelper.info('FavoritesCubit registered.');

  // Registering WatchHistoryCubit (singleton to share state across app)
  getIt.registerLazySingleton<WatchHistoryCubit>(
      () => WatchHistoryCubit(getIt<WatchHistoryService>()));
  LoggerHelper.info('WatchHistoryCubit registered.');

  LoggerHelper.debug('Service locator setup completed.');
}
