import 'package:eng_alaa_hammed/features/favorites/presentation/logic/favorites_state.dart';
import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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

  group('FavoritesState', () {
    test('should have correct initial values', () {
      const state = FavoritesState();

      expect(state.status, FavoritesStatus.initial);
      expect(state.favorites, isEmpty);
      expect(state.errorMessage, isEmpty);
      expect(state.favoriteIds, isEmpty);
    });

    test('isFavorite should return true for favorited video', () {
      final state = FavoritesState(
        favorites: [testVideo1],
        favoriteIds: {testVideo1.id},
      );

      expect(state.isFavorite(testVideo1.id), isTrue);
      expect(state.isFavorite(testVideo2.id), isFalse);
    });

    test('isFavorite should return false for non-favorited video', () {
      const state = FavoritesState();

      expect(state.isFavorite('nonexistent'), isFalse);
    });

    test('copyWith should update status correctly', () {
      const state = FavoritesState();
      final newState = state.copyWith(status: FavoritesStatus.loading);

      expect(newState.status, FavoritesStatus.loading);
      expect(newState.favorites, isEmpty);
    });

    test('copyWith should update favorites correctly', () {
      const state = FavoritesState();
      final newState = state.copyWith(
        favorites: [testVideo1, testVideo2],
        favoriteIds: {testVideo1.id, testVideo2.id},
      );

      expect(newState.favorites.length, 2);
      expect(newState.favoriteIds.length, 2);
      expect(newState.isFavorite(testVideo1.id), isTrue);
      expect(newState.isFavorite(testVideo2.id), isTrue);
    });

    test('copyWith should update errorMessage correctly', () {
      const state = FavoritesState();
      final newState = state.copyWith(errorMessage: 'Test error');

      expect(newState.errorMessage, 'Test error');
    });

    test('copyWith should preserve existing values when not provided', () {
      final state = FavoritesState(
        status: FavoritesStatus.loaded,
        favorites: [testVideo1],
        favoriteIds: {testVideo1.id},
        errorMessage: 'Some error',
      );

      final newState = state.copyWith(status: FavoritesStatus.failure);

      expect(newState.status, FavoritesStatus.failure);
      expect(newState.favorites, [testVideo1]);
      expect(newState.favoriteIds, {testVideo1.id});
      expect(newState.errorMessage, 'Some error');
    });
  });

  group('FavoritesStatus', () {
    test('should have all expected values', () {
      expect(FavoritesStatus.values, contains(FavoritesStatus.initial));
      expect(FavoritesStatus.values, contains(FavoritesStatus.loading));
      expect(FavoritesStatus.values, contains(FavoritesStatus.loaded));
      expect(FavoritesStatus.values, contains(FavoritesStatus.failure));
    });
  });
}
