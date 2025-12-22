import 'package:cached_network_image/cached_network_image.dart';
import 'package:eng_alaa_hammed/core/constants/strings.dart';
import 'package:eng_alaa_hammed/core/dependency_injection/service_locator.dart';
import 'package:eng_alaa_hammed/core/enums/status.dart';
import 'package:eng_alaa_hammed/core/formatters/formatter.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final VideoCubit _videoCubit;
  late final PlaylistsCubit _playlistsCubit;
  late final ScrollController _videosScrollController;
  late final ScrollController _playlistsScrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _videoCubit = getIt<VideoCubit>()..fetchVideos();
    _playlistsCubit = getIt<PlaylistsCubit>()..fetchPlaylists();
    _videosScrollController = ScrollController()..addListener(_onVideosScroll);
    _playlistsScrollController = ScrollController()
      ..addListener(_onPlaylistsScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _videoCubit.close();
    _playlistsCubit.close();
    _videosScrollController.dispose();
    _playlistsScrollController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _videoCubit),
        BlocProvider.value(value: _playlistsCubit),
      ],
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildVideosTab(),
            _buildPlaylistsTab(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        AppStrings.appName,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      centerTitle: true,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          tooltip: AppStrings.settings,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          },
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            icon: const Icon(Icons.video_library),
            text: AppStrings.allVideos,
          ),
          Tab(
            icon: const Icon(Icons.playlist_play),
            text: AppStrings.playlists,
          ),
        ],
      ),
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
          return state.videos.isEmpty
              ? _buildEmptyState(
                  context,
                  AppStrings.noVideosAvailable,
                  AppStrings.checkBackLater,
                  Icons.video_library,
                )
              : _buildVideoList(context, state);
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

  Widget _buildShimmerLoading(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: 6,
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

  Widget _buildErrorState(
    BuildContext context,
    String errorMessage,
    VoidCallback onRetry,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 60),
          const SizedBox(height: 16),
          Text(
            AppStrings.failedToLoadVideos,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            errorMessage,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text(AppStrings.retry),
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Theme.of(context).primaryColor.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildVideoList(BuildContext context, AllVideosState state) {
    return RefreshIndicator(
      onRefresh: () => _videoCubit.refreshVideos(),
      child: ListView.builder(
        controller: _videosScrollController,
        padding: const EdgeInsets.all(8),
        itemCount: state.videos.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.videos.length) {
            return _buildLoadingMoreIndicator();
          }
          return _buildVideoCard(context, state.videos[index]);
        },
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
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerPage(
                videoId: video.id,
                title: video.title,
                publishedAt: video.publishedAt,
                description: video.description,
              ),
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
    );
  }
}
