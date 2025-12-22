import 'package:eng_alaa_hammed/core/enums/status.dart';
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
          nextPageToken: response.nextPageToken,
          totalResults: response.totalResults,
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
        emit(state.copyWith(
          status: AllVideosStatus.loaded,
          videos: response.videos,
          nextPageToken: response.nextPageToken,
          totalResults: response.totalResults,
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
        emit(state.copyWith(
          isLoadingMore: false,
          videos: [...state.videos, ...response.videos],
          nextPageToken: response.nextPageToken,
          totalResults: response.totalResults,
        ));
      },
    );
  }
}
