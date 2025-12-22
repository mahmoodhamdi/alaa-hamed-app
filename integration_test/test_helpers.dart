import 'package:dartz/dartz.dart';
import 'package:eng_alaa_hammed/core/error/failures.dart';
import 'package:eng_alaa_hammed/core/network/dio_client.dart';
import 'package:eng_alaa_hammed/features/auth/data/repository/google_auth_repository_impl.dart';
import 'package:eng_alaa_hammed/features/auth/domain/repository/auth_repository.dart';
import 'package:eng_alaa_hammed/features/auth/domain/usecases/oauth_use_case.dart';
import 'package:eng_alaa_hammed/features/auth/presentation/logic/auth_cubit.dart';
import 'package:eng_alaa_hammed/features/videos/data/data_sources/youtube_service.dart';
import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';
import 'package:eng_alaa_hammed/features/videos/domain/repository/video_repository.dart';
import 'package:eng_alaa_hammed/features/videos/domain/usecases/get_videos_use_case.dart';
import 'package:eng_alaa_hammed/features/videos/presentation/logic/all_videos_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

class MockVideoRepository extends Mock implements VideoRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockYouTubeService extends Mock implements YouTubeService {}

class MockDioClient extends Mock implements DioClient {}

// Test data
const testVideos = [
  Video(
    id: 'video1',
    title: 'Test Video 1 - Flutter Tutorial',
    thumbnailUrl: 'https://i.ytimg.com/vi/video1/hqdefault.jpg',
    publishedAt: '2024-01-15T10:00:00Z',
    description: 'Learn Flutter basics in this tutorial',
    videoUrl: 'https://www.youtube.com/watch?v=video1',
  ),
  Video(
    id: 'video2',
    title: 'Test Video 2 - Dart Programming',
    thumbnailUrl: 'https://i.ytimg.com/vi/video2/hqdefault.jpg',
    publishedAt: '2024-01-16T10:00:00Z',
    description: 'Learn Dart programming language',
    videoUrl: 'https://www.youtube.com/watch?v=video2',
  ),
  Video(
    id: 'video3',
    title: 'Test Video 3 - State Management',
    thumbnailUrl: 'https://i.ytimg.com/vi/video3/hqdefault.jpg',
    publishedAt: '2024-01-17T10:00:00Z',
    description: 'Understanding BLoC pattern',
    videoUrl: 'https://www.youtube.com/watch?v=video3',
  ),
];

const testAccessToken = 'test_access_token_integration_12345';

/// Sets up mocked service locator for integration tests
Future<void> setupMockedServiceLocator({
  bool authSuccess = true,
  bool videosSuccess = true,
  List<Video>? videos,
  Duration mockDelay = const Duration(milliseconds: 100),
}) async {
  final getIt = GetIt.instance;

  // Reset service locator
  await getIt.reset();

  // Mock Google Sign In
  final mockGoogleSignIn = MockGoogleSignIn();
  final mockGoogleSignInAccount = MockGoogleSignInAccount();
  final mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();

  if (authSuccess) {
    when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async {
      await Future.delayed(mockDelay);
      return mockGoogleSignInAccount;
    });
    when(() => mockGoogleSignInAccount.authentication)
        .thenAnswer((_) async => mockGoogleSignInAuthentication);
    when(() => mockGoogleSignInAuthentication.accessToken)
        .thenReturn(testAccessToken);
  } else {
    when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async {
      await Future.delayed(mockDelay);
      return null;
    });
  }

  // Mock Video Repository
  final mockVideoRepository = MockVideoRepository();
  if (videosSuccess) {
    when(() => mockVideoRepository.getVideos()).thenAnswer((_) async {
      await Future.delayed(mockDelay);
      return Right(videos ?? testVideos);
    });
  } else {
    when(() => mockVideoRepository.getVideos()).thenAnswer((_) async {
      await Future.delayed(mockDelay);
      return const Left(ServerFailure('Failed to load videos'));
    });
  }

  // Register mocked dependencies
  getIt.registerLazySingleton<DioClient>(() => MockDioClient());
  getIt.registerLazySingleton<YouTubeService>(() => MockYouTubeService());
  getIt.registerLazySingleton<VideoRepository>(() => mockVideoRepository);
  getIt.registerLazySingleton<GetVideosUseCase>(
      () => GetVideosUseCase(getIt<VideoRepository>()));
  getIt.registerFactory<VideoCubit>(() => VideoCubit(getIt<GetVideosUseCase>()));

  getIt.registerLazySingleton<GoogleSignIn>(() => mockGoogleSignIn);
  getIt.registerLazySingleton<AuthRepository>(
      () => GoogleAuthRepositoryImpl(getIt<GoogleSignIn>()));
  getIt.registerLazySingleton<OAuthUseCase>(
      () => OAuthUseCase(getIt<AuthRepository>()));
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<OAuthUseCase>()));
}

/// Cleans up service locator after tests
Future<void> cleanupServiceLocator() async {
  await GetIt.instance.reset();
}
