import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';
import 'package:equatable/equatable.dart';

class WatchHistoryEntry extends Equatable {
  final String videoId;
  final String title;
  final String thumbnailUrl;
  final String publishedAt;
  final String description;
  final String videoUrl;
  final DateTime watchedAt;
  final int lastPositionSeconds;
  final int durationSeconds;
  final bool isCompleted;

  const WatchHistoryEntry({
    required this.videoId,
    required this.title,
    required this.thumbnailUrl,
    required this.publishedAt,
    this.description = '',
    this.videoUrl = '',
    required this.watchedAt,
    this.lastPositionSeconds = 0,
    this.durationSeconds = 0,
    this.isCompleted = false,
  });

  /// Create from Video entity
  factory WatchHistoryEntry.fromVideo(
    Video video, {
    int lastPositionSeconds = 0,
    int durationSeconds = 0,
    bool isCompleted = false,
  }) {
    return WatchHistoryEntry(
      videoId: video.id,
      title: video.title,
      thumbnailUrl: video.thumbnailUrl,
      publishedAt: video.publishedAt,
      description: video.description,
      videoUrl: video.videoUrl,
      watchedAt: DateTime.now(),
      lastPositionSeconds: lastPositionSeconds,
      durationSeconds: durationSeconds,
      isCompleted: isCompleted,
    );
  }

  /// Create from JSON
  factory WatchHistoryEntry.fromJson(Map<String, dynamic> json) {
    return WatchHistoryEntry(
      videoId: json['videoId'] as String,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      publishedAt: json['publishedAt'] as String,
      description: json['description'] as String? ?? '',
      videoUrl: json['videoUrl'] as String? ?? '',
      watchedAt: DateTime.parse(json['watchedAt'] as String),
      lastPositionSeconds: json['lastPositionSeconds'] as int? ?? 0,
      durationSeconds: json['durationSeconds'] as int? ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'publishedAt': publishedAt,
      'description': description,
      'videoUrl': videoUrl,
      'watchedAt': watchedAt.toIso8601String(),
      'lastPositionSeconds': lastPositionSeconds,
      'durationSeconds': durationSeconds,
      'isCompleted': isCompleted,
    };
  }

  /// Convert to Video entity
  Video toVideo() {
    return Video(
      id: videoId,
      title: title,
      thumbnailUrl: thumbnailUrl,
      publishedAt: publishedAt,
      description: description,
      videoUrl: videoUrl,
    );
  }

  /// Get watch progress as percentage (0.0 to 1.0)
  double get watchProgress {
    if (durationSeconds <= 0) return 0.0;
    return (lastPositionSeconds / durationSeconds).clamp(0.0, 1.0);
  }

  /// Get watch progress as percentage string
  String get watchProgressPercent {
    return '${(watchProgress * 100).toInt()}%';
  }

  /// Check if video has been started
  bool get hasStarted => lastPositionSeconds > 0;

  /// Get remaining time in seconds
  int get remainingSeconds {
    if (durationSeconds <= 0) return 0;
    return (durationSeconds - lastPositionSeconds).clamp(0, durationSeconds);
  }

  /// Format duration as mm:ss or hh:mm:ss
  String formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  /// Get formatted last position
  String get formattedLastPosition => formatDuration(lastPositionSeconds);

  /// Get formatted duration
  String get formattedDuration => formatDuration(durationSeconds);

  /// Get formatted remaining time
  String get formattedRemaining => formatDuration(remainingSeconds);

  /// Create a copy with updated values
  WatchHistoryEntry copyWith({
    String? videoId,
    String? title,
    String? thumbnailUrl,
    String? publishedAt,
    String? description,
    String? videoUrl,
    DateTime? watchedAt,
    int? lastPositionSeconds,
    int? durationSeconds,
    bool? isCompleted,
  }) {
    return WatchHistoryEntry(
      videoId: videoId ?? this.videoId,
      title: title ?? this.title,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
      watchedAt: watchedAt ?? this.watchedAt,
      lastPositionSeconds: lastPositionSeconds ?? this.lastPositionSeconds,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object> get props => [
        videoId,
        title,
        thumbnailUrl,
        publishedAt,
        description,
        videoUrl,
        watchedAt,
        lastPositionSeconds,
        durationSeconds,
        isCompleted,
      ];
}
