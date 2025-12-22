import 'package:cached_network_image/cached_network_image.dart';
import 'package:eng_alaa_hammed/core/constants/colors.dart';
import 'package:eng_alaa_hammed/core/constants/strings.dart';
import 'package:eng_alaa_hammed/features/playlists/domain/entities/playlist.dart';
import 'package:flutter/material.dart';

class PlaylistCard extends StatefulWidget {
  final Playlist playlist;
  final VoidCallback onTap;

  const PlaylistCard({
    super.key,
    required this.playlist,
    required this.onTap,
  });

  @override
  State<PlaylistCard> createState() => _PlaylistCardState();
}

class _PlaylistCardState extends State<PlaylistCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: Semantics(
        label:
            '${widget.playlist.title}, ${widget.playlist.itemCount} ${widget.playlist.itemCount == 1 ? AppStrings.videoCount : AppStrings.videosPlural}',
        button: true,
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          onTap: widget.onTap,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
                  blurRadius: _isPressed ? 4 : 8,
                  offset: Offset(0, _isPressed ? 2 : 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: theme.cardTheme.color ?? theme.cardColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildThumbnail(context),
                    _buildContent(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Thumbnail image
          CachedNetworkImage(
            imageUrl: widget.playlist.thumbnailUrl,
            fit: BoxFit.cover,
            memCacheWidth: 720,
            memCacheHeight: 405,
            fadeInDuration: const Duration(milliseconds: 200),
            placeholder: (context, url) => Container(
              color: isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBase,
              child: Center(
                child: CircularProgressIndicator.adaptive(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  ),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBase,
              child: Icon(
                Icons.error_outline,
                size: 40,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),

          // Gradient overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppColors.thumbnailGradient,
              ),
            ),
          ),

          // Play button
          Center(
            child: ExcludeSemantics(
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.playlist_play_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),
          ),

          // Playlist count badge
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.video_library_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${widget.playlist.itemCount} ${widget.playlist.itemCount == 1 ? AppStrings.videoCount : AppStrings.videosPlural}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          ExcludeSemantics(
            child: Text(
              widget.playlist.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ),

          if (widget.playlist.description.isNotEmpty) ...[
            const SizedBox(height: 6),
            ExcludeSemantics(
              child: Text(
                widget.playlist.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
