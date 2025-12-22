# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flutter application for "Eng Alaa Hammed" - a YouTube channel viewer app with Google OAuth authentication. The app fetches and displays videos from a specific YouTube channel.

## Common Commands

```bash
# Run the app
flutter run

# Build APK
flutter build apk

# Run tests
flutter test

# Run a single test file
flutter test test/features/videos/data/models/video_model_test.dart

# Analyze code
flutter analyze

# Get dependencies
flutter pub get

# Clean and rebuild
flutter clean && flutter pub get
```

## Architecture

The project follows **Clean Architecture** with a feature-based structure:

```
lib/
├── core/                    # Shared utilities and configurations
│   ├── config/              # App configuration (locale, RTL support)
│   ├── constants/           # API keys, colors, strings, styles
│   ├── dependency_injection/ # GetIt service locator setup
│   ├── error/               # Failure classes for error handling
│   ├── helpers/             # Logger, exception handlers
│   ├── network/             # Dio HTTP client setup
│   ├── theme/               # Light/dark theme definitions
│   └── usecase/             # Base UseCase abstract class
├── features/
│   ├── auth/                # Google OAuth authentication
│   │   ├── data/repository/ # GoogleAuthRepositoryImpl
│   │   ├── domain/          # AuthRepository interface, OAuthUseCase
│   │   └── presentation/    # AuthCubit, AuthState, AuthView
│   ├── videos/              # YouTube video listing and playback
│   │   ├── data/            # YouTubeService, VideoModel, VideoRepositoryImpl
│   │   ├── domain/          # Video entity, VideoRepository, GetVideosUseCase
│   │   └── presentation/    # VideoCubit, AllVideosState, pages
│   └── splash/              # Splash screen
└── app.dart                 # MaterialApp configuration
```

## Key Patterns

### State Management
- Uses **flutter_bloc** (Cubit pattern)
- States follow pattern: `initial` → `loading` → `loaded/failure`
- State classes use `copyWith` for immutable updates

### Dependency Injection
- **GetIt** service locator configured in `lib/core/dependency_injection/service_locator.dart`
- Register dependencies in `setupServiceLocator()` before app runs
- Access via `getIt<Type>()`

### Error Handling
- Uses **dartz** `Either<Failure, Success>` pattern for use cases
- Custom `Failure` classes in `lib/core/error/failures.dart`

### Network Layer
- **Dio** for HTTP requests via `DioClient`
- YouTube Data API v3 integration
- API constants in `lib/core/constants/api_constants.dart`

## Localization

- Supports Arabic (default) and English
- RTL/LTR handled automatically in `lib/core/config/config.dart`
- Cairo font family for Arabic text support

## Testing

```bash
# Run all tests
flutter test

# Run with verbose output
flutter test --reporter expanded

# Run specific test file
flutter test test/features/videos/data/models/video_model_test.dart

# Run integration tests
flutter test integration_test/app_test.dart
flutter test integration_test/app_test.dart -d <device_id>
```

Test structure mirrors lib folder:
```
test/
├── core/
│   ├── constants/strings_test.dart
│   ├── error/failures_test.dart
│   ├── helpers/
│   │   ├── logger_helper_test.dart
│   │   └── retry_helper_test.dart
│   ├── network/dio_client_test.dart
│   └── usecase/usecase_test.dart
├── features/
│   ├── auth/
│   │   ├── data/repository/google_auth_repository_impl_test.dart
│   │   ├── domain/usecases/oauth_use_case_test.dart
│   │   └── presentation/views/auth_view_test.dart
│   ├── splash/
│   │   └── views/splash_view_test.dart
│   └── videos/
│       ├── data/models/video_model_test.dart
│       ├── data/repository/video_repository_impl_test.dart
│       ├── domain/entities/video_test.dart
│       ├── domain/usecases/get_videos_use_case_test.dart
│       └── presentation/views/
│           ├── all_videos_page_test.dart
│           └── video_player_page_test.dart
└── widget_test.dart

integration_test/
├── app_test.dart              # Full app flow tests
├── auth_flow_test.dart        # Authentication flow tests
├── video_flow_test.dart       # Video listing tests
├── video_player_navigation_test.dart
└── test_helpers.dart          # Shared test utilities
```

Testing uses `mocktail` for mocking and `bloc_test` for Cubit testing.

## Feature Implementation Flow

1. Create entity in `domain/entities/`
2. Define repository interface in `domain/repository/`
3. Create use case in `domain/usecases/`
4. Implement repository in `data/repository/`
5. Add data source/service in `data/data_sources/`
6. Create Cubit + State in `presentation/logic/`
7. Build UI in `presentation/views/`
8. Register all dependencies in `service_locator.dart`
9. Write unit tests for each layer

## Environment Setup

The app uses `flutter_dotenv` for environment variables. Create a `.env` file in the project root:

```
YOUTUBE_API_KEY=your_api_key_here
YOUTUBE_CHANNEL_ID=your_channel_id_here
```

These are accessed via `lib/core/constants/api_constants.dart`.

## Configuration

| Configuration | Value |
|--------------|-------|
| Flutter SDK | ^3.10.3 |
| Gradle | 8.14 |
| AGP | 8.11.1 |
| Kotlin | 2.2.20 |
| Java | 17 |
| iOS Deployment | 13.0 |
| Android minSdk | flutter.minSdkVersion |
| Android targetSdk | flutter.targetSdkVersion |

## Key Files

| Purpose | Path |
|---------|------|
| App Entry Point | `lib/main.dart` |
| MaterialApp Config | `lib/app.dart` |
| Dependency Injection | `lib/core/dependency_injection/service_locator.dart` |
| API Constants | `lib/core/constants/api_constants.dart` |
| Failure Types | `lib/core/error/failures.dart` |
| HTTP Client | `lib/core/network/dio_client.dart` |
| Theme Definitions | `lib/core/theme/app_theme.dart` |
| Localized Strings | `lib/core/constants/strings.dart` |
