import 'package:dartz/dartz.dart';
import 'package:eng_alaa_hammed/core/helpers/logger_helper.dart';
import 'package:eng_alaa_hammed/features/videos/data/data_sources/youtube_service.dart';
import 'package:eng_alaa_hammed/features/videos/domain/repository/video_repository.dart';

import '../../domain/entities/video.dart';
import '../models/video_model.dart';

class VideoRepositoryImpl implements VideoRepository {
  final YouTubeService youTubeService;

  VideoRepositoryImpl({required this.youTubeService});

  @override
  Future<Either<String, List<Video>>> getVideos() async {
    try {
      LoggerHelper.debug(
          'Fetching videos from YouTube API'); // استخدام الـ Logger هنا
      final response = await youTubeService.fetchVideos();
      final List<Video> videos =
          response.map<Video>((video) => VideoModel.fromJson(video)).toList();
      LoggerHelper.info(
          'Videos fetched successfully'); // استخدام الـ Logger هنا
      return Right(videos);
    } catch (e) {
      LoggerHelper.error('Error fetching videos', e); // تسجيل الخطأ
      return Left('Failed to load videos');
    }
  }
}
