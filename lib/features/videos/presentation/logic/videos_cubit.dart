import 'package:bloc/bloc.dart';
import 'package:eng_alaa_hammed/core/enums/status.dart';
import 'package:eng_alaa_hammed/features/videos/domain/usecases/get_videos_use_case.dart';
import 'package:eng_alaa_hammed/features/videos/presentation/logic/videos_state.dart';

class VideoCubit extends Cubit<VideosState> {
  final GetVideosUseCase getVideosUseCase;

  VideoCubit(this.getVideosUseCase) : super(const VideosState());

  Future<void> fetchVideos() async {
    emit(state.copyWith(status: VideosStatus.loading));

    final result = await getVideosUseCase.execute();
    result.fold(
      (failureMessage) {
        emit(state.copyWith(
          status: VideosStatus.failure,
          errorMessage: failureMessage,
        ));
      },
      (videos) {
        emit(state.copyWith(
          status: VideosStatus.loaded,
          videos: videos,
        ));
      },
    );
  }
}
