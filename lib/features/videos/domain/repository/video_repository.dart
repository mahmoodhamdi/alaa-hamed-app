import 'package:dartz/dartz.dart';
import '../entities/video.dart';

abstract class VideoRepository {
  Future<Either<String, List<Video>>> getVideos();
}
