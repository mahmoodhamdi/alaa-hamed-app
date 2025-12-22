import 'package:dartz/dartz.dart';
import 'package:eng_alaa_hammed/core/constants/strings.dart';
import 'package:eng_alaa_hammed/core/error/failures.dart';
import 'package:eng_alaa_hammed/core/network/dio_client.dart';
import 'package:eng_alaa_hammed/core/services/secure_storage_service.dart';
import 'package:eng_alaa_hammed/features/auth/data/repository/google_auth_repository_impl.dart';
import 'package:eng_alaa_hammed/features/auth/domain/repository/auth_repository.dart';
import 'package:eng_alaa_hammed/features/auth/domain/usecases/check_auth_use_case.dart';
import 'package:eng_alaa_hammed/features/auth/domain/usecases/oauth_use_case.dart';
import 'package:eng_alaa_hammed/features/auth/presentation/logic/auth_cubit.dart';
import 'package:eng_alaa_hammed/features/auth/presentation/views/auth_view.dart';
import 'package:eng_alaa_hammed/features/splash/logic/splash_cubit.dart';
import 'package:eng_alaa_hammed/features/splash/views/splash_view.dart';
import 'package:eng_alaa_hammed/features/videos/data/data_sources/youtube_service.dart';
import 'package:eng_alaa_hammed/features/videos/data/models/paginated_videos_response.dart';
import 'package:eng_alaa_hammed/features/videos/domain/repository/video_repository.dart';
import 'package:eng_alaa_hammed/features/videos/domain/usecases/get_videos_use_case.dart';
import 'package:eng_alaa_hammed/features/videos/presentation/logic/all_videos_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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

class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockCheckAuthUseCase extends Mock implements CheckAuthUseCase {}

/// Sets up mocked service locator for splash tests
Future<void> setupMockedServiceLocator() async {
  final getIt = GetIt.instance;

  // Reset service locator
  await getIt.reset();

  // Mock Google Sign In
  final mockGoogleSignIn = MockGoogleSignIn();
  final mockGoogleSignInAccount = MockGoogleSignInAccount();
  final mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();

  when(() => mockGoogleSignIn.signIn())
      .thenAnswer((_) async => mockGoogleSignInAccount);
  when(() => mockGoogleSignInAccount.authentication)
      .thenAnswer((_) async => mockGoogleSignInAuthentication);
  when(() => mockGoogleSignInAuthentication.accessToken)
      .thenReturn('test_token');

  // Mock Video Repository
  final mockVideoRepository = MockVideoRepository();
  when(() => mockVideoRepository.getVideos(pageToken: any(named: 'pageToken')))
      .thenAnswer(
    (_) async => const Right(PaginatedVideosResponse(
      videos: [],
      nextPageToken: null,
      totalResults: 0,
    )),
  );

  // Register mocked dependencies
  getIt.registerLazySingleton<DioClient>(() => MockDioClient());
  getIt.registerLazySingleton<YouTubeService>(() => MockYouTubeService());
  getIt.registerLazySingleton<VideoRepository>(() => mockVideoRepository);
  getIt.registerLazySingleton<GetVideosUseCase>(
      () => GetVideosUseCase(getIt<VideoRepository>()));
  getIt.registerFactory<VideoCubit>(
      () => VideoCubit(getIt<GetVideosUseCase>()));

  getIt.registerLazySingleton<GoogleSignIn>(() => mockGoogleSignIn);
  getIt.registerLazySingleton<AuthRepository>(
      () => GoogleAuthRepositoryImpl(getIt<GoogleSignIn>()));
  getIt.registerLazySingleton<OAuthUseCase>(
      () => OAuthUseCase(getIt<AuthRepository>()));

  // Mock SecureStorageService
  final mockSecureStorageService = MockSecureStorageService();
  when(() => mockSecureStorageService.saveAccessToken(any()))
      .thenAnswer((_) async {});
  when(() => mockSecureStorageService.getAccessToken())
      .thenAnswer((_) async => null);
  when(() => mockSecureStorageService.hasAccessToken())
      .thenAnswer((_) async => false);
  when(() => mockSecureStorageService.clearAll()).thenAnswer((_) async {});

  getIt.registerLazySingleton<SecureStorageService>(
      () => mockSecureStorageService);
  getIt.registerFactory<AuthCubit>(() => AuthCubit(
        oAuthUseCase: getIt<OAuthUseCase>(),
        secureStorageService: getIt<SecureStorageService>(),
      ));

  // Mock CheckAuthUseCase and SplashCubit
  final mockCheckAuthUseCase = MockCheckAuthUseCase();
  when(() => mockCheckAuthUseCase.call(param: any(named: 'param')))
      .thenAnswer((_) async => const Left(AuthenticationFailure()));

  getIt.registerLazySingleton<CheckAuthUseCase>(() => mockCheckAuthUseCase);
  getIt.registerFactory<SplashCubit>(
      () => SplashCubit(getIt<CheckAuthUseCase>()));
}

/// Cleans up service locator after tests
Future<void> cleanupServiceLocator() async {
  await GetIt.instance.reset();
}

void main() {
  group('SplashView', () {
    setUp(() async {
      await setupMockedServiceLocator();
    });

    tearDown(() async {
      await cleanupServiceLocator();
    });

    testWidgets('should display app name', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashView(),
        ),
      );

      // Wait for animation to start
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text(AppStrings.appName), findsOneWidget);

      // Pump remaining time to complete navigation and avoid pending timers
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    });

    testWidgets('should display splash subtitle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashView(),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text(AppStrings.splashSubtitle), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    });

    testWidgets('should display loading indicator', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashView(),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    });

    testWidgets('should display app icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashView(),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byIcon(Icons.play_circle_filled), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    });

    testWidgets('should navigate to AuthView after delay', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashView(),
        ),
      );

      // Initial state - SplashView visible
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(SplashView), findsOneWidget);

      // Wait for navigation delay (3 seconds)
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // After delay - AuthView should be visible
      expect(find.byType(AuthView), findsOneWidget);
    });

    testWidgets('should have gradient background', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashView(),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));

      // Find the Container with BoxDecoration
      final containerFinder = find.byType(Container).first;
      expect(containerFinder, findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    });

    testWidgets('should use SafeArea', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashView(),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(SafeArea), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    });

    testWidgets('should have proper widget hierarchy', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashView(),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));

      // Check main structure
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    });
  });
}
