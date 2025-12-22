import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';
import 'package:eng_alaa_hammed/features/watch_history/domain/entities/watch_history_entry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WatchHistoryEntry', () {
    late WatchHistoryEntry entry;
    late Video video;

    setUp(() {
      entry = WatchHistoryEntry(
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

      video = const Video(
        id: 'video456',
        title: 'Another Video',
        thumbnailUrl: 'https://example.com/thumb2.jpg',
        publishedAt: '2024-02-10T12:00:00Z',
        description: 'Another description',
        videoUrl: 'https://youtube.com/watch?v=video456',
      );
    });

    group('constructor', () {
      test('should create entry with required parameters', () {
        final entry = WatchHistoryEntry(
          videoId: 'test',
          title: 'Test',
          thumbnailUrl: 'https://example.com/thumb.jpg',
          publishedAt: '2024-01-15T10:00:00Z',
          watchedAt: DateTime(2024, 1, 20),
        );

        expect(entry.videoId, 'test');
        expect(entry.title, 'Test');
        expect(entry.description, '');
        expect(entry.videoUrl, '');
        expect(entry.lastPositionSeconds, 0);
        expect(entry.durationSeconds, 0);
        expect(entry.isCompleted, false);
      });

      test('should create entry with all parameters', () {
        expect(entry.videoId, 'video123');
        expect(entry.title, 'Test Video');
        expect(entry.thumbnailUrl, 'https://example.com/thumb.jpg');
        expect(entry.publishedAt, '2024-01-15T10:00:00Z');
        expect(entry.description, 'Test description');
        expect(entry.videoUrl, 'https://youtube.com/watch?v=video123');
        expect(entry.lastPositionSeconds, 120);
        expect(entry.durationSeconds, 600);
        expect(entry.isCompleted, false);
      });
    });

    group('fromVideo', () {
      test('should create entry from Video with default values', () {
        final entry = WatchHistoryEntry.fromVideo(video);

        expect(entry.videoId, video.id);
        expect(entry.title, video.title);
        expect(entry.thumbnailUrl, video.thumbnailUrl);
        expect(entry.publishedAt, video.publishedAt);
        expect(entry.description, video.description);
        expect(entry.videoUrl, video.videoUrl);
        expect(entry.lastPositionSeconds, 0);
        expect(entry.durationSeconds, 0);
        expect(entry.isCompleted, false);
      });

      test('should create entry from Video with custom values', () {
        final entry = WatchHistoryEntry.fromVideo(
          video,
          lastPositionSeconds: 300,
          durationSeconds: 900,
          isCompleted: true,
        );

        expect(entry.videoId, video.id);
        expect(entry.lastPositionSeconds, 300);
        expect(entry.durationSeconds, 900);
        expect(entry.isCompleted, true);
      });
    });

    group('fromJson', () {
      test('should create entry from JSON with all fields', () {
        final json = {
          'videoId': 'json123',
          'title': 'JSON Video',
          'thumbnailUrl': 'https://example.com/json.jpg',
          'publishedAt': '2024-03-01T09:00:00Z',
          'description': 'JSON description',
          'videoUrl': 'https://youtube.com/watch?v=json123',
          'watchedAt': '2024-03-05T14:30:00.000Z',
          'lastPositionSeconds': 180,
          'durationSeconds': 720,
          'isCompleted': true,
        };

        final entry = WatchHistoryEntry.fromJson(json);

        expect(entry.videoId, 'json123');
        expect(entry.title, 'JSON Video');
        expect(entry.thumbnailUrl, 'https://example.com/json.jpg');
        expect(entry.publishedAt, '2024-03-01T09:00:00Z');
        expect(entry.description, 'JSON description');
        expect(entry.videoUrl, 'https://youtube.com/watch?v=json123');
        expect(entry.lastPositionSeconds, 180);
        expect(entry.durationSeconds, 720);
        expect(entry.isCompleted, true);
      });

      test('should create entry from JSON with missing optional fields', () {
        final json = {
          'videoId': 'json123',
          'title': 'JSON Video',
          'thumbnailUrl': 'https://example.com/json.jpg',
          'publishedAt': '2024-03-01T09:00:00Z',
          'watchedAt': '2024-03-05T14:30:00.000Z',
        };

        final entry = WatchHistoryEntry.fromJson(json);

        expect(entry.description, '');
        expect(entry.videoUrl, '');
        expect(entry.lastPositionSeconds, 0);
        expect(entry.durationSeconds, 0);
        expect(entry.isCompleted, false);
      });

      test('should handle null description and videoUrl in JSON', () {
        final json = {
          'videoId': 'json123',
          'title': 'JSON Video',
          'thumbnailUrl': 'https://example.com/json.jpg',
          'publishedAt': '2024-03-01T09:00:00Z',
          'description': null,
          'videoUrl': null,
          'watchedAt': '2024-03-05T14:30:00.000Z',
        };

        final entry = WatchHistoryEntry.fromJson(json);

        expect(entry.description, '');
        expect(entry.videoUrl, '');
      });
    });

    group('toJson', () {
      test('should convert entry to JSON', () {
        final json = entry.toJson();

        expect(json['videoId'], 'video123');
        expect(json['title'], 'Test Video');
        expect(json['thumbnailUrl'], 'https://example.com/thumb.jpg');
        expect(json['publishedAt'], '2024-01-15T10:00:00Z');
        expect(json['description'], 'Test description');
        expect(json['videoUrl'], 'https://youtube.com/watch?v=video123');
        expect(json['watchedAt'], '2024-01-20T15:30:00.000');
        expect(json['lastPositionSeconds'], 120);
        expect(json['durationSeconds'], 600);
        expect(json['isCompleted'], false);
      });

      test('should round-trip through JSON correctly', () {
        final json = entry.toJson();
        final restored = WatchHistoryEntry.fromJson(json);

        expect(restored.videoId, entry.videoId);
        expect(restored.title, entry.title);
        expect(restored.thumbnailUrl, entry.thumbnailUrl);
        expect(restored.publishedAt, entry.publishedAt);
        expect(restored.description, entry.description);
        expect(restored.videoUrl, entry.videoUrl);
        expect(restored.lastPositionSeconds, entry.lastPositionSeconds);
        expect(restored.durationSeconds, entry.durationSeconds);
        expect(restored.isCompleted, entry.isCompleted);
      });
    });

    group('toVideo', () {
      test('should convert entry to Video', () {
        final convertedVideo = entry.toVideo();

        expect(convertedVideo.id, entry.videoId);
        expect(convertedVideo.title, entry.title);
        expect(convertedVideo.thumbnailUrl, entry.thumbnailUrl);
        expect(convertedVideo.publishedAt, entry.publishedAt);
        expect(convertedVideo.description, entry.description);
        expect(convertedVideo.videoUrl, entry.videoUrl);
      });
    });

    group('watchProgress', () {
      test('should return 0.0 when durationSeconds is 0', () {
        final entry = WatchHistoryEntry(
          videoId: 'test',
          title: 'Test',
          thumbnailUrl: 'https://example.com/thumb.jpg',
          publishedAt: '2024-01-15T10:00:00Z',
          watchedAt: DateTime(2024, 1, 20),
          durationSeconds: 0,
          lastPositionSeconds: 100,
        );

        expect(entry.watchProgress, 0.0);
      });

      test('should return correct progress percentage', () {
        expect(entry.watchProgress, 0.2); // 120/600 = 0.2
      });

      test('should clamp progress to 1.0 when position exceeds duration', () {
        final entry = WatchHistoryEntry(
          videoId: 'test',
          title: 'Test',
          thumbnailUrl: 'https://example.com/thumb.jpg',
          publishedAt: '2024-01-15T10:00:00Z',
          watchedAt: DateTime(2024, 1, 20),
          durationSeconds: 100,
          lastPositionSeconds: 150,
        );

        expect(entry.watchProgress, 1.0);
      });

      test('should clamp progress to 0.0 when position is negative', () {
        final entry = WatchHistoryEntry(
          videoId: 'test',
          title: 'Test',
          thumbnailUrl: 'https://example.com/thumb.jpg',
          publishedAt: '2024-01-15T10:00:00Z',
          watchedAt: DateTime(2024, 1, 20),
          durationSeconds: 100,
          lastPositionSeconds: -10,
        );

        expect(entry.watchProgress, 0.0);
      });
    });

    group('watchProgressPercent', () {
      test('should return formatted percentage string', () {
        expect(entry.watchProgressPercent, '20%');
      });

      test('should return 0% when no progress', () {
        final entry = WatchHistoryEntry(
          videoId: 'test',
          title: 'Test',
          thumbnailUrl: 'https://example.com/thumb.jpg',
          publishedAt: '2024-01-15T10:00:00Z',
          watchedAt: DateTime(2024, 1, 20),
          durationSeconds: 600,
          lastPositionSeconds: 0,
        );

        expect(entry.watchProgressPercent, '0%');
      });

      test('should return 100% when completed', () {
        final entry = WatchHistoryEntry(
          videoId: 'test',
          title: 'Test',
          thumbnailUrl: 'https://example.com/thumb.jpg',
          publishedAt: '2024-01-15T10:00:00Z',
          watchedAt: DateTime(2024, 1, 20),
          durationSeconds: 600,
          lastPositionSeconds: 600,
        );

        expect(entry.watchProgressPercent, '100%');
      });
    });

    group('hasStarted', () {
      test('should return false when lastPositionSeconds is 0', () {
        final entry = WatchHistoryEntry(
          videoId: 'test',
          title: 'Test',
          thumbnailUrl: 'https://example.com/thumb.jpg',
          publishedAt: '2024-01-15T10:00:00Z',
          watchedAt: DateTime(2024, 1, 20),
          lastPositionSeconds: 0,
        );

        expect(entry.hasStarted, false);
      });

      test('should return true when lastPositionSeconds is greater than 0', () {
        expect(entry.hasStarted, true);
      });
    });

    group('remainingSeconds', () {
      test('should return correct remaining time', () {
        expect(entry.remainingSeconds, 480); // 600 - 120
      });

      test('should return 0 when durationSeconds is 0', () {
        final entry = WatchHistoryEntry(
          videoId: 'test',
          title: 'Test',
          thumbnailUrl: 'https://example.com/thumb.jpg',
          publishedAt: '2024-01-15T10:00:00Z',
          watchedAt: DateTime(2024, 1, 20),
          durationSeconds: 0,
        );

        expect(entry.remainingSeconds, 0);
      });

      test('should clamp to 0 when position exceeds duration', () {
        final entry = WatchHistoryEntry(
          videoId: 'test',
          title: 'Test',
          thumbnailUrl: 'https://example.com/thumb.jpg',
          publishedAt: '2024-01-15T10:00:00Z',
          watchedAt: DateTime(2024, 1, 20),
          durationSeconds: 100,
          lastPositionSeconds: 150,
        );

        expect(entry.remainingSeconds, 0);
      });
    });

    group('formatDuration', () {
      test('should format seconds correctly (mm:ss)', () {
        expect(entry.formatDuration(65), '01:05');
        expect(entry.formatDuration(0), '00:00');
        expect(entry.formatDuration(59), '00:59');
        expect(entry.formatDuration(600), '10:00');
      });

      test('should format hours correctly (hh:mm:ss)', () {
        expect(entry.formatDuration(3661), '01:01:01');
        expect(entry.formatDuration(7200), '02:00:00');
        expect(entry.formatDuration(3600), '01:00:00');
      });
    });

    group('formatted getters', () {
      test('formattedLastPosition should return correct format', () {
        expect(entry.formattedLastPosition, '02:00');
      });

      test('formattedDuration should return correct format', () {
        expect(entry.formattedDuration, '10:00');
      });

      test('formattedRemaining should return correct format', () {
        expect(entry.formattedRemaining, '08:00');
      });
    });

    group('copyWith', () {
      test('should create copy with no changes', () {
        final copy = entry.copyWith();

        expect(copy.videoId, entry.videoId);
        expect(copy.title, entry.title);
        expect(copy.thumbnailUrl, entry.thumbnailUrl);
        expect(copy.publishedAt, entry.publishedAt);
        expect(copy.description, entry.description);
        expect(copy.videoUrl, entry.videoUrl);
        expect(copy.watchedAt, entry.watchedAt);
        expect(copy.lastPositionSeconds, entry.lastPositionSeconds);
        expect(copy.durationSeconds, entry.durationSeconds);
        expect(copy.isCompleted, entry.isCompleted);
      });

      test('should create copy with updated values', () {
        final newWatchedAt = DateTime(2024, 2, 1);
        final copy = entry.copyWith(
          title: 'Updated Title',
          lastPositionSeconds: 300,
          isCompleted: true,
          watchedAt: newWatchedAt,
        );

        expect(copy.title, 'Updated Title');
        expect(copy.lastPositionSeconds, 300);
        expect(copy.isCompleted, true);
        expect(copy.watchedAt, newWatchedAt);
        // Unchanged values
        expect(copy.videoId, entry.videoId);
        expect(copy.thumbnailUrl, entry.thumbnailUrl);
      });
    });

    group('Equatable', () {
      test('should be equal when all properties are the same', () {
        final entry1 = WatchHistoryEntry(
          videoId: 'same',
          title: 'Same Title',
          thumbnailUrl: 'https://example.com/same.jpg',
          publishedAt: '2024-01-15T10:00:00Z',
          description: 'Same description',
          videoUrl: 'https://youtube.com/watch?v=same',
          watchedAt: DateTime(2024, 1, 20, 15, 30),
          lastPositionSeconds: 100,
          durationSeconds: 500,
          isCompleted: false,
        );

        final entry2 = WatchHistoryEntry(
          videoId: 'same',
          title: 'Same Title',
          thumbnailUrl: 'https://example.com/same.jpg',
          publishedAt: '2024-01-15T10:00:00Z',
          description: 'Same description',
          videoUrl: 'https://youtube.com/watch?v=same',
          watchedAt: DateTime(2024, 1, 20, 15, 30),
          lastPositionSeconds: 100,
          durationSeconds: 500,
          isCompleted: false,
        );

        expect(entry1, equals(entry2));
      });

      test('should not be equal when properties differ', () {
        final entry1 = WatchHistoryEntry(
          videoId: 'different1',
          title: 'Title',
          thumbnailUrl: 'https://example.com/thumb.jpg',
          publishedAt: '2024-01-15T10:00:00Z',
          watchedAt: DateTime(2024, 1, 20),
        );

        final entry2 = WatchHistoryEntry(
          videoId: 'different2',
          title: 'Title',
          thumbnailUrl: 'https://example.com/thumb.jpg',
          publishedAt: '2024-01-15T10:00:00Z',
          watchedAt: DateTime(2024, 1, 20),
        );

        expect(entry1, isNot(equals(entry2)));
      });
    });
  });
}
