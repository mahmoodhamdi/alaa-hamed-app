import 'package:eng_alaa_hammed/core/enums/status.dart';
import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';
import 'package:eng_alaa_hammed/features/videos/domain/usecases/get_videos_use_case.dart';
import 'package:eng_alaa_hammed/features/videos/presentation/logic/all_videos_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VideoCubit extends Cubit<AllVideosState> {
  final GetVideosUseCase getVideosUseCase;

  VideoCubit(this.getVideosUseCase) : super(const AllVideosState());

  /// Fetches the first page of videos.
  Future<void> fetchVideos() async {
    emit(state.copyWith(
      status: AllVideosStatus.loading,
      clearNextPageToken: true,
      searchQuery: '',
    ));

    final result = await getVideosUseCase(param: const GetVideosParams());
    result.fold(
      (failure) {
        emit(state.copyWith(
          status: AllVideosStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (response) {
        emit(state.copyWith(
          status: AllVideosStatus.loaded,
          videos: response.videos,
          allVideos: response.videos,
          nextPageToken: response.nextPageToken,
          totalResults: response.totalResults,
          isFromCache: response.isFromCache,
        ));
      },
    );
  }

  /// Refreshes the video list by fetching the first page again.
  Future<void> refreshVideos() async {
    final result = await getVideosUseCase(param: const GetVideosParams());
    result.fold(
      (failure) {
        emit(state.copyWith(
          errorMessage: failure.message,
        ));
      },
      (response) {
        final videos = response.videos;
        final filteredVideos = state.searchQuery.isEmpty
            ? videos
            : _filterVideos(videos, state.searchQuery);
        emit(state.copyWith(
          status: AllVideosStatus.loaded,
          videos: filteredVideos,
          allVideos: videos,
          nextPageToken: response.nextPageToken,
          totalResults: response.totalResults,
          isFromCache: response.isFromCache,
        ));
      },
    );
  }

  /// Loads the next page of videos (infinite scroll).
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));

    final result = await getVideosUseCase(
      param: GetVideosParams(pageToken: state.nextPageToken),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoadingMore: false,
          errorMessage: failure.message,
        ));
      },
      (response) {
        final allVideos = [...state.allVideos, ...response.videos];
        final filteredVideos = state.searchQuery.isEmpty
            ? allVideos
            : _filterVideos(allVideos, state.searchQuery);
        emit(state.copyWith(
          isLoadingMore: false,
          videos: filteredVideos,
          allVideos: allVideos,
          nextPageToken: response.nextPageToken,
          totalResults: response.totalResults,
        ));
      },
    );
  }

  /// Search videos by title or description
  void searchVideos(String query) {
    final trimmedQuery = query.trim();
    if (trimmedQuery == state.searchQuery) return;

    if (trimmedQuery.isEmpty) {
      emit(state.copyWith(
        videos: state.allVideos,
        searchQuery: '',
      ));
    } else {
      final filteredVideos = _filterVideos(state.allVideos, trimmedQuery);
      emit(state.copyWith(
        videos: filteredVideos,
        searchQuery: trimmedQuery,
      ));
    }
  }

  /// Clear search and show all videos
  void clearSearch() {
    emit(state.copyWith(
      videos: state.allVideos,
      searchQuery: '',
    ));
  }

  List<Video> _filterVideos(List<Video> videos, String query) {
    final lowerQuery = query.toLowerCase();
    return videos.where((video) {
      return video.title.toLowerCase().contains(lowerQuery) ||
          video.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
