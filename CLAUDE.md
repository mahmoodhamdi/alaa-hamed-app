# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flutter application for "Eng Alaa Hammed" - a YouTube channel viewer app with Google OAuth authentication. The app fetches and displays videos from a specific YouTube channel, with playlists, favorites, and watch history features.

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

# Run integration tests
flutter test integration_test/app_test.dart -d <device_id>
```

## Architecture

The project follows **Clean Architecture** with a feature-based structure:

```
lib/
├── core/
│   ├── config/              # App configuration (locale, RTL support)
│   ├── constants/           # API keys, colors, strings, styles, dimensions
│   ├── dependency_injection/ # GetIt service locator setup
│   ├── error/               # Failure classes for error handling
│   ├── helpers/             # Logger, exception handlers, retry helper
│   ├── network/             # Dio HTTP client setup with interceptors
│   ├── services/            # App-wide services (see Core Services below)
│   ├── theme/               # Light/dark theme definitions
│   ├── usecase/             # Base UseCase abstract class
│   └── widgets/             # Shared widgets (EnhancedVideoCard, EmptyState, ErrorState)
├── features/
│   ├── auth/                # Google OAuth authentication
│   ├── favorites/           # Video favorites (Hive-based local storage)
│   ├── home/                # Bottom navigation home page
│   ├── playlists/           # YouTube playlist listing and videos
│   ├── settings/            # App settings & preferences
│   ├── splash/              # Splash screen with auth check
│   ├── videos/              # YouTube video listing and playback
│   └── watch_history/       # Video watch history tracking
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

### Core Services
Located in `lib/core/services/`:
- **VideoCacheService**: Hive-based video caching for offline access
- **FavoritesService**: Hive-based favorites storage
- **WatchHistoryService**: Hive-based watch history tracking
- **SecureStorageService**: flutter_secure_storage wrapper for sensitive data
- **ConnectivityService**: Network connectivity monitoring via connectivity_plus

### Local Storage
- **Hive** for local data (favorites, watch history, video cache)
- **SharedPreferences** for settings
- **flutter_secure_storage** for tokens and sensitive data

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
flutter test integration_test/app_test.dart -d <device_id>
```

- Test structure mirrors `lib/` folder (e.g., `lib/features/auth/` → `test/features/auth/`)
- Integration tests in `integration_test/` with shared helpers in `test_helpers.dart`
- Uses `mocktail` for mocking and `bloc_test` for Cubit testing

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
| YouTube Data Fetching | `lib/features/videos/data/data_sources/youtube_service.dart` |
| Video Caching | `lib/core/services/video_cache_service.dart` |
