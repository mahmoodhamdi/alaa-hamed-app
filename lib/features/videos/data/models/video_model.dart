import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';

class VideoModel extends Video {
  @override
  final String id;
  @override
  final String title;
  @override
  final String thumbnailUrl;
  @override
  final String publishedAt;
  @override
  final String description;
  @override
  final String videoUrl;

  const VideoModel(
      {required this.id,
      required this.title,
      required this.thumbnailUrl,
      required this.publishedAt,
      required this.description,
      required this.videoUrl})
      : super(
            id: id,
            title: title,
            thumbnailUrl: thumbnailUrl,
            publishedAt: publishedAt,
            description: description,
            videoUrl: videoUrl);

  // تحويل الـ JSON إلى VideoModel
  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id']['videoId'],
      title: json['snippet']['title'],
      thumbnailUrl: json['snippet']['thumbnails']['high']['url'],
      publishedAt: json['snippet']['publishedAt'],
      description: json['snippet']['description'],
      videoUrl: json['snippet']['thumbnails']['high']['url'],
    );
  }

  // تحويل الـ VideoModel إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': {'videoId': id},
      'snippet': {
        'title': title,
        'thumbnails': {
          'high': {'url': thumbnailUrl}
        },
        'publishedAt': publishedAt,
      }
    };
  }
}
