import 'package:eng_alaa_hammed/core/enums/status.dart';
import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';

class AllVideosState {
  final AllVideosStatus status;
  final List<Video> videos;
  final List<Video> allVideos; // All videos for search filtering
  final String errorMessage;
  final String? nextPageToken;
  final bool isLoadingMore;
  final int totalResults;
  final String searchQuery;
  final bool isFromCache;

  const AllVideosState({
    this.status = AllVideosStatus.initial,
    this.videos = const [],
    this.allVideos = const [],
    this.errorMessage = '',
    this.nextPageToken,
    this.isLoadingMore = false,
    this.totalResults = 0,
    this.searchQuery = '',
    this.isFromCache = false,
  });

  /// Whether there are more videos to load.
  bool get hasMore => nextPageToken != null && searchQuery.isEmpty;

  /// Whether search is active
  bool get isSearching => searchQuery.isNotEmpty;

  AllVideosState copyWith({
    AllVideosStatus? status,
    List<Video>? videos,
    List<Video>? allVideos,
    String? errorMessage,
    String? nextPageToken,
    bool? isLoadingMore,
    int? totalResults,
    String? searchQuery,
    bool? isFromCache,
    bool clearNextPageToken = false,
  }) {
    return AllVideosState(
      status: status ?? this.status,
      videos: videos ?? this.videos,
      allVideos: allVideos ?? this.allVideos,
      errorMessage: errorMessage ?? this.errorMessage,
      nextPageToken:
          clearNextPageToken ? null : (nextPageToken ?? this.nextPageToken),
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      totalResults: totalResults ?? this.totalResults,
      searchQuery: searchQuery ?? this.searchQuery,
      isFromCache: isFromCache ?? this.isFromCache,
    );
  }
}
