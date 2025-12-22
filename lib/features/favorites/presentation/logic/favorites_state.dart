import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';
import 'package:equatable/equatable.dart';

enum FavoritesStatus { initial, loading, loaded, failure }

class FavoritesState extends Equatable {
  final FavoritesStatus status;
  final List<Video> favorites;
  final String errorMessage;
  final Set<String> favoriteIds;

  const FavoritesState({
    this.status = FavoritesStatus.initial,
    this.favorites = const [],
    this.errorMessage = '',
    this.favoriteIds = const {},
  });

  bool isFavorite(String videoId) => favoriteIds.contains(videoId);

  FavoritesState copyWith({
    FavoritesStatus? status,
    List<Video>? favorites,
    String? errorMessage,
    Set<String>? favoriteIds,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      favorites: favorites ?? this.favorites,
      errorMessage: errorMessage ?? this.errorMessage,
      favoriteIds: favoriteIds ?? this.favoriteIds,
    );
  }

  @override
  List<Object> get props => [status, favorites, errorMessage, favoriteIds];
}
