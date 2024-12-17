import 'package:eng_alaa_hammed/core/enums/status.dart';
import 'package:eng_alaa_hammed/features/videos/domain/usecases/get_videos_use_case.dart';
import 'package:eng_alaa_hammed/features/videos/presentation/logic/all_videos_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VideoCubit extends Cubit<AllVideosState> {
  final GetVideosUseCase getVideosUseCase;

  VideoCubit(this.getVideosUseCase) : super(const AllVideosState());

  Future<void> fetchVideos() async {
    emit(state.copyWith(status: AllVideosStatus.loading));

    final result = await getVideosUseCase.execute();
    result.fold(
      (failureMessage) {
        emit(state.copyWith(
          status: AllVideosStatus.failure,
          errorMessage: failureMessage,
        ));
      },
      (videos) {
        emit(state.copyWith(
          status: AllVideosStatus.loaded,
          videos: videos,
        ));
      },
    );
  }
}
