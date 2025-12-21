import 'package:eng_alaa_hammed/features/videos/data/models/video_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VideoModel', () {
    const testVideoModel = VideoModel(
      id: 'abc123',
      title: 'Test Video',
      thumbnailUrl: 'https://example.com/thumb.jpg',
      publishedAt: '2024-01-15T10:00:00Z',
      description: 'Test description',
      videoUrl: 'https://www.youtube.com/watch?v=abc123',
    );

    final testJson = {
      'id': {'videoId': 'abc123'},
      'snippet': {
        'title': 'Test Video',
        'description': 'Test description',
        'thumbnails': {
          'high': {'url': 'https://example.com/thumb.jpg'}
        },
        'publishedAt': '2024-01-15T10:00:00Z',
      }
    };

    group('fromJson', () {
      test('should create VideoModel from valid JSON', () {
        final result = VideoModel.fromJson(testJson);

        expect(result.id, 'abc123');
        expect(result.title, 'Test Video');
        expect(result.thumbnailUrl, 'https://example.com/thumb.jpg');
        expect(result.publishedAt, '2024-01-15T10:00:00Z');
        expect(result.description, 'Test description');
        expect(result.videoUrl, 'https://www.youtube.com/watch?v=abc123');
      });

      test('should generate correct YouTube video URL from video ID', () {
        final result = VideoModel.fromJson(testJson);

        expect(result.videoUrl, contains('youtube.com/watch?v='));
        expect(result.videoUrl, contains(result.id));
      });
    });

    group('toJson', () {
      test('should convert VideoModel to JSON', () {
        final result = testVideoModel.toJson();

        expect(result['id']['videoId'], 'abc123');
        expect(result['snippet']['title'], 'Test Video');
        expect(result['snippet']['description'], 'Test description');
        expect(result['snippet']['thumbnails']['high']['url'],
            'https://example.com/thumb.jpg');
        expect(result['snippet']['publishedAt'], '2024-01-15T10:00:00Z');
        expect(result['videoUrl'], 'https://www.youtube.com/watch?v=abc123');
      });

      test('toJson should include all fields', () {
        final result = testVideoModel.toJson();

        expect(result.containsKey('id'), true);
        expect(result.containsKey('snippet'), true);
        expect(result.containsKey('videoUrl'), true);
        expect(result['snippet'].containsKey('description'), true);
      });
    });

    group('equality', () {
      test('two VideoModels with same data should be equal', () {
        const model1 = VideoModel(
          id: 'abc123',
          title: 'Test Video',
          thumbnailUrl: 'https://example.com/thumb.jpg',
          publishedAt: '2024-01-15T10:00:00Z',
          description: 'Test description',
          videoUrl: 'https://www.youtube.com/watch?v=abc123',
        );

        const model2 = VideoModel(
          id: 'abc123',
          title: 'Test Video',
          thumbnailUrl: 'https://example.com/thumb.jpg',
          publishedAt: '2024-01-15T10:00:00Z',
          description: 'Test description',
          videoUrl: 'https://www.youtube.com/watch?v=abc123',
        );

        expect(model1, model2);
      });

      test('two VideoModels with different data should not be equal', () {
        const model1 = VideoModel(
          id: 'abc123',
          title: 'Test Video',
          thumbnailUrl: 'https://example.com/thumb.jpg',
          publishedAt: '2024-01-15T10:00:00Z',
          description: 'Test description',
          videoUrl: 'https://www.youtube.com/watch?v=abc123',
        );

        const model2 = VideoModel(
          id: 'xyz789',
          title: 'Different Video',
          thumbnailUrl: 'https://example.com/thumb2.jpg',
          publishedAt: '2024-02-20T10:00:00Z',
          description: 'Different description',
          videoUrl: 'https://www.youtube.com/watch?v=xyz789',
        );

        expect(model1, isNot(model2));
      });
    });
  });
}
