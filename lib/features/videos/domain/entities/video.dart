import 'package:equatable/equatable.dart';

class Video extends Equatable {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String publishedAt;
  final String description;
  final String videoUrl;

  const Video({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.publishedAt,
    required this.description,
    required this.videoUrl,
  });

  @override
  List<Object> get props =>
      [id, title, thumbnailUrl, publishedAt, description, videoUrl];
}
