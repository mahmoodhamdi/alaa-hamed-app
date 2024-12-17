import 'package:eng_alaa_hammed/core/enums/status.dart';
import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';

class AllVideosState {
  final AllVideosStatus status;
  final List<Video> videos;
  final String errorMessage;

  const AllVideosState({
    this.status = AllVideosStatus.initial,
    this.videos = const [],
    this.errorMessage = '',
  });

  AllVideosState copyWith({
    AllVideosStatus? status,
    List<Video>? videos,
    String? errorMessage,
  }) {
    return AllVideosState(
      status: status ?? this.status,
      videos: videos ?? this.videos,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
