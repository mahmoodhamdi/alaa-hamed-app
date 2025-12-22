import 'package:equatable/equatable.dart';
import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';

enum PlaylistVideosStatus { initial, loading, loaded, loadingMore, error }

class PlaylistVideosState extends Equatable {
  final PlaylistVideosStatus status;
  final List<Video> videos;
  final String? nextPageToken;
  final String? errorMessage;
  final bool hasReachedEnd;
  final String playlistId;
  final String playlistTitle;

  const PlaylistVideosState({
    this.status = PlaylistVideosStatus.initial,
    this.videos = const [],
    this.nextPageToken,
    this.errorMessage,
    this.hasReachedEnd = false,
    this.playlistId = '',
    this.playlistTitle = '',
  });

  PlaylistVideosState copyWith({
    PlaylistVideosStatus? status,
    List<Video>? videos,
    String? nextPageToken,
    String? errorMessage,
    bool? hasReachedEnd,
    String? playlistId,
    String? playlistTitle,
  }) {
    return PlaylistVideosState(
      status: status ?? this.status,
      videos: videos ?? this.videos,
      nextPageToken: nextPageToken,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      playlistId: playlistId ?? this.playlistId,
      playlistTitle: playlistTitle ?? this.playlistTitle,
    );
  }

  @override
  List<Object?> get props => [
        status,
        videos,
        nextPageToken,
        errorMessage,
        hasReachedEnd,
        playlistId,
        playlistTitle,
      ];
}
