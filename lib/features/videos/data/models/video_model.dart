import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';

class VideoModel extends Video {
  const VideoModel({
    required super.id,
    required super.title,
    required super.thumbnailUrl,
    required super.publishedAt,
    required super.description,
    required super.videoUrl,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    final videoId = json['id']['videoId'] as String;
    return VideoModel(
      id: videoId,
      title: json['snippet']['title'] as String,
      thumbnailUrl: json['snippet']['thumbnails']['high']['url'] as String,
      publishedAt: json['snippet']['publishedAt'] as String,
      description: json['snippet']['description'] as String,
      videoUrl: 'https://www.youtube.com/watch?v=$videoId',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': {'videoId': id},
      'snippet': {
        'title': title,
        'description': description,
        'thumbnails': {
          'high': {'url': thumbnailUrl}
        },
        'publishedAt': publishedAt,
      },
      'videoUrl': videoUrl,
    };
  }
}
