import 'package:eng_alaa_hammed/core/helpers/logger_helper.dart';
import 'package:eng_alaa_hammed/features/playlists/domain/usecases/get_playlist_videos_use_case.dart';
import 'package:eng_alaa_hammed/features/playlists/presentation/logic/playlist_videos_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlaylistVideosCubit extends Cubit<PlaylistVideosState> {
  final GetPlaylistVideosUseCase getPlaylistVideosUseCase;

  PlaylistVideosCubit(this.getPlaylistVideosUseCase)
      : super(const PlaylistVideosState());

  Future<void> fetchVideos({
    required String playlistId,
    required String playlistTitle,
  }) async {
    if (state.status == PlaylistVideosStatus.loading) return;

    emit(state.copyWith(
      status: PlaylistVideosStatus.loading,
      playlistId: playlistId,
      playlistTitle: playlistTitle,
    ));
    LoggerHelper.debug('Fetching videos for playlist: $playlistId');

    final result = await getPlaylistVideosUseCase.call(playlistId: playlistId);

    result.fold(
      (failure) {
        LoggerHelper.error('Failed to fetch playlist videos: ${failure.message}');
        emit(state.copyWith(
          status: PlaylistVideosStatus.error,
          errorMessage: failure.message,
        ));
      },
      (response) {
        LoggerHelper.info('Fetched ${response.videos.length} playlist videos');
        emit(state.copyWith(
          status: PlaylistVideosStatus.loaded,
          videos: response.videos,
          nextPageToken: response.nextPageToken,
          hasReachedEnd: !response.hasMore,
        ));
      },
    );
  }

  Future<void> loadMoreVideos() async {
    if (state.status == PlaylistVideosStatus.loadingMore ||
        state.hasReachedEnd ||
        state.nextPageToken == null) {
      return;
    }

    emit(state.copyWith(status: PlaylistVideosStatus.loadingMore));
    LoggerHelper.debug('Loading more videos for playlist: ${state.playlistId}');

    final result = await getPlaylistVideosUseCase.call(
      playlistId: state.playlistId,
      pageToken: state.nextPageToken,
    );

    result.fold(
      (failure) {
        LoggerHelper.error('Failed to load more playlist videos: ${failure.message}');
        emit(state.copyWith(
          status: PlaylistVideosStatus.loaded,
          errorMessage: failure.message,
        ));
      },
      (response) {
        LoggerHelper.info('Loaded ${response.videos.length} more playlist videos');
        emit(state.copyWith(
          status: PlaylistVideosStatus.loaded,
          videos: [...state.videos, ...response.videos],
          nextPageToken: response.nextPageToken,
          hasReachedEnd: !response.hasMore,
        ));
      },
    );
  }

  Future<void> refresh() async {
    final playlistId = state.playlistId;
    final playlistTitle = state.playlistTitle;
    emit(const PlaylistVideosState());
    await fetchVideos(playlistId: playlistId, playlistTitle: playlistTitle);
  }
}
