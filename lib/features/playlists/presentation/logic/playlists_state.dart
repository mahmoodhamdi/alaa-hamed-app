import 'package:equatable/equatable.dart';
import 'package:eng_alaa_hammed/features/playlists/domain/entities/playlist.dart';

enum PlaylistsStatus { initial, loading, loaded, loadingMore, error }

class PlaylistsState extends Equatable {
  final PlaylistsStatus status;
  final List<Playlist> playlists;
  final String? nextPageToken;
  final String? errorMessage;
  final bool hasReachedEnd;

  const PlaylistsState({
    this.status = PlaylistsStatus.initial,
    this.playlists = const [],
    this.nextPageToken,
    this.errorMessage,
    this.hasReachedEnd = false,
  });

  PlaylistsState copyWith({
    PlaylistsStatus? status,
    List<Playlist>? playlists,
    String? nextPageToken,
    String? errorMessage,
    bool? hasReachedEnd,
  }) {
    return PlaylistsState(
      status: status ?? this.status,
      playlists: playlists ?? this.playlists,
      nextPageToken: nextPageToken,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }

  @override
  List<Object?> get props => [
        status,
        playlists,
        nextPageToken,
        errorMessage,
        hasReachedEnd,
      ];
}
