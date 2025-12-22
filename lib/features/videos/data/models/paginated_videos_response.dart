import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';

/// Response model for paginated video results from YouTube API.
class PaginatedVideosResponse {
  final List<Video> videos;
  final String? nextPageToken;
  final int totalResults;

  const PaginatedVideosResponse({
    required this.videos,
    this.nextPageToken,
    this.totalResults = 0,
  });

  bool get hasMore => nextPageToken != null;

  PaginatedVideosResponse copyWith({
    List<Video>? videos,
    String? nextPageToken,
    int? totalResults,
  }) {
    return PaginatedVideosResponse(
      videos: videos ?? this.videos,
      nextPageToken: nextPageToken ?? this.nextPageToken,
      totalResults: totalResults ?? this.totalResults,
    );
  }
}
