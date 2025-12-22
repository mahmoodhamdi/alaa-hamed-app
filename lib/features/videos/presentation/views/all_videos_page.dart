import 'package:cached_network_image/cached_network_image.dart';
import 'package:eng_alaa_hammed/core/constants/strings.dart';
import 'package:eng_alaa_hammed/core/dependency_injection/service_locator.dart';
import 'package:eng_alaa_hammed/core/enums/status.dart';
import 'package:eng_alaa_hammed/core/formatters/formatter.dart';
import 'package:eng_alaa_hammed/features/settings/presentation/views/settings_page.dart';
import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';
import 'package:eng_alaa_hammed/features/videos/presentation/logic/all_videos_cubit.dart';
import 'package:eng_alaa_hammed/features/videos/presentation/logic/all_videos_state.dart';
import 'package:eng_alaa_hammed/features/videos/presentation/views/video_player_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

/// AllVideosPage displays a list of videos from YouTube channel.
/// Features: pagination, pull-to-refresh, shimmer loading.
class AllVideosPage extends StatefulWidget {
  const AllVideosPage({super.key});

  @override
  State<AllVideosPage> createState() => _AllVideosPageState();
}

class _AllVideosPageState extends State<AllVideosPage> {
  late final VideoCubit _videoCubit;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _videoCubit = getIt<VideoCubit>()..fetchVideos();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _videoCubit.close();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _videoCubit.loadMore();
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
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: BlocProvider.value(
          value: _videoCubit,
          child: BlocBuilder<VideoCubit, AllVideosState>(
            builder: (context, state) {
              if (state.status == AllVideosStatus.loading) {
                return _buildShimmerLoading(context);
              }

              if (state.status == AllVideosStatus.failure) {
                return _buildErrorState(context, state);
              }

              if (state.status == AllVideosStatus.loaded) {
                return state.videos.isEmpty
                    ? _buildEmptyState(context)
                    : _buildVideoList(context, state);
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: BlocBuilder<VideoCubit, AllVideosState>(
        bloc: _videoCubit,
        builder: (context, state) {
          final count = state.videos.length;
          final total = state.totalResults;
          return Column(
            children: [
              Text(
                AppStrings.allVideos,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (state.status == AllVideosStatus.loaded && count > 0)
                Text(
                  '$count / $total ${AppStrings.videosCount}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                      ),
                ),
            ],
          );
        },
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

  Widget _buildErrorState(BuildContext context, AllVideosState state) {
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
            state.errorMessage,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _videoCubit.fetchVideos(),
            child: const Text(AppStrings.retry),
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _videoCubit.refreshVideos(),
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

  Widget _buildVideoList(BuildContext context, AllVideosState state) {
    return RefreshIndicator(
      onRefresh: () => _videoCubit.refreshVideos(),
      child: ListView.builder(
        controller: _scrollController,
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

  Widget _buildLoadingMoreIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }

  Widget _buildVideoCard(BuildContext context, Video video) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
            // Thumbnail with play overlay
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
            // Video info
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
