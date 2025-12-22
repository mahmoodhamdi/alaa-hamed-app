import 'package:dartz/dartz.dart';
import 'package:eng_alaa_hammed/core/error/failures.dart';
import 'package:eng_alaa_hammed/core/helpers/logger_helper.dart';
import 'package:eng_alaa_hammed/core/services/connectivity_service.dart';
import 'package:eng_alaa_hammed/core/services/video_cache_service.dart';
import 'package:eng_alaa_hammed/features/videos/data/data_sources/youtube_service.dart';
import 'package:eng_alaa_hammed/features/videos/data/models/paginated_videos_response.dart';
import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';
import 'package:eng_alaa_hammed/features/videos/domain/repository/video_repository.dart';

import '../models/video_model.dart';

class VideoRepositoryImpl implements VideoRepository {
  final YouTubeService youTubeService;
  final VideoCacheService? cacheService;
  final ConnectivityService? connectivityService;

  VideoRepositoryImpl({
    required this.youTubeService,
    this.cacheService,
    this.connectivityService,
  });

  @override
  Future<Either<Failure, PaginatedVideosResponse>> getVideos({
    String? pageToken,
  }) async {
    // Check connectivity
    final hasConnection =
        await connectivityService?.hasInternetConnection() ?? true;

    // If offline and first page, try to return cached data
    if (!hasConnection && pageToken == null) {
      LoggerHelper.info('No internet connection, trying to load from cache');
      final cachedVideos = await cacheService?.getCachedVideos();
      if (cachedVideos != null && cachedVideos.isNotEmpty) {
        LoggerHelper.info('Returning ${cachedVideos.length} cached videos');
        return Right(PaginatedVideosResponse(
          videos: cachedVideos,
          nextPageToken: null,
          totalResults: cachedVideos.length,
          isFromCache: true,
        ));
      }
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }

    try {
      LoggerHelper.debug(
          'Fetching videos from YouTube API${pageToken != null ? " (page: $pageToken)" : ""}');

      final response = await youTubeService.fetchVideos(pageToken: pageToken);

      final List<Video> videos = response.items
          .map<Video>((video) => VideoModel.fromJson(video))
          .toList();

      LoggerHelper.info('Videos fetched successfully');

      // Cache first page results
      if (pageToken == null && videos.isNotEmpty) {
        await cacheService?.cacheVideos(videos);
      }

      return Right(PaginatedVideosResponse(
        videos: videos,
        nextPageToken: response.nextPageToken,
        totalResults: response.totalResults,
      ));
    } on Failure catch (failure) {
      LoggerHelper.error('Failure fetching videos: ${failure.message}');

      // Try to return cached data on failure (first page only)
      if (pageToken == null) {
        final cachedVideos = await cacheService?.getCachedVideos();
        if (cachedVideos != null && cachedVideos.isNotEmpty) {
          LoggerHelper.info('Returning cached videos due to API failure');
          return Right(PaginatedVideosResponse(
            videos: cachedVideos,
            nextPageToken: null,
            totalResults: cachedVideos.length,
            isFromCache: true,
          ));
        }
      }

      return Left(failure);
    } catch (e) {
      LoggerHelper.error('Unexpected error fetching videos', e);

      // Try to return cached data on unexpected error (first page only)
      if (pageToken == null) {
        final cachedVideos = await cacheService?.getCachedVideos();
        if (cachedVideos != null && cachedVideos.isNotEmpty) {
          LoggerHelper.info('Returning cached videos due to unexpected error');
          return Right(PaginatedVideosResponse(
            videos: cachedVideos,
            nextPageToken: null,
            totalResults: cachedVideos.length,
            isFromCache: true,
          ));
        }
      }

      return const Left(UnexpectedFailure('Failed to load videos'));
    }
  }
}
