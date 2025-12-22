import 'package:dartz/dartz.dart';
import 'package:eng_alaa_hammed/core/error/failures.dart';
import 'package:eng_alaa_hammed/features/videos/data/models/paginated_videos_response.dart';

/// Repository interface for video operations.
abstract class VideoRepository {
  /// Fetches videos with pagination support.
  /// [pageToken] - Optional token for fetching next page of results.
  Future<Either<Failure, PaginatedVideosResponse>> getVideos({
    String? pageToken,
  });
}
