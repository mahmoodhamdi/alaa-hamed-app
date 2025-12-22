import 'dart:convert';
import 'package:eng_alaa_hammed/core/helpers/logger_helper.dart';
import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';
import 'package:eng_alaa_hammed/features/watch_history/domain/entities/watch_history_entry.dart';
import 'package:hive_flutter/hive_flutter.dart';

class WatchHistoryService {
  static const String _historyBoxName = 'watch_history';
  static const String _historyKey = 'history_entries';
  static const int _maxHistoryEntries = 100;

  Box<dynamic>? _box;

  Future<void> init() async {
    _box = await Hive.openBox(_historyBoxName);
    LoggerHelper.info('Watch history service initialized');
  }

  /// Add or update a video in watch history
  Future<void> addToHistory(
    Video video, {
    int lastPositionSeconds = 0,
    int durationSeconds = 0,
    bool isCompleted = false,
  }) async {
    try {
      final history = await getHistory();

      // Remove existing entry for this video if it exists
      history.removeWhere((e) => e.videoId == video.id);

      // Create new entry
      final entry = WatchHistoryEntry.fromVideo(
        video,
        lastPositionSeconds: lastPositionSeconds,
        durationSeconds: durationSeconds,
        isCompleted: isCompleted,
      );

      // Add to beginning of list (most recent first)
      history.insert(0, entry);

      // Trim to max entries
      if (history.length > _maxHistoryEntries) {
        history.removeRange(_maxHistoryEntries, history.length);
      }

      await _saveHistory(history);
      LoggerHelper.info('Added video ${video.id} to watch history');
    } catch (e) {
      LoggerHelper.error('Failed to add to watch history: $e');
    }
  }

  /// Update watch progress for a video
  Future<void> updateProgress(
    String videoId, {
    required int lastPositionSeconds,
    required int durationSeconds,
    bool? isCompleted,
  }) async {
    try {
      final history = await getHistory();
      final index = history.indexWhere((e) => e.videoId == videoId);

      if (index != -1) {
        final entry = history[index];
        final completed =
            isCompleted ?? (lastPositionSeconds >= durationSeconds * 0.9);

        history[index] = entry.copyWith(
          lastPositionSeconds: lastPositionSeconds,
          durationSeconds: durationSeconds,
          isCompleted: completed,
          watchedAt: DateTime.now(),
        );

        // Move to top of list
        final updatedEntry = history.removeAt(index);
        history.insert(0, updatedEntry);

        await _saveHistory(history);
        LoggerHelper.debug(
            'Updated progress for $videoId: $lastPositionSeconds/$durationSeconds');
      }
    } catch (e) {
      LoggerHelper.error('Failed to update watch progress: $e');
    }
  }

  /// Get the last position for a video
  Future<int?> getLastPosition(String videoId) async {
    try {
      final history = await getHistory();
      final entry = history.firstWhere(
        (e) => e.videoId == videoId,
        orElse: () => WatchHistoryEntry(
          videoId: '',
          title: '',
          thumbnailUrl: '',
          publishedAt: '',
          watchedAt: DateTime.now(),
        ),
      );
      return entry.videoId.isNotEmpty ? entry.lastPositionSeconds : null;
    } catch (e) {
      LoggerHelper.error('Failed to get last position: $e');
      return null;
    }
  }

  /// Get watch history entry for a video
  Future<WatchHistoryEntry?> getEntry(String videoId) async {
    try {
      final history = await getHistory();
      return history.firstWhere(
        (e) => e.videoId == videoId,
        orElse: () => WatchHistoryEntry(
          videoId: '',
          title: '',
          thumbnailUrl: '',
          publishedAt: '',
          watchedAt: DateTime.now(),
        ),
      );
    } catch (e) {
      LoggerHelper.error('Failed to get history entry: $e');
      return null;
    }
  }

  /// Get all watch history entries
  Future<List<WatchHistoryEntry>> getHistory() async {
    try {
      final jsonString = _box?.get(_historyKey) as String?;
      if (jsonString == null || jsonString.isEmpty) return [];

      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((json) => WatchHistoryEntry.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      LoggerHelper.error('Failed to get watch history: $e');
      return [];
    }
  }

  /// Remove a video from history
  Future<void> removeFromHistory(String videoId) async {
    try {
      final history = await getHistory();
      history.removeWhere((e) => e.videoId == videoId);
      await _saveHistory(history);
      LoggerHelper.info('Removed video $videoId from watch history');
    } catch (e) {
      LoggerHelper.error('Failed to remove from watch history: $e');
    }
  }

  /// Clear all watch history
  Future<void> clearHistory() async {
    try {
      await _box?.delete(_historyKey);
      LoggerHelper.info('Watch history cleared');
    } catch (e) {
      LoggerHelper.error('Failed to clear watch history: $e');
    }
  }

  /// Check if a video is in history
  Future<bool> isInHistory(String videoId) async {
    try {
      final history = await getHistory();
      return history.any((e) => e.videoId == videoId);
    } catch (e) {
      LoggerHelper.error('Failed to check history status: $e');
      return false;
    }
  }

  /// Get recently watched videos (completed or in progress)
  Future<List<WatchHistoryEntry>> getRecentlyWatched({int limit = 10}) async {
    try {
      final history = await getHistory();
      return history.take(limit).toList();
    } catch (e) {
      LoggerHelper.error('Failed to get recently watched: $e');
      return [];
    }
  }

  /// Get videos in progress (started but not completed)
  Future<List<WatchHistoryEntry>> getInProgress() async {
    try {
      final history = await getHistory();
      return history
          .where((e) => e.hasStarted && !e.isCompleted)
          .toList();
    } catch (e) {
      LoggerHelper.error('Failed to get in-progress videos: $e');
      return [];
    }
  }

  /// Get completed videos
  Future<List<WatchHistoryEntry>> getCompleted() async {
    try {
      final history = await getHistory();
      return history.where((e) => e.isCompleted).toList();
    } catch (e) {
      LoggerHelper.error('Failed to get completed videos: $e');
      return [];
    }
  }

  Future<void> _saveHistory(List<WatchHistoryEntry> history) async {
    final jsonList = history.map((e) => e.toJson()).toList();
    await _box?.put(_historyKey, jsonEncode(jsonList));
  }
}
