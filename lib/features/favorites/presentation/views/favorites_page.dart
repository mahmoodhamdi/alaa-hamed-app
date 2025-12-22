import 'package:cached_network_image/cached_network_image.dart';
import 'package:eng_alaa_hammed/core/constants/strings.dart';
import 'package:eng_alaa_hammed/core/dependency_injection/service_locator.dart';
import 'package:eng_alaa_hammed/core/formatters/formatter.dart';
import 'package:eng_alaa_hammed/features/favorites/presentation/logic/favorites_cubit.dart';
import 'package:eng_alaa_hammed/features/favorites/presentation/logic/favorites_state.dart';
import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';
import 'package:eng_alaa_hammed/features/videos/presentation/views/video_player_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late final FavoritesCubit _favoritesCubit;

  @override
  void initState() {
    super.initState();
    _favoritesCubit = getIt<FavoritesCubit>()..loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.favorites,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<FavoritesCubit, FavoritesState>(
            bloc: _favoritesCubit,
            builder: (context, state) {
              if (state.favorites.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_sweep),
                tooltip: 'Clear all favorites',
                onPressed: () => _showClearConfirmation(context),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        bloc: _favoritesCubit,
        builder: (context, state) {
          if (state.status == FavoritesStatus.loading) {
            return _buildShimmerLoading(context);
          }

          if (state.status == FavoritesStatus.failure) {
            return _buildErrorState(context, state);
          }

          if (state.favorites.isEmpty) {
            return _buildEmptyState(context);
          }

          return _buildFavoritesList(context, state);
        },
      ),
    );
  }

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Favorites'),
        content: const Text('Are you sure you want to clear all favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              _favoritesCubit.clearAllFavorites();
              Navigator.pop(ctx);
            },
            child: Text(
              AppStrings.confirm,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: 4,
        itemBuilder: (context, index) => _buildShimmerCard(),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 16, width: double.infinity, color: Colors.white),
                const SizedBox(height: 8),
                Container(height: 16, width: 150, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, FavoritesState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 60),
          const SizedBox(height: 16),
          Text(
            'Failed to load favorites',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            state.errorMessage,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _favoritesCubit.loadFavorites(),
            child: const Text(AppStrings.retry),
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Theme.of(context).primaryColor.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.noFavorites,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.noFavoritesDescription,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(BuildContext context, FavoritesState state) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: state.favorites.length,
      itemBuilder: (context, index) {
        return _buildVideoCard(context, state.favorites[index]);
      },
    );
  }

  Widget _buildVideoCard(BuildContext context, Video video) {
    return Dismissible(
      key: Key(video.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        _favoritesCubit.removeFavorite(video.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.removedFromFavorites),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () => _favoritesCubit.addFavorite(video),
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoPlayerPage(video: video),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: video.thumbnailUrl,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                      memCacheWidth: 720,
                      memCacheHeight: 360,
                      fadeInDuration: const Duration(milliseconds: 200),
                      placeholder: (context, url) => Container(
                        height: 180,
                        color: Colors.grey[300],
                        child: const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 180,
                        color: Colors.grey[300],
                        child: const Icon(Icons.error, size: 40),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          TFormatter.formatDate(video.publishedAt),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
