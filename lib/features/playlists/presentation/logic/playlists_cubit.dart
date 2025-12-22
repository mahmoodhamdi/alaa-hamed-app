import 'package:eng_alaa_hammed/core/helpers/logger_helper.dart';
import 'package:eng_alaa_hammed/features/playlists/domain/usecases/get_playlists_use_case.dart';
import 'package:eng_alaa_hammed/features/playlists/presentation/logic/playlists_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlaylistsCubit extends Cubit<PlaylistsState> {
  final GetPlaylistsUseCase getPlaylistsUseCase;

  PlaylistsCubit(this.getPlaylistsUseCase) : super(const PlaylistsState());

  Future<void> fetchPlaylists() async {
    if (state.status == PlaylistsStatus.loading) return;

    emit(state.copyWith(status: PlaylistsStatus.loading));
    LoggerHelper.debug('Fetching playlists...');

    final result = await getPlaylistsUseCase.call();

    result.fold(
      (failure) {
        LoggerHelper.error('Failed to fetch playlists: ${failure.message}');
        emit(state.copyWith(
          status: PlaylistsStatus.error,
          errorMessage: failure.message,
        ));
      },
      (response) {
        LoggerHelper.info('Fetched ${response.playlists.length} playlists');
        emit(state.copyWith(
          status: PlaylistsStatus.loaded,
          playlists: response.playlists,
          nextPageToken: response.nextPageToken,
          hasReachedEnd: !response.hasMore,
        ));
      },
    );
  }

  Future<void> loadMorePlaylists() async {
    if (state.status == PlaylistsStatus.loadingMore ||
        state.hasReachedEnd ||
        state.nextPageToken == null) {
      return;
    }

    emit(state.copyWith(status: PlaylistsStatus.loadingMore));
    LoggerHelper.debug('Loading more playlists...');

    final result = await getPlaylistsUseCase.call(
      pageToken: state.nextPageToken,
    );

    result.fold(
      (failure) {
        LoggerHelper.error('Failed to load more playlists: ${failure.message}');
        emit(state.copyWith(
          status: PlaylistsStatus.loaded,
          errorMessage: failure.message,
        ));
      },
      (response) {
        LoggerHelper.info('Loaded ${response.playlists.length} more playlists');
        emit(state.copyWith(
          status: PlaylistsStatus.loaded,
          playlists: [...state.playlists, ...response.playlists],
          nextPageToken: response.nextPageToken,
          hasReachedEnd: !response.hasMore,
        ));
      },
    );
  }

  Future<void> refresh() async {
    emit(const PlaylistsState());
    await fetchPlaylists();
  }
}
