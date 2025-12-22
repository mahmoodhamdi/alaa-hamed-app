import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';

/// Response model for paginated video results from YouTube API.
class PaginatedVideosResponse {
  final List<Video> videos;
  final String? nextPageToken;
  final int totalResults;
  final bool isFromCache;

  const PaginatedVideosResponse({
    required this.videos,
    this.nextPageToken,
    this.totalResults = 0,
    this.isFromCache = false,
  });

  bool get hasMore => nextPageToken != null;

  PaginatedVideosResponse copyWith({
    List<Video>? videos,
    String? nextPageToken,
    int? totalResults,
    bool? isFromCache,
  }) {
    return PaginatedVideosResponse(
      videos: videos ?? this.videos,
      nextPageToken: nextPageToken ?? this.nextPageToken,
      totalResults: totalResults ?? this.totalResults,
      isFromCache: isFromCache ?? this.isFromCache,
    );
  }
}
