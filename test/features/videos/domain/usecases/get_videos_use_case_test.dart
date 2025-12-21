import 'package:dartz/dartz.dart';
import 'package:eng_alaa_hammed/core/error/failures.dart';
import 'package:eng_alaa_hammed/core/usecase/usecase.dart';
import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';
import 'package:eng_alaa_hammed/features/videos/domain/repository/video_repository.dart';
import 'package:eng_alaa_hammed/features/videos/domain/usecases/get_videos_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

class MockVideoRepository implements VideoRepository {
  Either<Failure, List<Video>>? mockResult;

  @override
  Future<Either<Failure, List<Video>>> getVideos() async {
    return mockResult ?? const Right([]);
  }
}

void main() {
  late GetVideosUseCase useCase;
  late MockVideoRepository mockRepository;

  setUp(() {
    mockRepository = MockVideoRepository();
    useCase = GetVideosUseCase(mockRepository);
  });

  const testVideos = [
    Video(
      id: 'video1',
      title: 'Test Video 1',
      thumbnailUrl: 'https://example.com/thumb1.jpg',
      publishedAt: '2024-01-01',
      description: 'Description 1',
      videoUrl: 'https://youtube.com/watch?v=video1',
    ),
    Video(
      id: 'video2',
      title: 'Test Video 2',
      thumbnailUrl: 'https://example.com/thumb2.jpg',
      publishedAt: '2024-01-02',
      description: 'Description 2',
      videoUrl: 'https://youtube.com/watch?v=video2',
    ),
  ];

  group('GetVideosUseCase', () {
    test('should implement UseCase interface', () {
      expect(useCase, isA<UseCase<Either<Failure, List<Video>>, NoParams>>());
    });

    test('should return list of videos on success', () async {
      mockRepository.mockResult = const Right(testVideos);

      final result = await useCase(param: const NoParams());

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (videos) {
          expect(videos.length, 2);
          expect(videos[0].id, 'video1');
          expect(videos[1].id, 'video2');
        },
      );
    });

    test('should return failure when repository fails', () async {
      mockRepository.mockResult = const Left(ServerFailure('API error'));

      final result = await useCase(param: const NoParams());

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'API error');
        },
        (videos) => fail('Should not return videos'),
      );
    });

    test('should return NetworkFailure on network error', () async {
      mockRepository.mockResult = const Left(NetworkFailure('No internet'));

      final result = await useCase(param: const NoParams());

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<NetworkFailure>());
          expect(failure.message, 'No internet');
        },
        (videos) => fail('Should not return videos'),
      );
    });

    test('should return empty list when no videos', () async {
      mockRepository.mockResult = const Right([]);

      final result = await useCase(param: const NoParams());

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (videos) => expect(videos, isEmpty),
      );
    });

    test('call method should work without param', () async {
      mockRepository.mockResult = const Right(testVideos);

      final result = await useCase();

      expect(result.isRight(), true);
    });
  });
}
