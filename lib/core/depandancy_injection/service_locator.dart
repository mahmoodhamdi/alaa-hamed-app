import 'package:eng_alaa_hammed/core/network/dio_client.dart';
import 'package:eng_alaa_hammed/features/videos/data/data_sources/youtube_service.dart';
import 'package:eng_alaa_hammed/features/videos/data/repository/video_repository_impl.dart';
import 'package:eng_alaa_hammed/features/videos/domain/repository/video_repository.dart';
import 'package:eng_alaa_hammed/features/videos/domain/usecases/get_videos_use_case.dart';
import 'package:eng_alaa_hammed/features/videos/presentation/logic/all_videos_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Registering DioClient
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  // Registering YouTubeService
  getIt.registerLazySingleton<YouTubeService>(
      () => YouTubeService(dioClient: getIt<DioClient>()));

  // Registering VideoRepository
  getIt.registerLazySingleton<VideoRepository>(
      () => VideoRepositoryImpl(youTubeService: getIt<YouTubeService>()));

  // Registering GetVideosUseCase
  getIt.registerLazySingleton<GetVideosUseCase>(
      () => GetVideosUseCase(getIt<VideoRepository>()));

  // Registering VideoCubit
  getIt
      .registerFactory<VideoCubit>(() => VideoCubit(getIt<GetVideosUseCase>()));
}
