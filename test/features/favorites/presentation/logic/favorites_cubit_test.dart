import 'package:bloc_test/bloc_test.dart';
import 'package:eng_alaa_hammed/core/services/favorites_service.dart';
import 'package:eng_alaa_hammed/features/favorites/presentation/logic/favorites_cubit.dart';
import 'package:eng_alaa_hammed/features/favorites/presentation/logic/favorites_state.dart';
import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFavoritesService extends Mock implements FavoritesService {}

void main() {
  late FavoritesCubit favoritesCubit;
  late MockFavoritesService mockFavoritesService;

  const testVideo1 = Video(
    id: 'video1',
    title: 'Test Video 1',
    thumbnailUrl: 'https://example.com/thumb1.jpg',
    publishedAt: '2024-01-15T10:00:00Z',
    description: 'Test description 1',
    videoUrl: 'https://youtube.com/watch?v=video1',
  );

  const testVideo2 = Video(
    id: 'video2',
    title: 'Test Video 2',
    thumbnailUrl: 'https://example.com/thumb2.jpg',
    publishedAt: '2024-01-16T10:00:00Z',
    description: 'Test description 2',
    videoUrl: 'https://youtube.com/watch?v=video2',
  );

  setUpAll(() {
    registerFallbackValue(testVideo1);
  });

  setUp(() {
    mockFavoritesService = MockFavoritesService();
    favoritesCubit = FavoritesCubit(mockFavoritesService);
  });

  tearDown(() {
    favoritesCubit.close();
  });

  group('FavoritesCubit', () {
    test('initial state should be correct', () {
      expect(favoritesCubit.state.status, FavoritesStatus.initial);
      expect(favoritesCubit.state.favorites, isEmpty);
      expect(favoritesCubit.state.favoriteIds, isEmpty);
    });

    group('loadFavorites', () {
      blocTest<FavoritesCubit, FavoritesState>(
        'emits [loading, loaded] when loadFavorites succeeds with videos',
        build: () {
          when(() => mockFavoritesService.getFavorites())
              .thenAnswer((_) async => [testVideo1, testVideo2]);
          return favoritesCubit;
        },
        act: (cubit) => cubit.loadFavorites(),
        expect: () => [
          const FavoritesState(status: FavoritesStatus.loading),
          FavoritesState(
            status: FavoritesStatus.loaded,
            favorites: [testVideo1, testVideo2],
            favoriteIds: {testVideo1.id, testVideo2.id},
          ),
        ],
      );

      blocTest<FavoritesCubit, FavoritesState>(
        'emits [loading, loaded] when loadFavorites succeeds with empty list',
        build: () {
          when(() => mockFavoritesService.getFavorites())
              .thenAnswer((_) async => []);
          return favoritesCubit;
        },
        act: (cubit) => cubit.loadFavorites(),
        expect: () => [
          const FavoritesState(status: FavoritesStatus.loading),
          const FavoritesState(
            status: FavoritesStatus.loaded,
            favorites: [],
            favoriteIds: {},
          ),
        ],
      );

      blocTest<FavoritesCubit, FavoritesState>(
        'emits [loading, failure] when loadFavorites fails',
        build: () {
          when(() => mockFavoritesService.getFavorites())
              .thenThrow(Exception('Failed to load'));
          return favoritesCubit;
        },
        act: (cubit) => cubit.loadFavorites(),
        expect: () => [
          const FavoritesState(status: FavoritesStatus.loading),
          isA<FavoritesState>()
              .having((s) => s.status, 'status', FavoritesStatus.failure)
              .having((s) => s.errorMessage, 'errorMessage', isNotEmpty),
        ],
      );
    });

    group('addFavorite', () {
      blocTest<FavoritesCubit, FavoritesState>(
        'should add video to favorites list',
        build: () {
          when(() => mockFavoritesService.addToFavorites(any()))
              .thenAnswer((_) async {});
          return favoritesCubit;
        },
        act: (cubit) => cubit.addFavorite(testVideo1),
        expect: () => [
          FavoritesState(
            favorites: [testVideo1],
            favoriteIds: {testVideo1.id},
          ),
        ],
      );

      blocTest<FavoritesCubit, FavoritesState>(
        'should add multiple videos to favorites list',
        build: () {
          when(() => mockFavoritesService.addToFavorites(any()))
              .thenAnswer((_) async {});
          return favoritesCubit;
        },
        act: (cubit) async {
          await cubit.addFavorite(testVideo1);
          await cubit.addFavorite(testVideo2);
        },
        expect: () => [
          FavoritesState(
            favorites: [testVideo1],
            favoriteIds: {testVideo1.id},
          ),
          FavoritesState(
            favorites: [testVideo1, testVideo2],
            favoriteIds: {testVideo1.id, testVideo2.id},
          ),
        ],
      );
    });

    group('removeFavorite', () {
      blocTest<FavoritesCubit, FavoritesState>(
        'should remove video from favorites list',
        build: () {
          when(() => mockFavoritesService.removeFromFavorites(any()))
              .thenAnswer((_) async {});
          return favoritesCubit;
        },
        seed: () => FavoritesState(
          favorites: [testVideo1, testVideo2],
          favoriteIds: {testVideo1.id, testVideo2.id},
        ),
        act: (cubit) => cubit.removeFavorite(testVideo1.id),
        expect: () => [
          FavoritesState(
            favorites: [testVideo2],
            favoriteIds: {testVideo2.id},
          ),
        ],
      );

      blocTest<FavoritesCubit, FavoritesState>(
        'should result in empty list when removing last video',
        build: () {
          when(() => mockFavoritesService.removeFromFavorites(any()))
              .thenAnswer((_) async {});
          return favoritesCubit;
        },
        seed: () => FavoritesState(
          favorites: [testVideo1],
          favoriteIds: {testVideo1.id},
        ),
        act: (cubit) => cubit.removeFavorite(testVideo1.id),
        expect: () => [
          const FavoritesState(
            favorites: [],
            favoriteIds: {},
          ),
        ],
      );
    });

    group('toggleFavorite', () {
      blocTest<FavoritesCubit, FavoritesState>(
        'should add video when not in favorites',
        build: () {
          when(() => mockFavoritesService.addToFavorites(any()))
              .thenAnswer((_) async {});
          return favoritesCubit;
        },
        act: (cubit) => cubit.toggleFavorite(testVideo1),
        expect: () => [
          FavoritesState(
            favorites: [testVideo1],
            favoriteIds: {testVideo1.id},
          ),
        ],
      );

      blocTest<FavoritesCubit, FavoritesState>(
        'should remove video when already in favorites',
        build: () {
          when(() => mockFavoritesService.removeFromFavorites(any()))
              .thenAnswer((_) async {});
          return favoritesCubit;
        },
        seed: () => FavoritesState(
          favorites: [testVideo1],
          favoriteIds: {testVideo1.id},
        ),
        act: (cubit) => cubit.toggleFavorite(testVideo1),
        expect: () => [
          const FavoritesState(
            favorites: [],
            favoriteIds: {},
          ),
        ],
      );
    });

    group('clearAllFavorites', () {
      blocTest<FavoritesCubit, FavoritesState>(
        'should clear all favorites',
        build: () {
          when(() => mockFavoritesService.clearFavorites())
              .thenAnswer((_) async {});
          return favoritesCubit;
        },
        seed: () => FavoritesState(
          favorites: [testVideo1, testVideo2],
          favoriteIds: {testVideo1.id, testVideo2.id},
        ),
        act: (cubit) => cubit.clearAllFavorites(),
        expect: () => [
          const FavoritesState(
            favorites: [],
            favoriteIds: {},
          ),
        ],
      );
    });
  });
}
