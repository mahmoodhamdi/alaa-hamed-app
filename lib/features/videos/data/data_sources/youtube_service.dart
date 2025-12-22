import 'package:dio/dio.dart';
import 'package:eng_alaa_hammed/core/constants/api_constants.dart';
import 'package:eng_alaa_hammed/core/error/failures.dart';
import 'package:eng_alaa_hammed/core/helpers/logger_helper.dart';
import 'package:eng_alaa_hammed/core/helpers/retry_helper.dart';

import '../../../../core/network/dio_client.dart';

/// Response from YouTube API containing items and pagination info.
class YouTubeApiResponse {
  final List<dynamic> items;
  final String? nextPageToken;
  final int totalResults;

  YouTubeApiResponse({
    required this.items,
    this.nextPageToken,
    this.totalResults = 0,
  });
}

/// Response from YouTube API for playlists.
class PlaylistsApiResponse {
  final List<dynamic> items;
  final String? nextPageToken;
  final int totalResults;

  PlaylistsApiResponse({
    required this.items,
    this.nextPageToken,
    this.totalResults = 0,
  });
}

class YouTubeService {
  final DioClient dioClient;
  static const int _pageSize = 10;
  static const int _maxRetryAttempts = 3;

  YouTubeService({required this.dioClient});

  /// Fetches videos with pagination support and automatic retry.
  /// [pageToken] - Optional token for fetching next page of results.
  Future<YouTubeApiResponse> fetchVideos({String? pageToken}) async {
    try {
      return await RetryHelper.withExponentialBackoff(
        maxAttempts: _maxRetryAttempts,
        retryIf: _shouldRetry,
        fn: () => _fetchVideosInternal(pageToken: pageToken),
      );
    } on Failure {
      rethrow;
    } catch (e) {
      LoggerHelper.error('Unexpected error fetching videos', e);
      throw const UnexpectedFailure('Failed to load videos');
    }
  }

  /// Internal method that performs the actual API call.
  Future<YouTubeApiResponse> _fetchVideosInternal({String? pageToken}) async {
    LoggerHelper.debug(
        'Calling YouTube API to fetch videos${pageToken != null ? " (page: $pageToken)" : ""}');

    final queryParams = <String, dynamic>{
      'part': 'snippet',
      'channelId': ApiConstants.channelId,
      'maxResults': _pageSize,
      'order': 'date',
      'type': 'video',
      'key': ApiConstants.apiKey,
    };

    if (pageToken != null) {
      queryParams['pageToken'] = pageToken;
    }

    try {
      final response = await dioClient.get(
        '${ApiConstants.baseUrl}search',
        queryParameters: queryParams,
      );

      final items = response.data['items'] as List<dynamic>;
      final nextToken = response.data['nextPageToken'] as String?;
      final totalResults =
          response.data['pageInfo']?['totalResults'] as int? ?? 0;

      LoggerHelper.info(
          'Fetched ${items.length} videos (total: $totalResults, hasMore: ${nextToken != null})');

      return YouTubeApiResponse(
        items: items,
        nextPageToken: nextToken,
        totalResults: totalResults,
      );
    } on DioException catch (e) {
      LoggerHelper.error('DioException fetching videos', e);
      throw _handleDioException(e);
    }
  }

