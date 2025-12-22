import 'package:eng_alaa_hammed/core/services/favorites_service.dart';
import 'package:eng_alaa_hammed/features/favorites/presentation/logic/favorites_state.dart';
import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesService favoritesService;

  FavoritesCubit(this.favoritesService) : super(const FavoritesState());

  Future<void> loadFavorites() async {
    emit(state.copyWith(status: FavoritesStatus.loading));
    try {
      final favorites = await favoritesService.getFavorites();
      final favoriteIds = favorites.map((v) => v.id).toSet();
      emit(state.copyWith(
        status: FavoritesStatus.loaded,
        favorites: favorites,
        favoriteIds: favoriteIds,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FavoritesStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> toggleFavorite(Video video) async {
    final isFavorite = state.isFavorite(video.id);
    if (isFavorite) {
      await removeFavorite(video.id);
    } else {
      await addFavorite(video);
    }
  }

  Future<void> addFavorite(Video video) async {
    try {
      await favoritesService.addToFavorites(video);
      final updatedFavorites = [...state.favorites, video];
      final updatedIds = {...state.favoriteIds, video.id};
      emit(state.copyWith(
        favorites: updatedFavorites,
        favoriteIds: updatedIds,
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> removeFavorite(String videoId) async {
    try {
      await favoritesService.removeFromFavorites(videoId);
      final updatedFavorites =
          state.favorites.where((v) => v.id != videoId).toList();
      final updatedIds = state.favoriteIds.where((id) => id != videoId).toSet();
      emit(state.copyWith(
        favorites: updatedFavorites,
        favoriteIds: updatedIds,
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> clearAllFavorites() async {
    try {
      await favoritesService.clearFavorites();
      emit(state.copyWith(
        favorites: [],
        favoriteIds: {},
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
