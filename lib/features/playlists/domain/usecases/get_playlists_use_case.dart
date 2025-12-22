import 'package:dartz/dartz.dart';
import 'package:eng_alaa_hammed/core/error/failures.dart';
import 'package:eng_alaa_hammed/features/playlists/data/models/paginated_playlists_response.dart';
import 'package:eng_alaa_hammed/features/playlists/domain/repository/playlist_repository.dart';

class GetPlaylistsUseCase {
  final PlaylistRepository repository;

  GetPlaylistsUseCase(this.repository);

  Future<Either<Failure, PaginatedPlaylistsResponse>> call({
    String? pageToken,
  }) async {
    return await repository.getPlaylists(pageToken: pageToken);
  }
}
