import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/polaroid_collage_widget.dart';

sealed class EventImageGridResult {
  const EventImageGridResult();
}

class EventImageGridImageSelected extends EventImageGridResult {
  final int index;

  const EventImageGridImageSelected(this.index);
}

class EventImageGridAddSelected extends EventImageGridResult {
  const EventImageGridAddSelected();
}

enum EventImageAction {
  takePhoto,
  selectPhoto,
  deletePhoto,
}

class EventImageGridBottomSheetWidget extends StatelessWidget {
  final List<CollageImage> images;

  /// Null in the create flow, which only ever holds freshly picked local files.
  final Future<String> Function(String assetPath)? urlResolver;

  const EventImageGridBottomSheetWidget({
    super.key,
    required this.images,
    this.urlResolver,
  });

  static Future<EventImageGridResult?> show(
    BuildContext context, {
    required List<CollageImage> images,
    Future<String> Function(String assetPath)? urlResolver,
  }) {
    return BottomSheetWidget.show<EventImageGridResult>(
      context,
      EventImageGridBottomSheetWidget(
        images: images,
        urlResolver: urlResolver,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      title: 'Photos du souvenir',
      scrollable: true,
      children: [
        GridView.builder(
          key: const ValueKey('event-image-grid'),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          /// The add tile stays put once the quota is reached: tapping it is
          /// how the plan limit gets explained, rather than silently vanishing.
          itemCount: images.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.sm,
          ),
          itemBuilder: (context, index) {
            if (index == images.length) {
              return _AddImageTile();
            }
            return _ImageGridTile(
              key: ValueKey('event-image-grid-tile-$index'),
              image: images[index],
              urlResolver: urlResolver,
              onTap: () => Navigator.of(context).pop(
                EventImageGridImageSelected(index),
              ),
            );
          },
        ),
      ],
    );
  }
}

class EventImageActionBottomSheetWidget extends StatelessWidget {
  const EventImageActionBottomSheetWidget({super.key});

  static Future<EventImageAction?> show(BuildContext context) {
    return BottomSheetWidget.show<EventImageAction>(
      context,
      const EventImageActionBottomSheetWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      title: 'Modifier la photo',
      children: [
        _ActionRow(
          icon: Icons.photo_camera_outlined,
          label: 'Prendre une photo',
          onTap: () => Navigator.of(context).pop(
            EventImageAction.takePhoto,
          ),
        ),
        _ActionRow(
          icon: Icons.image_outlined,
          label: 'Sélectionner une photo',
          onTap: () => Navigator.of(context).pop(
            EventImageAction.selectPhoto,
          ),
        ),
        _ActionRow(
          icon: Icons.delete_outline,
          label: 'Supprimer la photo',
          foregroundColor: AppColors.secondary600,
          backgroundColor: AppColors.secondary50,
          onTap: () => Navigator.of(context).pop(
            EventImageAction.deletePhoto,
          ),
        ),
      ],
    );
  }
}

class _ImageGridTile extends StatelessWidget {
  final CollageImage image;
  final Future<String> Function(String assetPath)? urlResolver;
  final VoidCallback onTap;

  const _ImageGridTile({
    super.key,
    required this.image,
    required this.urlResolver,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: _thumbnail(image),
      ),
    );
  }

  Widget _thumbnail(CollageImage image) {
    return switch (image) {
      LocalCollageImage(:final file) => Image.file(
          File(file.path),
          fit: BoxFit.cover,
        ),
      RemoteCollageImage(:final assetPath) when urlResolver != null =>
        FutureBuilder<String>(
          future: urlResolver!(assetPath),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return _placeholder();
            }
            if (!snapshot.hasData || snapshot.hasError) {
              return _placeholder(icon: Icons.broken_image_outlined);
            }
            return CachedNetworkImage(
              imageUrl: snapshot.data!,
              cacheKey: assetPath,
              fit: BoxFit.cover,
              placeholder: (_, __) => _placeholder(),
              errorWidget: (_, __, ___) => _placeholder(
                icon: Icons.broken_image_outlined,
              ),
            );
          },
        ),
      RemoteCollageImage() => _placeholder(icon: Icons.broken_image_outlined),
    };
  }

  Widget _placeholder({IconData icon = Icons.photo}) {
    return Container(
      color: AppColors.background,
      alignment: Alignment.center,
      child: Icon(icon, color: AppColors.textSecondary),
    );
  }
}

class _AddImageTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: const ValueKey('event-image-grid-add-tile'),
      borderRadius: BorderRadius.circular(AppRadius.sm),
      onTap: () => Navigator.of(context).pop(
        const EventImageGridAddSelected(),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary50,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: AppColors.primary100, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_photo_alternate_outlined,
              color: AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Ajouter',
              style: AppTextStyles.textSmallBold.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color foregroundColor;
  final Color backgroundColor;

  const _ActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.foregroundColor = AppColors.primary,
    this.backgroundColor = AppColors.primary50,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: Colors.transparent, width: 2),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(icon, color: foregroundColor, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.text.copyWith(color: foregroundColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
