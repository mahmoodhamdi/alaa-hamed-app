import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Video Entity', () {
    const testVideo = Video(
      id: 'video123',
      title: 'Test Video Title',
      thumbnailUrl: 'https://example.com/thumbnail.jpg',
      publishedAt: '2024-01-15T10:00:00Z',
      description: 'This is a test description',
      videoUrl: 'https://www.youtube.com/watch?v=video123',
    );

    test('should create Video with all required fields', () {
      expect(testVideo.id, 'video123');
      expect(testVideo.title, 'Test Video Title');
      expect(testVideo.thumbnailUrl, 'https://example.com/thumbnail.jpg');
      expect(testVideo.publishedAt, '2024-01-15T10:00:00Z');
      expect(testVideo.description, 'This is a test description');
      expect(testVideo.videoUrl, 'https://www.youtube.com/watch?v=video123');
    });

    test('props should contain all fields', () {
      expect(testVideo.props, [
        'video123',
        'Test Video Title',
        'https://example.com/thumbnail.jpg',
        '2024-01-15T10:00:00Z',
        'This is a test description',
        'https://www.youtube.com/watch?v=video123',
      ]);
    });

    test('two Videos with same props should be equal', () {
      const video1 = Video(
        id: 'same_id',
        title: 'Same Title',
        thumbnailUrl: 'https://same.url',
        publishedAt: '2024-01-01',
        description: 'Same description',
        videoUrl: 'https://youtube.com/same',
      );

      const video2 = Video(
        id: 'same_id',
        title: 'Same Title',
        thumbnailUrl: 'https://same.url',
        publishedAt: '2024-01-01',
        description: 'Same description',
        videoUrl: 'https://youtube.com/same',
      );

      expect(video1, video2);
      expect(video1.hashCode, video2.hashCode);
    });

    test('two Videos with different props should not be equal', () {
      const video1 = Video(
        id: 'id1',
        title: 'Title 1',
        thumbnailUrl: 'https://url1',
        publishedAt: '2024-01-01',
        description: 'Description 1',
        videoUrl: 'https://youtube.com/1',
      );

      const video2 = Video(
        id: 'id2',
        title: 'Title 2',
        thumbnailUrl: 'https://url2',
        publishedAt: '2024-02-02',
        description: 'Description 2',
        videoUrl: 'https://youtube.com/2',
      );

      expect(video1, isNot(video2));
    });
  });
}
