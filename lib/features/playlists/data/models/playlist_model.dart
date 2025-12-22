import 'package:eng_alaa_hammed/features/playlists/domain/entities/playlist.dart';

class PlaylistModel extends Playlist {
  const PlaylistModel({
    required super.id,
    required super.title,
    required super.description,
    required super.thumbnailUrl,
    required super.itemCount,
    required super.publishedAt,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'] as Map<String, dynamic>;
    final contentDetails = json['contentDetails'] as Map<String, dynamic>?;
    final thumbnails = snippet['thumbnails'] as Map<String, dynamic>;

    // Get the best available thumbnail
    String thumbnailUrl = '';
    if (thumbnails['high'] != null) {
      thumbnailUrl = thumbnails['high']['url'] as String;
    } else if (thumbnails['medium'] != null) {
      thumbnailUrl = thumbnails['medium']['url'] as String;
    } else if (thumbnails['default'] != null) {
      thumbnailUrl = thumbnails['default']['url'] as String;
    }

    return PlaylistModel(
      id: json['id'] as String,
      title: snippet['title'] as String? ?? '',
      description: snippet['description'] as String? ?? '',
      thumbnailUrl: thumbnailUrl,
      itemCount: contentDetails?['itemCount'] as int? ?? 0,
      publishedAt: snippet['publishedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'snippet': {
        'title': title,
        'description': description,
        'thumbnails': {
          'high': {'url': thumbnailUrl}
        },
        'publishedAt': publishedAt,
      },
      'contentDetails': {
        'itemCount': itemCount,
      },
    };
  }
}
