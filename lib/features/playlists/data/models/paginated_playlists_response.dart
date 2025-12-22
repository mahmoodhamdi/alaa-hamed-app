import 'package:eng_alaa_hammed/features/playlists/domain/entities/playlist.dart';

class PaginatedPlaylistsResponse {
  final List<Playlist> playlists;
  final String? nextPageToken;
  final int totalResults;

  const PaginatedPlaylistsResponse({
    required this.playlists,
    this.nextPageToken,
    this.totalResults = 0,
  });

  bool get hasMore => nextPageToken != null;
}
