import 'package:eng_alaa_hammed/core/constants/colors.dart';
import 'package:eng_alaa_hammed/core/constants/strings.dart';
import 'package:eng_alaa_hammed/core/dependency_injection/service_locator.dart';
import 'package:eng_alaa_hammed/core/widgets/enhanced_video_card.dart';
import 'package:eng_alaa_hammed/features/videos/presentation/views/video_player_page.dart';
import 'package:eng_alaa_hammed/features/watch_history/domain/entities/watch_history_entry.dart';
import 'package:eng_alaa_hammed/features/watch_history/presentation/logic/watch_history_cubit.dart';
import 'package:eng_alaa_hammed/features/watch_history/presentation/logic/watch_history_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WatchHistoryPage extends StatefulWidget {
  const WatchHistoryPage({super.key});

  @override
  State<WatchHistoryPage> createState() => _WatchHistoryPageState();
}

class _WatchHistoryPageState extends State<WatchHistoryPage> {
  @override
  void initState() {
    super.initState();
    getIt<WatchHistoryCubit>().loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<WatchHistoryCubit, WatchHistoryState>(
      bloc: getIt<WatchHistoryCubit>(),
      builder: (context, state) {
        if (state.status == WatchHistoryStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.history.isEmpty) {
          return _buildEmptyState(theme);
        }

        return RefreshIndicator(
          onRefresh: () => getIt<WatchHistoryCubit>().loadHistory(),
          child: CustomScrollView(
            slivers: [
              // Continue Watching section
              if (state.inProgress.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                    child: Row(
                      children: [
                        Icon(
                          Icons.play_circle_outline,
                          color: theme.primaryColor,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          AppStrings.continueWatching,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 160.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      itemCount: state.inProgress.length,
                      itemBuilder: (context, index) {
                        final entry = state.inProgress[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: _buildContinueWatchingCard(context, entry),
                        );
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Divider(
                    height: 24.h,
                    indent: 16.w,
                    endIndent: 16.w,
                  ),
                ),
              ],

              // Watch History section
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.history,
                            color: theme.primaryColor,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            AppStrings.watchHistory,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      if (state.history.isNotEmpty)
                        TextButton.icon(
                          onPressed: () => _showClearHistoryDialog(context),
                          icon: Icon(Icons.delete_outline, size: 18.sp),
                          label: Text(AppStrings.clearHistory),
                        ),
                    ],
                  ),
                ),
              ),

              // History list
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final entry = state.history[index];
                      return Dismissible(
                        key: Key(entry.videoId),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 16.w),
                          color: Colors.red,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (_) {
                          getIt<WatchHistoryCubit>()
                              .removeFromHistory(entry.videoId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(AppStrings.removedFromHistory),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: _buildHistoryCard(context, entry),
                        ),
                      );
                    },
                    childCount: state.history.length,
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: SizedBox(height: 100.h),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 80.sp,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            SizedBox(height: 16.h),
            Text(
              AppStrings.noWatchHistory,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              AppStrings.noWatchHistoryDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueWatchingCard(BuildContext context, WatchHistoryEntry entry) {
    final theme = Theme.of(context);

    return Semantics(
      label: '${AppStrings.continueWatching}: ${entry.title}',
      button: true,
      child: GestureDetector(
        onTap: () => _navigateToVideo(context, entry),
        child: Container(
          width: 200.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Stack(
              children: [
                // Thumbnail
                Image.network(
                  entry.thumbnailUrl,
                  width: 200.w,
                  height: 160.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 200.w,
                    height: 160.h,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.video_library,
                      size: 40.sp,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),

                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                ),

                // Progress bar
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    value: entry.watchProgress,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.primaryColor,
                    ),
                    minHeight: 3,
                  ),
                ),

                // Title and resume info
                Positioned(
                  bottom: 8.h,
                  left: 8.w,
                  right: 8.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.title,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${entry.formattedLastPosition} / ${entry.formattedDuration}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                // Play button
                Positioned.fill(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 32.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, WatchHistoryEntry entry) {
    return EnhancedVideoCard(
      video: entry.toVideo(),
      onTap: () => _navigateToVideo(context, entry),
    );
  }

  void _navigateToVideo(BuildContext context, WatchHistoryEntry entry) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerPage(video: entry.toVideo()),
      ),
    ).then((_) {
      // Refresh history after returning from video
      getIt<WatchHistoryCubit>().loadHistory();
    });
  }

  void _showClearHistoryDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.clearHistory),
        content: Text(AppStrings.clearHistoryConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              getIt<WatchHistoryCubit>().clearHistory();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppStrings.watchHistory),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            child: Text(AppStrings.confirm),
          ),
        ],
      ),
    );
  }
}
