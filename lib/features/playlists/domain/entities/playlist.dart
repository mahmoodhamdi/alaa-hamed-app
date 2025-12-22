import 'package:equatable/equatable.dart';

class Playlist extends Equatable {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final int itemCount;
  final String publishedAt;

  const Playlist({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.itemCount,
    required this.publishedAt,
  });

  @override
  List<Object> get props =>
      [id, title, description, thumbnailUrl, itemCount, publishedAt];
}
