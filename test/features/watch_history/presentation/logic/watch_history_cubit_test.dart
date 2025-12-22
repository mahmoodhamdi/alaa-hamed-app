import 'package:eng_alaa_hammed/core/services/watch_history_service.dart';
import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';
import 'package:eng_alaa_hammed/features/watch_history/domain/entities/watch_history_entry.dart';
import 'package:eng_alaa_hammed/features/watch_history/presentation/logic/watch_history_cubit.dart';
import 'package:eng_alaa_hammed/features/watch_history/presentation/logic/watch_history_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWatchHistoryService extends Mock implements WatchHistoryService {}

class FakeVideo extends Fake implements Video {}

void main() {
  late MockWatchHistoryService mockService;
  late WatchHistoryCubit cubit;
  late Video testVideo;
  late WatchHistoryEntry testEntry;

  setUpAll(() {
    registerFallbackValue(FakeVideo());
  });

  setUp(() {
    mockService = MockWatchHistoryService();
    cubit = WatchHistoryCubit(mockService);

    testVideo = const Video(
      id: 'video123',
      title: 'Test Video',
      thumbnailUrl: 'https://example.com/thumb.jpg',
      publishedAt: '2024-01-15T10:00:00Z',
      description: 'Test description',
      videoUrl: 'https://youtube.com/watch?v=video123',
    );

    testEntry = WatchHistoryEntry(
      videoId: 'video123',
      title: 'Test Video',
      thumbnailUrl: 'https://example.com/thumb.jpg',
      publishedAt: '2024-01-15T10:00:00Z',
      description: 'Test description',
      videoUrl: 'https://youtube.com/watch?v=video123',
      watchedAt: DateTime(2024, 1, 20, 15, 30),
      lastPositionSeconds: 120,
      durationSeconds: 600,
      isCompleted: false,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('WatchHistoryCubit', () {
    group('initial state', () {
      test('should have initial status', () {
        expect(cubit.state.status, WatchHistoryStatus.initial);
        expect(cubit.state.history, isEmpty);
        expect(cubit.state.inProgress, isEmpty);
        expect(cubit.state.errorMessage, isEmpty);
      });
    });

    group('loadHistory', () {
      test('should emit loading then loaded state on success', () async {
        final entries = [testEntry];
        final inProgress = <WatchHistoryEntry>[];

        when(() => mockService.getHistory()).thenAnswer((_) async => entries);
        when(() => mockService.getInProgress())
            .thenAnswer((_) async => inProgress);

        final states = <WatchHistoryState>[];
        final subscription = cubit.stream.listen(states.add);

        await cubit.loadHistory();

        await Future.delayed(const Duration(milliseconds: 100));
        await subscription.cancel();

        expect(states.length, 2);
        expect(states[0].status, WatchHistoryStatus.loading);
        expect(states[1].status, WatchHistoryStatus.loaded);
        expect(states[1].history, entries);
        expect(states[1].inProgress, inProgress);
      });

      test('should emit loading then failure state on error', () async {
        when(() => mockService.getHistory()).thenThrow(Exception('Test error'));

        final states = <WatchHistoryState>[];
        final subscription = cubit.stream.listen(states.add);

        await cubit.loadHistory();

        await Future.delayed(const Duration(milliseconds: 100));
        await subscription.cancel();

        expect(states.length, 2);
        expect(states[0].status, WatchHistoryStatus.loading);
        expect(states[1].status, WatchHistoryStatus.failure);
        expect(states[1].errorMessage, contains('Test error'));
      });
    });

    group('addToHistory', () {
      test('should add video to history and reload', () async {
        when(() => mockService.addToHistory(
              any(),
              lastPositionSeconds: any(named: 'lastPositionSeconds'),
              durationSeconds: any(named: 'durationSeconds'),
              isCompleted: any(named: 'isCompleted'),
            )).thenAnswer((_) async {});
        when(() => mockService.getHistory())
            .thenAnswer((_) async => [testEntry]);
        when(() => mockService.getInProgress())
            .thenAnswer((_) async => [testEntry]);

        await cubit.addToHistory(
          testVideo,
          lastPositionSeconds: 120,
          durationSeconds: 600,
        );

        verify(() => mockService.addToHistory(
              testVideo,
              lastPositionSeconds: 120,
              durationSeconds: 600,
              isCompleted: false,
            )).called(1);
        verify(() => mockService.getHistory()).called(1);
      });

      test('should handle error gracefully', () async {
        when(() => mockService.addToHistory(
              any(),
              lastPositionSeconds: any(named: 'lastPositionSeconds'),
              durationSeconds: any(named: 'durationSeconds'),
              isCompleted: any(named: 'isCompleted'),
            )).thenThrow(Exception('Add failed'));

        // Should not throw
        await cubit.addToHistory(testVideo);
      });
    });

    group('updateProgress', () {
      test('should update progress in state without full reload', () async {
        // Set initial state with history
        when(() => mockService.getHistory())
            .thenAnswer((_) async => [testEntry]);
        when(() => mockService.getInProgress())
            .thenAnswer((_) async => [testEntry]);
        await cubit.loadHistory();

        when(() => mockService.updateProgress(
              any(),
              lastPositionSeconds: any(named: 'lastPositionSeconds'),
              durationSeconds: any(named: 'durationSeconds'),
              isCompleted: any(named: 'isCompleted'),
            )).thenAnswer((_) async {});

        await cubit.updateProgress(
          'video123',
          lastPositionSeconds: 300,
          durationSeconds: 600,
        );

        verify(() => mockService.updateProgress(
              'video123',
              lastPositionSeconds: 300,
              durationSeconds: 600,
              isCompleted: null,
            )).called(1);

        expect(cubit.state.history.first.lastPositionSeconds, 300);
      });

      test('should handle error gracefully', () async {
        when(() => mockService.updateProgress(
              any(),
              lastPositionSeconds: any(named: 'lastPositionSeconds'),
              durationSeconds: any(named: 'durationSeconds'),
              isCompleted: any(named: 'isCompleted'),
            )).thenThrow(Exception('Update failed'));

        // Should not throw
        await cubit.updateProgress(
          'video123',
          lastPositionSeconds: 300,
          durationSeconds: 600,
        );
      });
    });

    group('removeFromHistory', () {
      test('should remove video and update state', () async {
        // Set initial state with history
        when(() => mockService.getHistory())
            .thenAnswer((_) async => [testEntry]);
        when(() => mockService.getInProgress())
            .thenAnswer((_) async => [testEntry]);
        await cubit.loadHistory();

        when(() => mockService.removeFromHistory(any()))
            .thenAnswer((_) async {});

        await cubit.removeFromHistory('video123');

        verify(() => mockService.removeFromHistory('video123')).called(1);
        expect(cubit.state.history, isEmpty);
      });

      test('should handle error gracefully', () async {
        when(() => mockService.removeFromHistory(any()))
            .thenThrow(Exception('Remove failed'));

        // Should not throw
        await cubit.removeFromHistory('video123');
      });
    });

    group('clearHistory', () {
      test('should clear all history', () async {
        // Set initial state with history
        when(() => mockService.getHistory())
            .thenAnswer((_) async => [testEntry]);
        when(() => mockService.getInProgress())
            .thenAnswer((_) async => [testEntry]);
        await cubit.loadHistory();

        when(() => mockService.clearHistory()).thenAnswer((_) async {});

        await cubit.clearHistory();

        verify(() => mockService.clearHistory()).called(1);
        expect(cubit.state.history, isEmpty);
        expect(cubit.state.inProgress, isEmpty);
      });

      test('should handle error gracefully', () async {
        when(() => mockService.clearHistory())
            .thenThrow(Exception('Clear failed'));

        // Should not throw
        await cubit.clearHistory();
      });
    });

    group('getLastPosition', () {
      test('should return last position from state', () async {
        // Set initial state with history
        when(() => mockService.getHistory())
            .thenAnswer((_) async => [testEntry]);
        when(() => mockService.getInProgress())
            .thenAnswer((_) async => [testEntry]);
        await cubit.loadHistory();

        final position = cubit.getLastPosition('video123');

        expect(position, 120);
      });

      test('should return null when video not in history', () {
        final position = cubit.getLastPosition('nonexistent');

        expect(position, isNull);
      });
    });

    group('isInHistory', () {
      test('should return true when video is in history', () async {
        when(() => mockService.getHistory())
            .thenAnswer((_) async => [testEntry]);
        when(() => mockService.getInProgress())
            .thenAnswer((_) async => [testEntry]);
        await cubit.loadHistory();

        final result = cubit.isInHistory('video123');

        expect(result, true);
      });

      test('should return false when video is not in history', () {
        final result = cubit.isInHistory('nonexistent');

        expect(result, false);
      });
    });

    group('getEntry', () {
      test('should return entry when video is in history', () async {
        when(() => mockService.getHistory())
            .thenAnswer((_) async => [testEntry]);
        when(() => mockService.getInProgress())
            .thenAnswer((_) async => [testEntry]);
        await cubit.loadHistory();

        final result = cubit.getEntry('video123');

        expect(result, isNotNull);
        expect(result?.videoId, 'video123');
      });

      test('should return null when video is not in history', () {
        final result = cubit.getEntry('nonexistent');

        expect(result, isNull);
      });
    });
  });
}
