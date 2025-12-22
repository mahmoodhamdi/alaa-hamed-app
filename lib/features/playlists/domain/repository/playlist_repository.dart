import 'package:dartz/dartz.dart';
import 'package:eng_alaa_hammed/core/error/failures.dart';
import 'package:eng_alaa_hammed/features/playlists/data/models/paginated_playlists_response.dart';
import 'package:eng_alaa_hammed/features/videos/data/models/paginated_videos_response.dart';

abstract class PlaylistRepository {
  /// Fetches playlists from the channel.
  /// [pageToken] - Optional token for pagination.
  Future<Either<Failure, PaginatedPlaylistsResponse>> getPlaylists({
    String? pageToken,
  });

  /// Fetches videos from a specific playlist.
  /// [playlistId] - The ID of the playlist.
  /// [pageToken] - Optional token for pagination.
  Future<Either<Failure, PaginatedVideosResponse>> getPlaylistVideos({
    required String playlistId,
    String? pageToken,
  });
}
