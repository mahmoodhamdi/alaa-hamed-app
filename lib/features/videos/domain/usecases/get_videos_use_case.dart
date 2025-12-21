import 'package:dartz/dartz.dart';
import 'package:eng_alaa_hammed/core/error/failures.dart';
import 'package:eng_alaa_hammed/core/usecase/usecase.dart';
import 'package:eng_alaa_hammed/features/videos/domain/repository/video_repository.dart';

import '../entities/video.dart';

class GetVideosUseCase implements UseCase<Either<Failure, List<Video>>, NoParams> {
  final VideoRepository repository;

  GetVideosUseCase(this.repository);

  @override
  Future<Either<Failure, List<Video>>> call({NoParams? param}) {
    return repository.getVideos();
  }
}
