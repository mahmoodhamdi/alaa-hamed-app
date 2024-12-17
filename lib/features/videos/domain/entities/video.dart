import 'package:equatable/equatable.dart';

class Video extends Equatable {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String publishedAt;

  const Video({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.publishedAt,
  });

  @override
  List<Object> get props => [id, title, thumbnailUrl, publishedAt];
}
