import 'package:eng_alaa_hammed/core/error/failures.dart';
import 'package:eng_alaa_hammed/features/videos/data/data_sources/youtube_service.dart';
import 'package:eng_alaa_hammed/features/videos/data/repository/video_repository_impl.dart';
import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockYouTubeService extends Mock implements YouTubeService {}

void main() {
  late VideoRepositoryImpl repository;
  late MockYouTubeService mockYouTubeService;

  setUp(() {
    mockYouTubeService = MockYouTubeService();
    repository = VideoRepositoryImpl(youTubeService: mockYouTubeService);
  });

  group('VideoRepositoryImpl', () {
    final testVideoJson = [
      {
        'id': {'videoId': 'video1'},
        'snippet': {
          'title': 'Test Video 1',
          'description': 'Description 1',
          'thumbnails': {
            'high': {'url': 'https://example.com/thumb1.jpg'}
          },
          'publishedAt': '2024-01-15T10:00:00Z',
        },
      },
      {
        'id': {'videoId': 'video2'},
        'snippet': {
          'title': 'Test Video 2',
          'description': 'Description 2',
          'thumbnails': {
            'high': {'url': 'https://example.com/thumb2.jpg'}
          },
          'publishedAt': '2024-01-16T10:00:00Z',
        },
      },
    ];

    group('getVideos', () {
      test('should return list of videos when service call succeeds', () async {
        // Arrange
        when(() => mockYouTubeService.fetchVideos())
            .thenAnswer((_) async => testVideoJson);

        // Act
        final result = await repository.getVideos();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (videos) {
            expect(videos.length, 2);
            expect(videos[0].id, 'video1');
            expect(videos[0].title, 'Test Video 1');
            expect(videos[0].videoUrl, 'https://www.youtube.com/watch?v=video1');
            expect(videos[1].id, 'video2');
            expect(videos[1].title, 'Test Video 2');
          },
        );
        verify(() => mockYouTubeService.fetchVideos()).called(1);
      });

      test('should return empty list when service returns empty', () async {
        // Arrange
        when(() => mockYouTubeService.fetchVideos())
            .thenAnswer((_) async => []);

        // Act
        final result = await repository.getVideos();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (videos) => expect(videos, isEmpty),
        );
      });

      test('should return ServerFailure when service throws ServerFailure', () async {
        // Arrange
        const failure = ServerFailure('Server error');
        when(() => mockYouTubeService.fetchVideos()).thenThrow(failure);

        // Act
        final result = await repository.getVideos();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (f) => expect(f, failure),
          (videos) => fail('Should not return videos'),
        );
      });

      test('should return NetworkFailure when service throws NetworkFailure', () async {
        // Arrange
        const failure = NetworkFailure('No internet connection');
        when(() => mockYouTubeService.fetchVideos()).thenThrow(failure);

        // Act
        final result = await repository.getVideos();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (f) => expect(f, failure),
          (videos) => fail('Should not return videos'),
        );
      });

      test('should return AuthenticationFailure when service throws AuthenticationFailure', () async {
        // Arrange
        const failure = AuthenticationFailure('Unauthorized');
        when(() => mockYouTubeService.fetchVideos()).thenThrow(failure);

        // Act
        final result = await repository.getVideos();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (f) => expect(f, failure),
          (videos) => fail('Should not return videos'),
        );
      });

      test('should return UnexpectedFailure when service throws unexpected error', () async {
        // Arrange
        when(() => mockYouTubeService.fetchVideos())
            .thenThrow(Exception('Unexpected error'));

        // Act
        final result = await repository.getVideos();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (f) {
            expect(f, isA<UnexpectedFailure>());
            expect(f.message, 'Failed to load videos');
          },
          (videos) => fail('Should not return videos'),
        );
      });

      test('should correctly parse video data from JSON', () async {
        // Arrange
        when(() => mockYouTubeService.fetchVideos())
            .thenAnswer((_) async => testVideoJson);

        // Act
        final result = await repository.getVideos();

        // Assert
        result.fold(
          (failure) => fail('Should not return failure'),
          (videos) {
            final video = videos[0];
            expect(video, isA<Video>());
            expect(video.id, 'video1');
            expect(video.title, 'Test Video 1');
            expect(video.description, 'Description 1');
            expect(video.thumbnailUrl, 'https://example.com/thumb1.jpg');
            expect(video.publishedAt, '2024-01-15T10:00:00Z');
            expect(video.videoUrl, 'https://www.youtube.com/watch?v=video1');
          },
        );
      });
    });
  });
}
