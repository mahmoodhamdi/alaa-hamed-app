import 'package:eng_alaa_hammed/core/helpers/logger_helper.dart';
import 'package:eng_alaa_hammed/core/services/watch_history_service.dart';
import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';
import 'package:eng_alaa_hammed/features/watch_history/domain/entities/watch_history_entry.dart';
import 'package:eng_alaa_hammed/features/watch_history/presentation/logic/watch_history_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchHistoryCubit extends Cubit<WatchHistoryState> {
  final WatchHistoryService _watchHistoryService;

  WatchHistoryCubit(this._watchHistoryService)
      : super(const WatchHistoryState());

  /// Load watch history
  Future<void> loadHistory() async {
    try {
      emit(state.copyWith(status: WatchHistoryStatus.loading));

      final history = await _watchHistoryService.getHistory();
      final inProgress = await _watchHistoryService.getInProgress();

      emit(state.copyWith(
        status: WatchHistoryStatus.loaded,
        history: history,
        inProgress: inProgress,
      ));

      LoggerHelper.info('Loaded ${history.length} watch history entries');
    } catch (e) {
      LoggerHelper.error('Failed to load watch history: $e');
      emit(state.copyWith(
        status: WatchHistoryStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Add video to history when starting to watch
  Future<void> addToHistory(
    Video video, {
    int lastPositionSeconds = 0,
    int durationSeconds = 0,
    bool isCompleted = false,
  }) async {
    try {
      await _watchHistoryService.addToHistory(
        video,
        lastPositionSeconds: lastPositionSeconds,
        durationSeconds: durationSeconds,
        isCompleted: isCompleted,
      );

      // Reload history
      await loadHistory();
    } catch (e) {
      LoggerHelper.error('Failed to add to history: $e');
    }
  }

  /// Update watch progress
  Future<void> updateProgress(
    String videoId, {
    required int lastPositionSeconds,
    required int durationSeconds,
    bool? isCompleted,
  }) async {
    try {
      await _watchHistoryService.updateProgress(
        videoId,
        lastPositionSeconds: lastPositionSeconds,
        durationSeconds: durationSeconds,
        isCompleted: isCompleted,
      );

      // Update state without full reload for performance
      final history = List<WatchHistoryEntry>.from(state.history);
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

        // Move to top
        final updatedEntry = history.removeAt(index);
        history.insert(0, updatedEntry);

        final inProgress = history
            .where((e) => e.hasStarted && !e.isCompleted)
            .toList();

        emit(state.copyWith(
          history: history,
          inProgress: inProgress,
        ));
      }
    } catch (e) {
      LoggerHelper.error('Failed to update progress: $e');
    }
  }

  /// Remove video from history
  Future<void> removeFromHistory(String videoId) async {
    try {
      await _watchHistoryService.removeFromHistory(videoId);

      // Update state
      final history = List<WatchHistoryEntry>.from(state.history)
        ..removeWhere((e) => e.videoId == videoId);

      final inProgress = history
          .where((e) => e.hasStarted && !e.isCompleted)
          .toList();

      emit(state.copyWith(
        history: history,
        inProgress: inProgress,
      ));
    } catch (e) {
      LoggerHelper.error('Failed to remove from history: $e');
    }
  }

  /// Clear all watch history
  Future<void> clearHistory() async {
    try {
      await _watchHistoryService.clearHistory();

      emit(state.copyWith(
        history: [],
        inProgress: [],
      ));

      LoggerHelper.info('Watch history cleared');
    } catch (e) {
      LoggerHelper.error('Failed to clear history: $e');
    }
  }

  /// Get last position for a video
  int? getLastPosition(String videoId) {
    return state.getLastPosition(videoId);
  }

  /// Check if video is in history
  bool isInHistory(String videoId) {
    return state.isInHistory(videoId);
  }

  /// Get entry for a video
  WatchHistoryEntry? getEntry(String videoId) {
    return state.getEntry(videoId);
  }
}
