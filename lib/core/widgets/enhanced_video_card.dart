import 'package:cached_network_image/cached_network_image.dart';
import 'package:eng_alaa_hammed/core/constants/colors.dart';
import 'package:eng_alaa_hammed/core/constants/strings.dart';
import 'package:eng_alaa_hammed/core/dependency_injection/service_locator.dart';
import 'package:eng_alaa_hammed/core/formatters/formatter.dart';
import 'package:eng_alaa_hammed/features/favorites/presentation/logic/favorites_cubit.dart';
import 'package:eng_alaa_hammed/features/favorites/presentation/logic/favorites_state.dart';
import 'package:eng_alaa_hammed/features/videos/domain/entities/video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnhancedVideoCard extends StatefulWidget {
  final Video video;
  final VoidCallback onTap;
  final bool showFavoriteButton;
  final bool isDismissible;
  final VoidCallback? onDismissed;

  const EnhancedVideoCard({
    super.key,
    required this.video,
    required this.onTap,
    this.showFavoriteButton = true,
    this.isDismissible = false,
    this.onDismissed,
  });

  @override
  State<EnhancedVideoCard> createState() => _EnhancedVideoCardState();
}

class _EnhancedVideoCardState extends State<EnhancedVideoCard>
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
    final card = _buildCard(context);

    if (widget.isDismissible) {
      return Dismissible(
        key: Key(widget.video.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.error,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.delete, color: Colors.white, size: 28),
        ),
        onDismissed: (_) => widget.onDismissed?.call(),
        child: card,
      );
    }

    return card;
  }

  Widget _buildCard(BuildContext context) {
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
            '${widget.video.title}, ${AppStrings.publishedOn} ${TFormatter.formatDate(widget.video.publishedAt)}',
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
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Thumbnail image
          CachedNetworkImage(
            imageUrl: widget.video.thumbnailUrl,
            fit: BoxFit.cover,
            memCacheWidth: 720,
            memCacheHeight: 405,
            fadeInDuration: const Duration(milliseconds: 200),
            placeholder: (context, url) => _buildPlaceholder(context),
            errorWidget: (context, url, error) => _buildErrorPlaceholder(context),
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
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),
          ),

          // Favorite button
          if (widget.showFavoriteButton)
            Positioned(
              top: 8,
              right: 8,
              child: _buildFavoriteButton(context),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBase,
      child: Center(
        child: CircularProgressIndicator.adaptive(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBase,
      child: Icon(
        Icons.error_outline,
        size: 40,
        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
      ),
    );
  }

  Widget _buildFavoriteButton(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      bloc: getIt<FavoritesCubit>(),
      builder: (context, state) {
        final isFavorite = state.isFavorite(widget.video.id);
        return GestureDetector(
          onTap: () {
            getIt<FavoritesCubit>().toggleFavorite(widget.video);
          },
          child: Tooltip(
            message: isFavorite
                ? AppStrings.removeFromFavorites
                : AppStrings.addToFavorites,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isFavorite
                    ? AppColors.favorite.withValues(alpha: 0.9)
                    : Colors.black.withValues(alpha: 0.6),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        );
      },
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
              widget.video.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Date row
          ExcludeSemantics(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.calendar_today_outlined,
                    size: 12,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  TFormatter.formatDate(widget.video.publishedAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
