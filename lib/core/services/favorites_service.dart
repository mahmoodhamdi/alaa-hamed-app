import 'dart:convert';
import 'package:eng_alaa_hammed/core/helpers/logger_helper.dart';
import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoritesService {
  static const String _favoritesBoxName = 'favorites';
  static const String _favoritesKey = 'favorite_videos';

  Box<dynamic>? _box;

  Future<void> init() async {
    _box = await Hive.openBox(_favoritesBoxName);
    LoggerHelper.info('Favorites service initialized');
  }

  Future<void> addToFavorites(Video video) async {
    try {
      final favorites = await getFavorites();
      if (!favorites.any((v) => v.id == video.id)) {
        favorites.add(video);
        await _saveFavorites(favorites);
        LoggerHelper.info('Added video ${video.id} to favorites');
      }
    } catch (e) {
      LoggerHelper.error('Failed to add to favorites: $e');
    }
  }

  Future<void> removeFromFavorites(String videoId) async {
    try {
      final favorites = await getFavorites();
      favorites.removeWhere((v) => v.id == videoId);
      await _saveFavorites(favorites);
      LoggerHelper.info('Removed video $videoId from favorites');
    } catch (e) {
      LoggerHelper.error('Failed to remove from favorites: $e');
    }
  }

  Future<bool> isFavorite(String videoId) async {
    try {
      final favorites = await getFavorites();
      return favorites.any((v) => v.id == videoId);
    } catch (e) {
      LoggerHelper.error('Failed to check favorite status: $e');
      return false;
    }
  }

  Future<List<Video>> getFavorites() async {
    try {
      final jsonString = _box?.get(_favoritesKey) as String?;
      if (jsonString == null || jsonString.isEmpty) return [];

      final jsonList = jsonDecode(jsonString) as List;
      return jsonList.map((json) => _videoFromJson(json)).toList();
    } catch (e) {
      LoggerHelper.error('Failed to get favorites: $e');
      return [];
    }
  }

  Future<void> _saveFavorites(List<Video> favorites) async {
    final jsonList = favorites.map((v) => _videoToJson(v)).toList();
    await _box?.put(_favoritesKey, jsonEncode(jsonList));
  }

  Future<void> clearFavorites() async {
    try {
      await _box?.delete(_favoritesKey);
      LoggerHelper.info('Favorites cleared');
    } catch (e) {
      LoggerHelper.error('Failed to clear favorites: $e');
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
