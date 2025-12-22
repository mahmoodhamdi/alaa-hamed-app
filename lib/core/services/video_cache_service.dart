import 'dart:convert';
import 'package:eng_alaa_hammed/core/helpers/logger_helper.dart';
import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';
import 'package:hive_flutter/hive_flutter.dart';

class VideoCacheService {
  static const String _videosBoxName = 'videos_cache';
  static const String _videosKey = 'cached_videos';
  static const String _lastFetchKey = 'last_fetch_time';
  static const Duration _cacheValidity = Duration(hours: 1);

  Box<dynamic>? _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_videosBoxName);
    LoggerHelper.info('Video cache initialized');
  }

  Future<void> cacheVideos(List<Video> videos) async {
    try {
      final jsonList = videos.map((v) => _videoToJson(v)).toList();
      await _box?.put(_videosKey, jsonEncode(jsonList));
      await _box?.put(_lastFetchKey, DateTime.now().toIso8601String());
      LoggerHelper.info('Cached ${videos.length} videos');
    } catch (e) {
      LoggerHelper.error('Failed to cache videos: $e');
    }
  }

  Future<List<Video>?> getCachedVideos() async {
    try {
      final jsonString = _box?.get(_videosKey) as String?;
      if (jsonString == null) return null;

      final jsonList = jsonDecode(jsonString) as List;
      final videos = jsonList.map((json) => _videoFromJson(json)).toList();
      LoggerHelper.info('Retrieved ${videos.length} cached videos');
      return videos;
    } catch (e) {
      LoggerHelper.error('Failed to get cached videos: $e');
      return null;
    }
  }

  bool isCacheValid() {
    try {
      final lastFetchString = _box?.get(_lastFetchKey) as String?;
      if (lastFetchString == null) return false;

      final lastFetch = DateTime.parse(lastFetchString);
      final isValid = DateTime.now().difference(lastFetch) < _cacheValidity;
      LoggerHelper.debug('Cache validity: $isValid');
      return isValid;
    } catch (e) {
      LoggerHelper.error('Error checking cache validity: $e');
      return false;
    }
  }

  Future<void> clearCache() async {
    try {
      await _box?.delete(_videosKey);
      await _box?.delete(_lastFetchKey);
      LoggerHelper.info('Video cache cleared');
    } catch (e) {
      LoggerHelper.error('Failed to clear cache: $e');
    }
  }

  Map<String, dynamic> _videoToJson(Video video) {
    return {
      'id': video.id,
      'title': video.title,
      'thumbnailUrl': video.thumbnailUrl,
      'publishedAt': video.publishedAt,
      'description': video.description,
      'videoUrl': video.videoUrl,
    };
  }

  Video _videoFromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'] as String,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      publishedAt: json['publishedAt'] as String,
      description: json['description'] as String,
      videoUrl: json['videoUrl'] as String,
    );
  }
}
