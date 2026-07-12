import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_font_size.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/features/event/data/models/event_model.dart';

class HomeMemoryPolaroidWidget extends StatelessWidget {
  final EventModel event;
  final int? yearsAgo;
  final List<String> imagePaths;
  final Future<String> Function(String assetPath) urlResolver;
  final VoidCallback? onTap;

  const HomeMemoryPolaroidWidget({
    super.key,
    required this.event,
    required this.imagePaths,
    required this.urlResolver,
    this.yearsAgo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Transform.rotate(
          angle: -0.03,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              _buildFrame(),
              _buildTape(),
              _buildTag(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFrame() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.backgroundSurface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.backgroundStroke, width: 2),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm / 2),
              child: _buildPhoto(),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  event.title,
                  style: AppTextStyles.textBold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              if (event.entryDate != null)
                Text(
                  DateFormatter.date(event.entryDate!.toLocal()),
                  style: AppTextStyles.numberSmall.copyWith(
                    fontSize: AppFontSize.xs,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhoto() {
    if (imagePaths.isEmpty) {
      return Container(
        color: AppColors.backgroundPrimary,
        alignment: Alignment.center,
        child: const Icon(
          Icons.pets,
          color: AppColors.primary300,
          size: AppSpacing.xxl,
        ),
      );
    }

    return FutureBuilder<String>(
      future: urlResolver(imagePaths.first),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(
            color: AppColors.background,
            alignment: Alignment.center,
            child: Icon(Icons.photo, color: AppColors.textSecondary, size: AppSpacing.xl),
          );
        }
        if (!snapshot.hasData || snapshot.hasError) {
          return Container(
            color: AppColors.background,
            alignment: Alignment.center,
            child: Icon(Icons.broken_image_outlined, color: AppColors.textSecondary, size: AppSpacing.xl),
          );
        }
        return CachedNetworkImage(
            imageUrl: snapshot.data!,
            cacheKey: imagePaths.first,
            fit: BoxFit.cover,
            placeholder: (context, url) {
              return Container(
                color: AppColors.background,
                alignment: Alignment.center,
                child: Icon(
                  Icons.photo,
                  color: AppColors.textSecondary,
                  size: AppSpacing.xl,
                ),
              );
            },
            errorWidget: (context, url, error) {
              return Container(
                color: AppColors.background,
                alignment: Alignment.center,
                child: Icon(
                  Icons.broken_image_outlined,
                  color: AppColors.textSecondary,
                  size: AppSpacing.xl,
                ),
              );
            });
      },
    );
  }

  Widget _buildTape() {
    /// The tape that holds the polaroid frame
    return Positioned(
      top: -AppSpacing.md,
      left: 0,
      right: 0,
      child: Center(
        child: Transform.rotate(
          angle: 0.05,
          child: Container(
            width: 96,
            height: 26,
            color: AppColors.tertiary200.withValues(alpha: 0.85),
          ),
        ),
      ),
    );
  }

  Widget _buildTag() {
    /// Tag with the memory's label
    return Positioned(
      top: -AppSpacing.sm,
      left: -AppSpacing.sm,
      child: Transform.rotate(
        angle: -0.06,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.tertiary300,
            borderRadius: BorderRadius.circular(AppRadius.sm / 2),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            yearsAgo == null
                ? 'Dernier souvenir'
                : yearsAgo == 1
                    ? 'Il y a 1 an'
                    : 'Il y a $yearsAgo ans',
            style: AppTextStyles.textSmallBold,
          ),
        ),
      ),
    );
  }
}
