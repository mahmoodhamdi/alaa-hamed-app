import 'package:dartz/dartz.dart';
import 'package:eng_alaa_hammed/core/error/failures.dart';
import 'package:eng_alaa_hammed/core/helpers/logger_helper.dart';
import 'package:eng_alaa_hammed/features/playlists/data/models/paginated_playlists_response.dart';
import 'package:eng_alaa_hammed/features/playlists/data/models/playlist_model.dart';
import 'package:eng_alaa_hammed/features/playlists/domain/repository/playlist_repository.dart';
import 'package:eng_alaa_hammed/features/videos/data/data_sources/youtube_service.dart';
import 'package:eng_alaa_hammed/features/videos/data/models/paginated_videos_response.dart';
import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';

class PlaylistRepositoryImpl implements PlaylistRepository {
  final YouTubeService youTubeService;

  PlaylistRepositoryImpl({required this.youTubeService});

  @override
  Future<Either<Failure, PaginatedPlaylistsResponse>> getPlaylists({
    String? pageToken,
  }) async {
    try {
      LoggerHelper.debug('Fetching playlists from repository');
      final response = await youTubeService.fetchPlaylists(pageToken: pageToken);

      final playlists = response.items.map((json) {
        return PlaylistModel.fromJson(json as Map<String, dynamic>);
      }).toList();

      LoggerHelper.info('Successfully fetched ${playlists.length} playlists');

      return Right(PaginatedPlaylistsResponse(
        playlists: playlists,
        nextPageToken: response.nextPageToken,
        totalResults: response.totalResults,
      ));
    } on Failure catch (failure) {
      LoggerHelper.error('Failed to fetch playlists: ${failure.message}');
      return Left(failure);
    } catch (e) {
      LoggerHelper.error('Unexpected error fetching playlists', e);
      return const Left(UnexpectedFailure('Failed to load playlists'));
    }
  }

  @override
  Future<Either<Failure, PaginatedVideosResponse>> getPlaylistVideos({
    required String playlistId,
    String? pageToken,
  }) async {
    try {
      LoggerHelper.debug('Fetching videos for playlist: $playlistId');
      final response = await youTubeService.fetchPlaylistItems(
        playlistId: playlistId,
        pageToken: pageToken,
      );

      final videos = response.items.map((json) {
        return _parsePlaylistItem(json as Map<String, dynamic>);
      }).toList();

      LoggerHelper.info('Successfully fetched ${videos.length} playlist videos');

      return Right(PaginatedVideosResponse(
        videos: videos,
        nextPageToken: response.nextPageToken,
        totalResults: response.totalResults,
      ));
    } on Failure catch (failure) {
      LoggerHelper.error('Failed to fetch playlist videos: ${failure.message}');
      return Left(failure);
    } catch (e) {
      LoggerHelper.error('Unexpected error fetching playlist videos', e);
      return const Left(UnexpectedFailure('Failed to load playlist videos'));
    }
  }

  /// Parses a playlist item into a Video entity.
  /// PlaylistItems have a different structure than search results.
  Video _parsePlaylistItem(Map<String, dynamic> json) {
    final snippet = json['snippet'] as Map<String, dynamic>;
    final contentDetails = json['contentDetails'] as Map<String, dynamic>?;
    final thumbnails = snippet['thumbnails'] as Map<String, dynamic>;

    // Get the video ID from contentDetails (for playlistItems)
    final videoId = contentDetails?['videoId'] as String? ??
        (snippet['resourceId'] as Map<String, dynamic>?)?['videoId'] as String? ??
        '';

    // Get the best available thumbnail
    String thumbnailUrl = '';
    if (thumbnails['high'] != null) {
      thumbnailUrl = thumbnails['high']['url'] as String;
    } else if (thumbnails['medium'] != null) {
      thumbnailUrl = thumbnails['medium']['url'] as String;
    } else if (thumbnails['default'] != null) {
      thumbnailUrl = thumbnails['default']['url'] as String;
    }

    return Video(
      id: videoId,
      title: snippet['title'] as String? ?? '',
      description: snippet['description'] as String? ?? '',
      thumbnailUrl: thumbnailUrl,
      publishedAt: snippet['publishedAt'] as String? ?? '',
      videoUrl: 'https://www.youtube.com/watch?v=$videoId',
    );
  }
}
