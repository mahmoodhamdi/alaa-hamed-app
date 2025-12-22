import 'package:eng_alaa_hammed/features/watch_history/domain/entities/watch_history_entry.dart';
import 'package:equatable/equatable.dart';

enum WatchHistoryStatus { initial, loading, loaded, failure }

class WatchHistoryState extends Equatable {
  final WatchHistoryStatus status;
  final List<WatchHistoryEntry> history;
  final List<WatchHistoryEntry> inProgress;
  final String errorMessage;

  const WatchHistoryState({
    this.status = WatchHistoryStatus.initial,
    this.history = const [],
    this.inProgress = const [],
    this.errorMessage = '',
  });

  /// Check if a video is in history
  bool isInHistory(String videoId) {
    return history.any((e) => e.videoId == videoId);
  }

  /// Get entry for a specific video
  WatchHistoryEntry? getEntry(String videoId) {
    try {
      return history.firstWhere((e) => e.videoId == videoId);
    } catch (_) {
      return null;
    }
  }

  /// Get last position for a video
  int? getLastPosition(String videoId) {
    final entry = getEntry(videoId);
    return entry?.lastPositionSeconds;
  }

  WatchHistoryState copyWith({
    WatchHistoryStatus? status,
    List<WatchHistoryEntry>? history,
    List<WatchHistoryEntry>? inProgress,
    String? errorMessage,
  }) {
    return WatchHistoryState(
      status: status ?? this.status,
      history: history ?? this.history,
      inProgress: inProgress ?? this.inProgress,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, history, inProgress, errorMessage];
}
