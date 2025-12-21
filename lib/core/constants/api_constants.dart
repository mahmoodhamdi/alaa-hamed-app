import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  ApiConstants._();

  static String get apiKey => dotenv.env['YOUTUBE_API_KEY'] ?? '';
  static const String baseUrl = 'https://www.googleapis.com/youtube/v3/';
  static String get channelId => dotenv.env['YOUTUBE_CHANNEL_ID'] ?? '';
}
