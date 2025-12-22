import 'package:eng_alaa_hammed/features/watch_history/domain/entities/watch_history_entry.dart';
import 'package:eng_alaa_hammed/features/watch_history/presentation/logic/watch_history_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WatchHistoryState', () {
    late WatchHistoryEntry testEntry;
    late WatchHistoryEntry anotherEntry;

    setUp(() {
      testEntry = WatchHistoryEntry(
        videoId: 'video123',
        title: 'Test Video',
        thumbnailUrl: 'https://example.com/thumb.jpg',
        publishedAt: '2024-01-15T10:00:00Z',
        watchedAt: DateTime(2024, 1, 20, 15, 30),
        lastPositionSeconds: 120,
        durationSeconds: 600,
        isCompleted: false,
      );

      anotherEntry = WatchHistoryEntry(
        videoId: 'video456',
        title: 'Another Video',
        thumbnailUrl: 'https://example.com/thumb2.jpg',
        publishedAt: '2024-02-10T12:00:00Z',
        watchedAt: DateTime(2024, 2, 15, 10, 00),
        lastPositionSeconds: 0,
        durationSeconds: 300,
        isCompleted: true,
      );
    });

    group('constructor', () {
      test('should create state with default values', () {
        const state = WatchHistoryState();

        expect(state.status, WatchHistoryStatus.initial);
        expect(state.history, isEmpty);
        expect(state.inProgress, isEmpty);
        expect(state.errorMessage, isEmpty);
      });

      test('should create state with custom values', () {
        final state = WatchHistoryState(
          status: WatchHistoryStatus.loaded,
          history: [testEntry],
          inProgress: [testEntry],
          errorMessage: 'Test error',
        );

        expect(state.status, WatchHistoryStatus.loaded);
        expect(state.history, [testEntry]);
        expect(state.inProgress, [testEntry]);
        expect(state.errorMessage, 'Test error');
      });
    });

    group('isInHistory', () {
      test('should return true when video is in history', () {
        final state = WatchHistoryState(
          history: [testEntry, anotherEntry],
        );

        expect(state.isInHistory('video123'), true);
        expect(state.isInHistory('video456'), true);
      });

      test('should return false when video is not in history', () {
        final state = WatchHistoryState(
          history: [testEntry],
        );

        expect(state.isInHistory('nonexistent'), false);
      });

      test('should return false when history is empty', () {
        const state = WatchHistoryState();

        expect(state.isInHistory('video123'), false);
      });
    });

    group('getEntry', () {
      test('should return entry when video is in history', () {
        final state = WatchHistoryState(
          history: [testEntry, anotherEntry],
        );

        final result = state.getEntry('video123');

        expect(result, isNotNull);
        expect(result?.videoId, 'video123');
        expect(result?.title, 'Test Video');
      });

      test('should return null when video is not in history', () {
        final state = WatchHistoryState(
          history: [testEntry],
        );

        final result = state.getEntry('nonexistent');

        expect(result, isNull);
      });

      test('should return null when history is empty', () {
        const state = WatchHistoryState();

        final result = state.getEntry('video123');

        expect(result, isNull);
      });
    });

    group('getLastPosition', () {
      test('should return last position when video is in history', () {
        final state = WatchHistoryState(
          history: [testEntry],
        );

        final result = state.getLastPosition('video123');

        expect(result, 120);
      });

      test('should return null when video is not in history', () {
        final state = WatchHistoryState(
          history: [testEntry],
        );

        final result = state.getLastPosition('nonexistent');

        expect(result, isNull);
      });

      test('should return 0 when video has not started', () {
        final state = WatchHistoryState(
          history: [anotherEntry],
        );

        final result = state.getLastPosition('video456');

        expect(result, 0);
      });
    });

    group('copyWith', () {
      test('should create copy with no changes', () {
        final state = WatchHistoryState(
          status: WatchHistoryStatus.loaded,
          history: [testEntry],
          inProgress: [testEntry],
          errorMessage: 'error',
        );

        final copy = state.copyWith();

        expect(copy.status, state.status);
        expect(copy.history, state.history);
        expect(copy.inProgress, state.inProgress);
        expect(copy.errorMessage, state.errorMessage);
      });

      test('should create copy with updated status', () {
        const state = WatchHistoryState();

        final copy = state.copyWith(status: WatchHistoryStatus.loading);

        expect(copy.status, WatchHistoryStatus.loading);
        expect(copy.history, state.history);
      });

      test('should create copy with updated history', () {
        const state = WatchHistoryState();

        final copy = state.copyWith(history: [testEntry]);

        expect(copy.history, [testEntry]);
        expect(copy.status, state.status);
      });

      test('should create copy with updated inProgress', () {
        const state = WatchHistoryState();

        final copy = state.copyWith(inProgress: [testEntry]);

        expect(copy.inProgress, [testEntry]);
      });

      test('should create copy with updated errorMessage', () {
        const state = WatchHistoryState();

        final copy = state.copyWith(errorMessage: 'New error');

        expect(copy.errorMessage, 'New error');
      });

      test('should create copy with multiple updates', () {
        const state = WatchHistoryState();

        final copy = state.copyWith(
          status: WatchHistoryStatus.failure,
          history: [testEntry],
          errorMessage: 'Failed',
        );

        expect(copy.status, WatchHistoryStatus.failure);
        expect(copy.history, [testEntry]);
        expect(copy.errorMessage, 'Failed');
        expect(copy.inProgress, state.inProgress);
      });
    });

    group('Equatable', () {
      test('should be equal when all properties are the same', () {
        final state1 = WatchHistoryState(
          status: WatchHistoryStatus.loaded,
          history: [testEntry],
          inProgress: [testEntry],
          errorMessage: 'error',
        );

        final state2 = WatchHistoryState(
          status: WatchHistoryStatus.loaded,
          history: [testEntry],
          inProgress: [testEntry],
          errorMessage: 'error',
        );

        expect(state1, equals(state2));
      });

      test('should not be equal when status differs', () {
        const state1 = WatchHistoryState(
          status: WatchHistoryStatus.loading,
        );

        const state2 = WatchHistoryState(
          status: WatchHistoryStatus.loaded,
        );

        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when history differs', () {
        final state1 = WatchHistoryState(
          history: [testEntry],
        );

        final state2 = WatchHistoryState(
          history: [anotherEntry],
        );

        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when errorMessage differs', () {
        const state1 = WatchHistoryState(
          errorMessage: 'error1',
        );

        const state2 = WatchHistoryState(
          errorMessage: 'error2',
        );

        expect(state1, isNot(equals(state2)));
      });
    });

    group('WatchHistoryStatus', () {
      test('should have all expected values', () {
        expect(WatchHistoryStatus.values, [
          WatchHistoryStatus.initial,
          WatchHistoryStatus.loading,
          WatchHistoryStatus.loaded,
          WatchHistoryStatus.failure,
        ]);
      });
    });
  });
}
