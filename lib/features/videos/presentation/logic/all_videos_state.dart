import 'package:eng_alaa_hammed/core/enums/status.dart';
import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';

class AllVideosState {
  final AllVideosStatus status;
  final List<Video> videos;
  final String errorMessage;
  final String? nextPageToken;
  final bool isLoadingMore;
  final int totalResults;

  const AllVideosState({
    this.status = AllVideosStatus.initial,
    this.videos = const [],
    this.errorMessage = '',
    this.nextPageToken,
    this.isLoadingMore = false,
    this.totalResults = 0,
  });

  /// Whether there are more videos to load.
  bool get hasMore => nextPageToken != null;

  AllVideosState copyWith({
    AllVideosStatus? status,
    List<Video>? videos,
    String? errorMessage,
    String? nextPageToken,
    bool? isLoadingMore,
    int? totalResults,
    bool clearNextPageToken = false,
  }) {
    return AllVideosState(
      status: status ?? this.status,
      videos: videos ?? this.videos,
      errorMessage: errorMessage ?? this.errorMessage,
      nextPageToken:
          clearNextPageToken ? null : (nextPageToken ?? this.nextPageToken),
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      totalResults: totalResults ?? this.totalResults,
    );
  }
}
