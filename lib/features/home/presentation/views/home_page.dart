import 'package:eng_alaa_hammed/core/constants/colors.dart';
import 'package:eng_alaa_hammed/core/constants/strings.dart';
import 'package:eng_alaa_hammed/core/dependency_injection/service_locator.dart';
import 'package:eng_alaa_hammed/core/enums/status.dart';
import 'package:eng_alaa_hammed/core/widgets/enhanced_video_card.dart';
import 'package:eng_alaa_hammed/features/favorites/presentation/logic/favorites_cubit.dart';
import 'package:eng_alaa_hammed/features/favorites/presentation/logic/favorites_state.dart';
import 'package:eng_alaa_hammed/features/playlists/domain/entities/playlist.dart';
import 'package:eng_alaa_hammed/features/playlists/presentation/logic/playlists_cubit.dart';
import 'package:eng_alaa_hammed/features/playlists/presentation/logic/playlists_state.dart';
import 'package:eng_alaa_hammed/features/playlists/presentation/views/playlist_videos_page.dart';
import 'package:eng_alaa_hammed/features/playlists/presentation/widgets/playlist_card.dart';
import 'package:eng_alaa_hammed/features/settings/presentation/views/settings_page.dart';
import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';
import 'package:eng_alaa_hammed/features/videos/presentation/logic/all_videos_cubit.dart';
import 'package:eng_alaa_hammed/features/videos/presentation/logic/all_videos_state.dart';
import 'package:eng_alaa_hammed/features/videos/presentation/views/video_player_page.dart';
import 'package:eng_alaa_hammed/features/watch_history/presentation/views/watch_history_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

