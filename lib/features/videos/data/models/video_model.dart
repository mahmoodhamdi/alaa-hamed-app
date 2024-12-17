
import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';

class VideoModel extends Video {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String publishedAt;
  
 const VideoModel({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.publishedAt,
  }) : super(
            id: id,
            title: title,
            thumbnailUrl: thumbnailUrl,
            publishedAt: publishedAt);

  // تحويل الـ JSON إلى VideoModel
  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id']['videoId'],
      title: json['snippet']['title'],
      thumbnailUrl: json['snippet']['thumbnails']['high']['url'],
      publishedAt: json['snippet']['publishedAt'],
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
