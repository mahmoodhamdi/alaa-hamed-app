import 'package:dartz/dartz.dart';
import 'package:eng_alaa_hammed/features/videos/domain/repository/video_repository.dart';

import '../entities/video.dart';

class GetVideosUseCase {
  final VideoRepository repository;

  GetVideosUseCase(this.repository);

  Future<Either<String, List<Video>>> execute() {
    return repository.getVideos();
  }
}
