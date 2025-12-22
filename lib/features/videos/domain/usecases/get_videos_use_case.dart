import 'package:dartz/dartz.dart';
import 'package:eng_alaa_hammed/core/error/failures.dart';
import 'package:eng_alaa_hammed/core/usecase/usecase.dart';
import 'package:eng_alaa_hammed/features/videos/data/models/paginated_videos_response.dart';
import 'package:eng_alaa_hammed/features/videos/domain/repository/video_repository.dart';

/// Parameters for fetching videos with pagination.
class GetVideosParams {
  final String? pageToken;

  const GetVideosParams({this.pageToken});
}

class GetVideosUseCase
    implements UseCase<Either<Failure, PaginatedVideosResponse>, GetVideosParams> {
  final VideoRepository repository;

  GetVideosUseCase(this.repository);

  @override
  Future<Either<Failure, PaginatedVideosResponse>> call({
    GetVideosParams? param,
  }) {
    return repository.getVideos(pageToken: param?.pageToken);
  }
}
