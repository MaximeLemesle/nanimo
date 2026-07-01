import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/widgets/species_icon_widget.dart';
import 'package:nanimo/features/event/data/models/event_model.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_timeline/event_polaroid_collage_widget.dart';

class JournalTimelineEventCardWidget extends StatelessWidget {
  final EventModel event;
  final List<String> imagePaths;
  final List<String> iconKeys;
  final Future<String> Function(String assetPath) urlResolver;

  final bool imageFirst;
  final VoidCallback? onTap;

  const JournalTimelineEventCardWidget({
    super.key,
    required this.event,
    required this.imagePaths,
    required this.iconKeys,
    required this.urlResolver,
    required this.imageFirst,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final date = event.entryDate;

    final textColumn = Expanded(
      child: Padding(
        padding: const EdgeInsetsGeometry.only(top: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.title, style: AppTextStyles.title03),
            if (event.description != null &&
                event.description!.trim().isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                event.description!,
                style: AppTextStyles.text,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (iconKeys.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              _PetList(iconKeys: iconKeys),
            ],
          ],
        ),
      ),
    );

    final Widget imageColumn = Expanded(
      child: JournalTimelinePolaroidCollageWidget(
        assetPaths: imagePaths,
        urlResolver: urlResolver,
      ),
    );

    final rowChildren = imagePaths.isEmpty
        ? [textColumn]
        : imageFirst
            ? [imageColumn, const SizedBox(width: AppSpacing.lg), textColumn]
            : [textColumn, const SizedBox(width: AppSpacing.lg), imageColumn];

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            if (date != null)
              Text(
                DateFormatter.eventHeader(date),
                style: AppTextStyles.numberSmall,
              ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: rowChildren,
            ),
          ],
        ),
      ),
    );
  }
}

class _PetList extends StatelessWidget {
  final List<String> iconKeys;

  const _PetList({required this.iconKeys});

  static const double _size = 50;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _size,
      child: Stack(
        children: [
          for (var i = 0; i < iconKeys.length; i++)
            Positioned(
              left: i * (_size * 0.7),
              child: SizedBox(
                width: _size,
                height: _size,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Transform.translate(
                        offset: const Offset(0, 2),
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              AppColors.shadow,
                              BlendMode.srcATop,
                            ),
                            child: SpeciesIconWidget(
                                iconKey: iconKeys[i], height: _size),
                          ),
                        ),
                      ),
                    ),
                    SpeciesIconWidget(iconKey: iconKeys[i], height: _size),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
