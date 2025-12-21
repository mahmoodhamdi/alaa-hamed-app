import 'package:dartz/dartz.dart';
import 'package:eng_alaa_hammed/core/error/failures.dart';
import 'package:eng_alaa_hammed/core/helpers/logger_helper.dart';
import 'package:eng_alaa_hammed/features/videos/data/data_sources/youtube_service.dart';
import 'package:eng_alaa_hammed/features/videos/domain/repository/video_repository.dart';

import '../../domain/entities/video.dart';
import '../models/video_model.dart';

class VideoRepositoryImpl implements VideoRepository {
  final YouTubeService youTubeService;

  VideoRepositoryImpl({required this.youTubeService});

  @override
  Future<Either<Failure, List<Video>>> getVideos() async {
    try {
      LoggerHelper.debug('Fetching videos from YouTube API');
      final response = await youTubeService.fetchVideos();
      final List<Video> videos =
          response.map<Video>((video) => VideoModel.fromJson(video)).toList();
      LoggerHelper.info('Videos fetched successfully');
      return Right(videos);
    } on Failure catch (failure) {
      LoggerHelper.error('Failure fetching videos: ${failure.message}');
      return Left(failure);
    } catch (e) {
      LoggerHelper.error('Unexpected error fetching videos', e);
      return const Left(UnexpectedFailure('Failed to load videos'));
    }
  }
}
