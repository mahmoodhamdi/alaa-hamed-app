import 'package:dartz/dartz.dart';
import 'package:eng_alaa_hammed/core/error/failures.dart';
import 'package:eng_alaa_hammed/core/usecase/usecase.dart';
import 'package:eng_alaa_hammed/features/videos/data/models/paginated_videos_response.dart';
import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';
import 'package:eng_alaa_hammed/features/videos/domain/repository/video_repository.dart';
import 'package:eng_alaa_hammed/features/videos/domain/usecases/get_videos_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

class MockVideoRepository implements VideoRepository {
  Either<Failure, PaginatedVideosResponse>? mockResult;
  String? lastPageToken;

  @override
  Future<Either<Failure, PaginatedVideosResponse>> getVideos({
    String? pageToken,
  }) async {
    lastPageToken = pageToken;
    return mockResult ??
        const Right(PaginatedVideosResponse(
          videos: [],
          nextPageToken: null,
          totalResults: 0,
        ));
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
      expect(
          useCase,
          isA<
              UseCase<Either<Failure, PaginatedVideosResponse>,
                  GetVideosParams>>());
    });

    test('should return paginated videos response on success', () async {
      mockRepository.mockResult = const Right(PaginatedVideosResponse(
        videos: testVideos,
        nextPageToken: 'next_token',
        totalResults: 100,
      ));

      final result = await useCase(param: const GetVideosParams());

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (response) {
          expect(response.videos.length, 2);
          expect(response.videos[0].id, 'video1');
          expect(response.videos[1].id, 'video2');
          expect(response.nextPageToken, 'next_token');
          expect(response.totalResults, 100);
        },
      );
    });

    test('should pass pageToken to repository', () async {
      mockRepository.mockResult = const Right(PaginatedVideosResponse(
        videos: testVideos,
        nextPageToken: null,
        totalResults: 2,
      ));

      await useCase(param: const GetVideosParams(pageToken: 'test_token'));

      expect(mockRepository.lastPageToken, 'test_token');
    });

    test('should return failure when repository fails', () async {
      mockRepository.mockResult = const Left(ServerFailure('API error'));

      final result = await useCase(param: const GetVideosParams());

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'API error');
        },
        (response) => fail('Should not return response'),
      );
    });

    test('should return NetworkFailure on network error', () async {
      mockRepository.mockResult = const Left(NetworkFailure('No internet'));

      final result = await useCase(param: const GetVideosParams());

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<NetworkFailure>());
          expect(failure.message, 'No internet');
        },
        (response) => fail('Should not return response'),
      );
    });

    test('should return empty list when no videos', () async {
      mockRepository.mockResult = const Right(PaginatedVideosResponse(
        videos: [],
        nextPageToken: null,
        totalResults: 0,
      ));

      final result = await useCase(param: const GetVideosParams());

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (response) => expect(response.videos, isEmpty),
      );
    });

    test('call method should work without param', () async {
      mockRepository.mockResult = const Right(PaginatedVideosResponse(
        videos: testVideos,
        nextPageToken: null,
        totalResults: 2,
      ));

      final result = await useCase();

      expect(result.isRight(), true);
      expect(mockRepository.lastPageToken, null);
    });

    test('hasMore should be true when nextPageToken is present', () async {
      mockRepository.mockResult = const Right(PaginatedVideosResponse(
        videos: testVideos,
        nextPageToken: 'next_page',
        totalResults: 100,
      ));

      final result = await useCase();

      result.fold(
        (failure) => fail('Should not return failure'),
        (response) => expect(response.hasMore, true),
      );
    });

    test('hasMore should be false when nextPageToken is null', () async {
      mockRepository.mockResult = const Right(PaginatedVideosResponse(
        videos: testVideos,
        nextPageToken: null,
        totalResults: 2,
      ));

      final result = await useCase();

      result.fold(
        (failure) => fail('Should not return failure'),
        (response) => expect(response.hasMore, false),
      );
    });
  });
}