enum VideoSortOption { newest, oldest, titleAZ, titleZA }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late final VideoCubit _videoCubit;
  late final PlaylistsCubit _playlistsCubit;
  late final FavoritesCubit _favoritesCubit;
  late final ScrollController _videosScrollController;
  late final ScrollController _playlistsScrollController;
  late final TextEditingController _searchController;

  bool _isSearching = false;
  String _searchQuery = '';
  VideoSortOption _sortOption = VideoSortOption.newest;

  @override
  void initState() {
    super.initState();
    _videoCubit = getIt<VideoCubit>()..fetchVideos();
    _playlistsCubit = getIt<PlaylistsCubit>()..fetchPlaylists();
    _favoritesCubit = getIt<FavoritesCubit>()..loadFavorites();
    _videosScrollController = ScrollController()..addListener(_onVideosScroll);
    _playlistsScrollController = ScrollController()
      ..addListener(_onPlaylistsScroll);
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _videoCubit.close();
    _playlistsCubit.close();
    _videosScrollController.dispose();
    _playlistsScrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onVideosScroll() {
    if (_isAtBottom(_videosScrollController)) {
      _videoCubit.loadMore();
    }
  }

  void _onPlaylistsScroll() {
    if (_isAtBottom(_playlistsScrollController)) {
      _playlistsCubit.loadMorePlaylists();
    }
  }

  bool _isAtBottom(ScrollController controller) {
    if (!controller.hasClients) return false;
    final maxScroll = controller.position.maxScrollExtent;
    final currentScroll = controller.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  List<Video> _filterAndSortVideos(List<Video> videos) {
    var filtered = videos.where((video) {
      if (_searchQuery.isEmpty) return true;
      return video.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (video.description.toLowerCase().contains(_searchQuery.toLowerCase()));
    }).toList();

    switch (_sortOption) {
      case VideoSortOption.newest:
        filtered.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
        break;
      case VideoSortOption.oldest:
        filtered.sort((a, b) => a.publishedAt.compareTo(b.publishedAt));
        break;
      case VideoSortOption.titleAZ:
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case VideoSortOption.titleZA:
        filtered.sort((a, b) => b.title.compareTo(a.title));
        break;
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _videoCubit),
        BlocProvider.value(value: _playlistsCubit),
        BlocProvider.value(value: _favoritesCubit),
      ],
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            _buildVideosTab(),
            _buildPlaylistsTab(),
            _buildFavoritesTab(),
            const WatchHistoryPage(),
          ],
        ),
        bottomNavigationBar: _buildBottomNavBar(context),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
            // Reset search when changing tabs
            if (index != 0) {
              _isSearching = false;
              _searchQuery = '';
              _searchController.clear();
            }
          });
        },
        backgroundColor: theme.colorScheme.surface,
        indicatorColor: theme.colorScheme.primaryContainer,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.video_library_outlined),
            selectedIcon: const Icon(Icons.video_library),
            label: AppStrings.allVideos,
          ),
          NavigationDestination(
            icon: const Icon(Icons.playlist_play_outlined),
            selectedIcon: const Icon(Icons.playlist_play),
            label: AppStrings.playlists,
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_outline),
            selectedIcon: const Icon(Icons.favorite),
            label: AppStrings.favorites,
          ),
          NavigationDestination(
            icon: const Icon(Icons.history_outlined),
            selectedIcon: const Icon(Icons.history),
            label: AppStrings.watchHistory,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);

    if (_isSearching && _currentIndex == 0) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _isSearching = false;
              _searchQuery = '';
              _searchController.clear();
            });
          },
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: AppStrings.searchVideos,
            border: InputBorder.none,
            hintStyle: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          style: theme.textTheme.bodyLarge,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _searchQuery = '';
                });
              },
            ),
        ],
      );
    }

    return AppBar(
      title: Text(
        AppStrings.appName,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      actions: [
        // Search button (only on videos tab)
        if (_currentIndex == 0)
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: AppStrings.search,
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            },
          ),
        // Sort button (only on videos tab)
        if (_currentIndex == 0)
          PopupMenuButton<VideoSortOption>(
            icon: const Icon(Icons.sort),
            tooltip: AppStrings.sort,
            onSelected: (option) {
              setState(() {
                _sortOption = option;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: VideoSortOption.newest,
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_downward,
                      size: 18,
                      color: _sortOption == VideoSortOption.newest
                          ? theme.colorScheme.primary
                          : null,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      AppStrings.sortNewest,
                      style: TextStyle(
                        color: _sortOption == VideoSortOption.newest
                            ? theme.colorScheme.primary
                            : null,
                        fontWeight: _sortOption == VideoSortOption.newest
                            ? FontWeight.bold
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: VideoSortOption.oldest,
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      size: 18,
                      color: _sortOption == VideoSortOption.oldest
                          ? theme.colorScheme.primary
                          : null,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      AppStrings.sortOldest,
                      style: TextStyle(
                        color: _sortOption == VideoSortOption.oldest
                            ? theme.colorScheme.primary
                            : null,
                        fontWeight: _sortOption == VideoSortOption.oldest
                            ? FontWeight.bold
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: VideoSortOption.titleAZ,
                child: Row(
                  children: [
                    Icon(
                      Icons.sort_by_alpha,
                      size: 18,
                      color: _sortOption == VideoSortOption.titleAZ
                          ? theme.colorScheme.primary
                          : null,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      AppStrings.sortTitleAZ,
                      style: TextStyle(
                        color: _sortOption == VideoSortOption.titleAZ
                            ? theme.colorScheme.primary
                            : null,
                        fontWeight: _sortOption == VideoSortOption.titleAZ
                            ? FontWeight.bold
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: VideoSortOption.titleZA,
                child: Row(
                  children: [
                    Icon(
                      Icons.sort_by_alpha,
                      size: 18,
                      color: _sortOption == VideoSortOption.titleZA
                          ? theme.colorScheme.primary
                          : null,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      AppStrings.sortTitleZA,
                      style: TextStyle(
                        color: _sortOption == VideoSortOption.titleZA
                            ? theme.colorScheme.primary
                            : null,
                        fontWeight: _sortOption == VideoSortOption.titleZA
                            ? FontWeight.bold
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          tooltip: AppStrings.settings,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildVideosTab() {
    return BlocBuilder<VideoCubit, AllVideosState>(
      builder: (context, state) {
        if (state.status == AllVideosStatus.loading) {
          return _buildShimmerLoading(context);
        }

        if (state.status == AllVideosStatus.failure) {
          return _buildErrorState(
            context,
            state.errorMessage,
            () => _videoCubit.fetchVideos(),
          );
        }

        if (state.status == AllVideosStatus.loaded) {
          final filteredVideos = _filterAndSortVideos(state.videos);

          if (filteredVideos.isEmpty && _searchQuery.isNotEmpty) {
            return _buildEmptyState(
              context,
              AppStrings.noSearchResults,
              AppStrings.noSearchResultsDescription,
              Icons.search_off,
            );
          }

          if (state.videos.isEmpty) {
            return _buildEmptyState(
              context,
              AppStrings.noVideosAvailable,
              AppStrings.checkBackLater,
              Icons.video_library,
            );
          }

          return _buildVideoList(context, state, filteredVideos);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildPlaylistsTab() {
    return BlocBuilder<PlaylistsCubit, PlaylistsState>(
      builder: (context, state) {
        if (state.status == PlaylistsStatus.loading) {
          return _buildShimmerLoading(context);
        }

        if (state.status == PlaylistsStatus.error) {
          return _buildErrorState(
            context,
            state.errorMessage ?? '',
            () => _playlistsCubit.fetchPlaylists(),
          );
        }

        if (state.status == PlaylistsStatus.loaded ||
            state.status == PlaylistsStatus.loadingMore) {
          return state.playlists.isEmpty
              ? _buildEmptyState(
                  context,
                  AppStrings.noPlaylistsAvailable,
                  AppStrings.checkBackLater,
                  Icons.playlist_play,
                )
              : _buildPlaylistList(context, state);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildFavoritesTab() {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        if (state.status == FavoritesStatus.loading) {
          return _buildShimmerLoading(context);
        }

        if (state.status == FavoritesStatus.failure) {
          return _buildErrorState(
            context,
            state.errorMessage,
            () => _favoritesCubit.loadFavorites(),
          );
        }

        if (state.favorites.isEmpty) {
          return _buildEmptyState(
            context,
            AppStrings.noFavorites,
            AppStrings.noFavoritesDescription,
            Icons.favorite_border,
          );
        }

        return _buildFavoritesList(context, state);
      },
    );
  }

  Widget _buildFavoritesList(BuildContext context, FavoritesState state) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: state.favorites.length,
      itemBuilder: (context, index) {
        return _buildFavoriteVideoCard(context, state.favorites[index]);
      },
    );
  }

  Widget _buildFavoriteVideoCard(BuildContext context, Video video) {
    return EnhancedVideoCard(
      video: video,
      isDismissible: true,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerPage(video: video),
          ),
        );
      },
      onDismissed: () {
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
    );
  }

  Widget _buildShimmerLoading(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBase,
      highlightColor:
          isDark ? AppColors.shimmerHighlightDark : AppColors.shimmerHighlight,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: 4,
        itemBuilder: (context, index) => _buildShimmerCard(context),
      ),
    );
  }

  Widget _buildShimmerCard(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 16,
                  width: MediaQuery.of(context).size.width * 0.6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 14,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    String errorMessage,
    VoidCallback onRetry,
  ) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                color: AppColors.error,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppStrings.failedToLoadVideos,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(AppStrings.retry),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primaryContainer,
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 56,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoList(BuildContext context, AllVideosState state, List<Video> filteredVideos) {
    return RefreshIndicator(
      onRefresh: () => _videoCubit.refreshVideos(),
      child: Column(
        children: [
          // Search results count
          if (_searchQuery.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
              child: Text(
                '${filteredVideos.length} ${AppStrings.searchResultsCount}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          Expanded(
            child: ListView.builder(
              controller: _videosScrollController,
              padding: const EdgeInsets.all(8),
              itemCount: filteredVideos.length + (state.hasMore && _searchQuery.isEmpty ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= filteredVideos.length) {
                  return _buildLoadingMoreIndicator();
                }
                return _buildVideoCard(context, filteredVideos[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistList(BuildContext context, PlaylistsState state) {
    return RefreshIndicator(
      onRefresh: () => _playlistsCubit.refresh(),
      child: ListView.builder(
        controller: _playlistsScrollController,
        padding: const EdgeInsets.all(8),
        itemCount: state.playlists.length + (state.hasReachedEnd ? 0 : 1),
        itemBuilder: (context, index) {
          if (index >= state.playlists.length) {
            return _buildLoadingMoreIndicator();
          }
          return PlaylistCard(
            playlist: state.playlists[index],
            onTap: () => _navigateToPlaylistVideos(state.playlists[index]),
          );
        },
      ),
    );
  }

  void _navigateToPlaylistVideos(Playlist playlist) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaylistVideosPage(playlist: playlist),
      ),
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(child: CircularProgressIndicator.adaptive()),
    );
  }

  Widget _buildVideoCard(BuildContext context, Video video) {
    return EnhancedVideoCard(
      video: video,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerPage(video: video),
          ),
        );
      },
    );
  }
}
