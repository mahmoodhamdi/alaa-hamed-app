import 'package:eng_alaa_hammed/core/constants/api_constants.dart';
import 'package:eng_alaa_hammed/core/helpers/logger_helper.dart';

import '../../../../core/network/dio_client.dart';

class YouTubeService {
  final DioClient dioClient;

  YouTubeService({required this.dioClient});

  Future<List<dynamic>> fetchVideos() async {
    try {
      LoggerHelper.debug(
          'Calling YouTube API to fetch videos'); // استخدام الـ Logger هنا
      final response = await dioClient.get(
        '${ApiConstants.baseUrl}/search',
        queryParameters: {
          'part': 'snippet',
          'channelId':
              ApiConstants.channelId, // لازم تحط الـ Channel ID بتاعك هنا
          'maxResults': 20,
          'order': 'date',
          'type': 'video',
          'key': ApiConstants.apiKey, // لازم تحط الـ API Key بتاعك هنا
        },
      );
      LoggerHelper.info(
          'Fetched ${response.data['items'].length} videos'); // استخدام الـ Logger هنا
      return response.data['items'];
    } catch (e) {
      LoggerHelper.error(
          'Error fetching videos from YouTube API', e); // تسجيل الخطأ
      throw Exception('Failed to load videos');
    }
  }
}
