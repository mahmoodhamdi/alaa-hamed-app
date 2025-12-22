import 'dart:async';

import 'package:eng_alaa_hammed/core/constants/strings.dart';
import 'package:eng_alaa_hammed/core/dependency_injection/service_locator.dart';
import 'package:eng_alaa_hammed/features/favorites/presentation/logic/favorites_cubit.dart';
import 'package:eng_alaa_hammed/features/favorites/presentation/logic/favorites_state.dart';
import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';
import 'package:eng_alaa_hammed/features/watch_history/presentation/logic/watch_history_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerPage extends StatefulWidget {
  final Video video;

  const VideoPlayerPage({
    super.key,
    required this.video,
  });

  String get videoId => video.id;
  String get title => video.title;
  String get publishedAt => video.publishedAt;
  String? get description => video.description;

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late YoutubePlayerController _controller;
  bool _isFullScreen = false;
  bool _isDescriptionExpanded = false;
  Timer? _progressTimer;
  int _lastSavedPosition = 0;
  bool _hasAddedToHistory = false;

  @override
  void initState() {
    super.initState();

    // Get last position from watch history
    final watchHistoryCubit = getIt<WatchHistoryCubit>();
    final lastPosition = watchHistoryCubit.getLastPosition(widget.video.id);

    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
        hideControls: false,
        forceHD: true,
        startAt: lastPosition ?? 0,
      ),
    )..addListener(_onPlayerStateChange);

    // Start progress tracking timer
    _progressTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _saveProgress(),
    );
  }

  void _onPlayerStateChange() {
    if (_controller.value.isFullScreen != _isFullScreen) {
      setState(() {
        _isFullScreen = _controller.value.isFullScreen;
      });
    }

    // Add to history when video starts playing
    if (_controller.value.isPlaying && !_hasAddedToHistory) {
      _hasAddedToHistory = true;
      _addToWatchHistory();
    }
  }

  void _addToWatchHistory() {
    final watchHistoryCubit = getIt<WatchHistoryCubit>();
    final duration = _controller.metadata.duration.inSeconds;
    watchHistoryCubit.addToHistory(
      widget.video,
      lastPositionSeconds: _controller.value.position.inSeconds,
      durationSeconds: duration,
    );
  }

  void _saveProgress() {
    if (!mounted) return;

    final currentPosition = _controller.value.position.inSeconds;
    final duration = _controller.metadata.duration.inSeconds;

    // Only save if position has changed significantly (more than 3 seconds)
    if ((currentPosition - _lastSavedPosition).abs() > 3 && duration > 0) {
      _lastSavedPosition = currentPosition;
      final watchHistoryCubit = getIt<WatchHistoryCubit>();
      watchHistoryCubit.updateProgress(
        widget.video.id,
        lastPositionSeconds: currentPosition,
        durationSeconds: duration,
      );
    }
  }

  @override
  void dispose() {
    // Save final progress before disposing
    _saveProgress();
    _progressTimer?.cancel();
    _controller.removeListener(_onPlayerStateChange);
    _controller.dispose();
    // Reset orientation when leaving
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  String get _videoUrl => 'https://www.youtube.com/watch?v=${widget.videoId}';

  void _shareVideo() {
    SharePlus.instance.share(
      ShareParams(
        text: '${widget.title}\n\n$_videoUrl',
        subject: widget.title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return YoutubePlayerBuilder(
      onEnterFullScreen: () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      },
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: theme.primaryColor,
        progressColors: ProgressBarColors(
          playedColor: theme.primaryColor,
          handleColor: theme.primaryColor,
          bufferedColor: theme.primaryColor.withValues(alpha: 0.3),
          backgroundColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
        ),
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: _isFullScreen
              ? null
              : AppBar(
                  elevation: 0,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.share),
                      tooltip: 'Share',
                      onPressed: _shareVideo,
                    ),
                  ],
                ),
          body: Column(
            children: [
              // Video Player
              player,

              // Video Info (only show when not fullscreen)
              if (!_isFullScreen)
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          widget.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Stats row
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: theme.textTheme.bodySmall?.color,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _formatDate(widget.publishedAt),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.textTheme.bodySmall?.color,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Action buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            BlocBuilder<FavoritesCubit, FavoritesState>(
                              bloc: getIt<FavoritesCubit>(),
                              builder: (context, state) {
                                final isFavorite =
                                    state.isFavorite(widget.video.id);
                                return _buildActionButton(
                                  context,
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  isFavorite
                                      ? AppStrings.removeFromFavorites
                                      : AppStrings.addToFavorites,
                                  () => getIt<FavoritesCubit>()
                                      .toggleFavorite(widget.video),
                                  isActive: isFavorite,
                                );
                              },
                            ),
                            _buildActionButton(
                              context,
                              Icons.share,
                              'Share',
                              _shareVideo,
                            ),
                            _buildActionButton(
                              context,
                              Icons.open_in_new,
                              'YouTube',
                              () => _openInYouTube(),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 8),

                        // Description section
                        if (widget.description != null &&
                            widget.description!.isNotEmpty) ...[
                          _buildDescriptionSection(theme),
                        ] else ...[
                          Text(
                            AppStrings.moreDetails,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No description available.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isActive = false,
  }) {
    final theme = Theme.of(context);
    final color = isActive ? Colors.red : theme.primaryColor;
    return Semantics(
      label: label,
      button: true,
      child: Tooltip(
        message: label,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(ThemeData theme) {
    final description = widget.description ?? '';
    final shouldShowExpand = description.length > 150;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: shouldShowExpand
              ? () {
                  setState(() {
                    _isDescriptionExpanded = !_isDescriptionExpanded;
                  });
                }
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.moreDetails,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (shouldShowExpand)
                Icon(
                  _isDescriptionExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: theme.primaryColor,
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        AnimatedCrossFade(
          firstChild: Text(
            description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
          secondChild: Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
          crossFadeState: _isDescriptionExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
        if (shouldShowExpand && !_isDescriptionExpanded)
          TextButton(
            onPressed: () {
              setState(() {
                _isDescriptionExpanded = true;
              });
            },
            child: const Text('Show more'),
          ),
      ],
    );
  }

  void _openInYouTube() async {
    // Show snackbar since we can't launch URLs directly
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Open: $_videoUrl'),
          action: SnackBarAction(
            label: 'Copy',
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _videoUrl));
            },
          ),
        ),
      );
    }
  }

  String _formatDate(String dateString) {
    try {
      final DateTime parsedDate = DateTime.parse(dateString);
      return DateFormat('MMMM d, y').format(parsedDate);
    } catch (e) {
      return dateString;
    }
  }
}
