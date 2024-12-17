import 'package:eng_alaa_hammed/core/enums/status.dart';
import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';

class VideosState {
  final VideosStatus status;
  final List<Video> videos;
  final String errorMessage;

  const VideosState({
    this.status = VideosStatus.initial,
    this.videos = const [],
    this.errorMessage = '',
  });

  VideosState copyWith({
    VideosStatus? status,
    List<Video>? videos,
    String? errorMessage,
  }) {
    return VideosState(
      status: status ?? this.status,
      videos: videos ?? this.videos,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
