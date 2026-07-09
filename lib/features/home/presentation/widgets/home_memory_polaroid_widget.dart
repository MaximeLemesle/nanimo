import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_font_size.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/features/event/data/models/event_model.dart';

/// Hero polaroid of the home page: the memory that happened on the same
/// date [yearsAgo] years ago, or the latest memory as a fallback.
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

  String get _flagLabel {
    final years = yearsAgo;
    if (years == null) return 'Dernier souvenir';
    return years == 1 ? 'Il y a 1 an' : 'Il y a $years ans';
  }

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
              _buildFlag(),
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
          return _placeholder();
        }
        if (!snapshot.hasData || snapshot.hasError) {
          return _placeholder(icon: Icons.broken_image_outlined);
        }
        return CachedNetworkImage(
          imageUrl: snapshot.data!,
          // The signed url token changes on every call; key the disk cache
          // on the stable storage path instead.
          cacheKey: imagePaths.first,
          fit: BoxFit.cover,
          placeholder: (context, url) => _placeholder(),
          errorWidget: (context, url, error) =>
              _placeholder(icon: Icons.broken_image_outlined),
        );
      },
    );
  }

  Widget _placeholder({IconData icon = Icons.photo}) {
    return Container(
      color: AppColors.background,
      alignment: Alignment.center,
      child: Icon(icon, color: AppColors.textSecondary, size: AppSpacing.xl),
    );
  }

  Widget _buildTape() {
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

  Widget _buildFlag() {
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
            _flagLabel,
            style: AppTextStyles.textSmallBold.copyWith(
              color: AppColors.tertiary900,
            ),
          ),
        ),
      ),
    );
  }
}
