import 'package:cached_network_image/cached_network_image.dart';
import 'package:eng_alaa_hammed/core/constants/strings.dart';
import 'package:eng_alaa_hammed/core/dependency_injection/service_locator.dart';
import 'package:eng_alaa_hammed/core/formatters/formatter.dart';
import 'package:eng_alaa_hammed/features/playlists/domain/entities/playlist.dart';
import 'package:eng_alaa_hammed/features/playlists/presentation/logic/playlist_videos_cubit.dart';
import 'package:eng_alaa_hammed/features/playlists/presentation/logic/playlist_videos_state.dart';
import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';
import 'package:eng_alaa_hammed/features/videos/presentation/views/video_player_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class PlaylistVideosPage extends StatefulWidget {
  final Playlist playlist;

  const PlaylistVideosPage({
    super.key,
    required this.playlist,
  });

  @override
  State<PlaylistVideosPage> createState() => _PlaylistVideosPageState();
}

class _PlaylistVideosPageState extends State<PlaylistVideosPage> {
  late final PlaylistVideosCubit _cubit;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<PlaylistVideosCubit>()
      ..fetchVideos(
        playlistId: widget.playlist.id,
        playlistTitle: widget.playlist.title,
      );
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _cubit.loadMoreVideos();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              widget.playlist.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${widget.playlist.itemCount} ${widget.playlist.itemCount == 1 ? AppStrings.videoCount : AppStrings.videosPlural}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: BlocProvider.value(
        value: _cubit,
        child: BlocBuilder<PlaylistVideosCubit, PlaylistVideosState>(
          builder: (context, state) {
            if (state.status == PlaylistVideosStatus.loading) {
              return _buildShimmerLoading(context);
            }

            if (state.status == PlaylistVideosStatus.error) {
              return _buildErrorState(context, state);
            }

            if (state.status == PlaylistVideosStatus.loaded ||
                state.status == PlaylistVideosStatus.loadingMore) {
              return state.videos.isEmpty
                  ? _buildEmptyState(context)
                  : _buildVideoList(context, state);
            }

            return const SizedBox.shrink();
          },
        ),
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
        itemCount: 6,
        itemBuilder: (context, index) => _buildShimmerCard(),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            width: 120,
            height: 90,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 16,
                    width: 150,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 12,
                    width: 80,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, PlaylistVideosState state) {
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
            state.errorMessage ?? '',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _cubit.fetchVideos(
              playlistId: widget.playlist.id,
              playlistTitle: widget.playlist.title,
            ),
            child: const Text(AppStrings.retry),
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _cubit.refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.video_library,
                  size: 80,
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.7),
                ),
                const SizedBox(height: 16),
                Text(
                  AppStrings.noVideosAvailable,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.checkBackLater,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoList(BuildContext context, PlaylistVideosState state) {
    return RefreshIndicator(
      onRefresh: () => _cubit.refresh(),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(8),
        itemCount: state.videos.length + (state.hasReachedEnd ? 0 : 1),
        itemBuilder: (context, index) {
          if (index >= state.videos.length) {
            return _buildLoadingMoreIndicator();
          }
          return _buildVideoCard(context, state.videos[index], index);
        },
      ),
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }

  Widget _buildVideoCard(BuildContext context, Video video, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
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
        child: Row(
          children: [
            // Video number
            Container(
              width: 32,
              alignment: Alignment.center,
              child: Text(
                '${index + 1}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                    ),
              ),
            ),
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl: video.thumbnailUrl,
                width: 100,
                height: 56,
                fit: BoxFit.cover,
                memCacheWidth: 200,
                memCacheHeight: 112,
                placeholder: (context, url) => Container(
                  width: 100,
                  height: 56,
                  color: Colors.grey[300],
                ),
                errorWidget: (context, url, error) => Container(
                  width: 100,
                  height: 56,
                  color: Colors.grey[300],
                  child: const Icon(Icons.error, size: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Video info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      TFormatter.formatDate(video.publishedAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6),
                          ),
                    ),
                  ],
                ),
              ),
            ),
            // Play icon
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.play_circle_outline,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
