import 'package:cached_network_image/cached_network_image.dart';
import 'package:eng_alaa_hammed/core/constants/colors.dart';
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
      baseColor: isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBase,
      highlightColor:
          isDark ? AppColors.shimmerHighlightDark : AppColors.shimmerHighlight,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: 8,
        itemBuilder: (context, index) => _buildShimmerCard(context),
      ),
    );
  }

  Widget _buildShimmerCard(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Number placeholder
          Container(
            width: 28,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          // Thumbnail placeholder
          Container(
            width: 100,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 14,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
                  width: 80,
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

  Widget _buildErrorState(BuildContext context, PlaylistVideosState state) {
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
              state.errorMessage ?? '',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _cubit.fetchVideos(
                playlistId: widget.playlist.id,
                playlistTitle: widget.playlist.title,
              ),
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

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () => _cubit.refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Center(
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
                          theme.colorScheme.primaryContainer
                              .withValues(alpha: 0.5),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.video_library_outlined,
                      size: 56,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    AppStrings.noVideosAvailable,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppStrings.checkBackLater,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Semantics(
      label:
          '${AppStrings.video} ${index + 1}, ${video.title}, ${TFormatter.formatDate(video.publishedAt)}',
      button: true,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
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
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  // Video number
                  ExcludeSemantics(
                    child: Container(
                      width: 28,
                      alignment: Alignment.center,
                      child: Text(
                        '${index + 1}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Thumbnail with play overlay
                  ExcludeSemantics(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
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
                              color: isDark
                                  ? AppColors.shimmerBaseDark
                                  : AppColors.shimmerBase,
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 100,
                              height: 56,
                              color: isDark
                                  ? AppColors.shimmerBaseDark
                                  : AppColors.shimmerBase,
                              child: Icon(
                                Icons.error_outline,
                                size: 20,
                                color: theme.colorScheme.error,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Video info
                  Expanded(
                    child: ExcludeSemantics(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            video.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 12,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                TFormatter.formatDate(video.publishedAt),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
