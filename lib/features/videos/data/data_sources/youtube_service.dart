import 'package:dio/dio.dart';
import 'package:eng_alaa_hammed/core/constants/api_constants.dart';
import 'package:eng_alaa_hammed/core/error/failures.dart';
import 'package:eng_alaa_hammed/core/helpers/logger_helper.dart';

import '../../../../core/network/dio_client.dart';

class YouTubeService {
  final DioClient dioClient;

  YouTubeService({required this.dioClient});

  Future<List<dynamic>> fetchVideos() async {
    try {
      LoggerHelper.debug('Calling YouTube API to fetch videos');
      final response = await dioClient.get(
        '${ApiConstants.baseUrl}search',
        queryParameters: {
          'part': 'snippet',
          'channelId': ApiConstants.channelId,
          'maxResults': 10,
          'order': 'date',
          'type': 'video',
          'key': ApiConstants.apiKey,
        },
      );
      LoggerHelper.info('Fetched ${response.data['items'].length} videos');
      return response.data['items'];
    } on DioException catch (e) {
      LoggerHelper.error('DioException fetching videos', e);
      throw _handleDioException(e);
    } catch (e) {
      LoggerHelper.error('Unexpected error fetching videos', e);
      throw const UnexpectedFailure('Failed to load videos');
    }
  }

  Failure _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('Connection timeout');
      case DioExceptionType.connectionError:
        return const NetworkFailure('No internet connection');
      case DioExceptionType.badResponse:
        return _handleBadResponse(e.response?.statusCode);
      case DioExceptionType.cancel:
        return const NetworkFailure('Request cancelled');
      default:
        return const UnexpectedFailure('Network error occurred');
    }
  }

  Failure _handleBadResponse(int? statusCode) {
    switch (statusCode) {
      case 400:
        return const ServerFailure('Bad request');
      case 401:
        return const AuthenticationFailure('Unauthorized');
      case 403:
        return const ServerFailure('Forbidden - API quota exceeded');
      case 404:
        return const ServerFailure('Not found');
      case 500:
      case 502:
      case 503:
        return const ServerFailure('Server error');
      default:
        return ServerFailure('Server error: $statusCode');
    }
  }
}