  /// Determines if an exception should trigger a retry.
  /// Only retry for network errors, not for auth or quota issues.
  bool _shouldRetry(Exception e) {
    if (e is NetworkFailure) {
      return true;
    }
    if (e is Failure) {
      // Retry for 5xx server errors, but not for quota/auth issues
      final message = e.message;
      return message.contains('Server error') &&
          !message.contains('quota') &&
          !message.contains('Forbidden');
    }
    return false;
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

  /// Fetches playlists for the channel with pagination support.
  /// [pageToken] - Optional token for fetching next page of results.
  Future<PlaylistsApiResponse> fetchPlaylists({String? pageToken}) async {
    try {
      return await RetryHelper.withExponentialBackoff(
        maxAttempts: _maxRetryAttempts,
        retryIf: _shouldRetry,
        fn: () => _fetchPlaylistsInternal(pageToken: pageToken),
      );
    } on Failure {
      rethrow;
    } catch (e) {
      LoggerHelper.error('Unexpected error fetching playlists', e);
      throw const UnexpectedFailure('Failed to load playlists');
    }
  }

  /// Internal method that fetches playlists from YouTube API.
  Future<PlaylistsApiResponse> _fetchPlaylistsInternal(
      {String? pageToken}) async {
    LoggerHelper.debug(
        'Calling YouTube API to fetch playlists${pageToken != null ? " (page: $pageToken)" : ""}');

    final queryParams = <String, dynamic>{
      'part': 'snippet,contentDetails',
      'channelId': ApiConstants.channelId,
      'maxResults': _pageSize,
      'key': ApiConstants.apiKey,
    };

    if (pageToken != null) {
      queryParams['pageToken'] = pageToken;
    }

    try {
      final response = await dioClient.get(
        '${ApiConstants.baseUrl}playlists',
        queryParameters: queryParams,
      );

      final items = response.data['items'] as List<dynamic>;
      final nextToken = response.data['nextPageToken'] as String?;
      final totalResults =
          response.data['pageInfo']?['totalResults'] as int? ?? 0;

      LoggerHelper.info(
          'Fetched ${items.length} playlists (total: $totalResults, hasMore: ${nextToken != null})');

      return PlaylistsApiResponse(
        items: items,
        nextPageToken: nextToken,
        totalResults: totalResults,
      );
    } on DioException catch (e) {
      LoggerHelper.error('DioException fetching playlists', e);
      throw _handleDioException(e);
    }
  }

  /// Fetches videos from a specific playlist with pagination support.
  /// [playlistId] - The ID of the playlist to fetch videos from.
  /// [pageToken] - Optional token for fetching next page of results.
  Future<YouTubeApiResponse> fetchPlaylistItems({
    required String playlistId,
    String? pageToken,
  }) async {
    try {
      return await RetryHelper.withExponentialBackoff(
        maxAttempts: _maxRetryAttempts,
        retryIf: _shouldRetry,
        fn: () => _fetchPlaylistItemsInternal(
          playlistId: playlistId,
          pageToken: pageToken,
        ),
      );
    } on Failure {
      rethrow;
    } catch (e) {
      LoggerHelper.error('Unexpected error fetching playlist items', e);
      throw const UnexpectedFailure('Failed to load playlist videos');
    }
  }

  /// Internal method that fetches playlist items from YouTube API.
  Future<YouTubeApiResponse> _fetchPlaylistItemsInternal({
    required String playlistId,
    String? pageToken,
  }) async {
    LoggerHelper.debug(
        'Calling YouTube API to fetch playlist items for $playlistId${pageToken != null ? " (page: $pageToken)" : ""}');

    final queryParams = <String, dynamic>{
      'part': 'snippet,contentDetails',
      'playlistId': playlistId,
      'maxResults': _pageSize,
      'key': ApiConstants.apiKey,
    };

    if (pageToken != null) {
      queryParams['pageToken'] = pageToken;
    }

    try {
      final response = await dioClient.get(
        '${ApiConstants.baseUrl}playlistItems',
        queryParameters: queryParams,
      );

      final items = response.data['items'] as List<dynamic>;
      final nextToken = response.data['nextPageToken'] as String?;
      final totalResults =
          response.data['pageInfo']?['totalResults'] as int? ?? 0;

      LoggerHelper.info(
          'Fetched ${items.length} playlist items (total: $totalResults, hasMore: ${nextToken != null})');

      return YouTubeApiResponse(
        items: items,
        nextPageToken: nextToken,
        totalResults: totalResults,
      );
    } on DioException catch (e) {
      LoggerHelper.error('DioException fetching playlist items', e);
      throw _handleDioException(e);
    }
  }
}
