import 'package:dartz/dartz.dart';
import 'package:eng_alaa_hammed/core/error/failures.dart';

import '../entities/video.dart';

abstract class VideoRepository {
  Future<Either<Failure, List<Video>>> getVideos();
}
