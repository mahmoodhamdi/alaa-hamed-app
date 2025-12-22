import 'package:dartz/dartz.dart';
import 'package:eng_alaa_hammed/core/error/failures.dart';
import 'package:eng_alaa_hammed/features/playlists/domain/repository/playlist_repository.dart';
import 'package:eng_alaa_hammed/features/videos/data/models/paginated_videos_response.dart';

class GetPlaylistVideosUseCase {
  final PlaylistRepository repository;

  GetPlaylistVideosUseCase(this.repository);

  Future<Either<Failure, PaginatedVideosResponse>> call({
    required String playlistId,
    String? pageToken,
  }) async {
    return await repository.getPlaylistVideos(
      playlistId: playlistId,
      pageToken: pageToken,
    );
  }
}
