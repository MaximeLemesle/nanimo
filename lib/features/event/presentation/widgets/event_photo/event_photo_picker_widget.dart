import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/create_event_bottom_sheet/add_image_bottom_sheet_widget.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/polaroid_collage_widget.dart';
import 'package:nanimo/features/event/presentation/widgets/event_photo/event_image_bottom_sheet_widget.dart';
import 'package:nanimo/features/subscription/presentation/cubit/subscription_cubit.dart';
import 'package:nanimo/features/subscription/presentation/quota_upsell.dart';

/// Photo picking for a souvenir: the polaroid collage, the grid and per-photo
/// action sheets, and the plan quota gating how many photos fit. Shared by the
/// create and edit flows so a photo is replaced in place in both.
///
/// Holds no state of its own — [images] is owned by the page, which needs it at
/// submit time anyway, and every change comes back through [onChanged].
class EventPhotoPickerWidget extends StatelessWidget {
  final List<CollageImage> images;
  final ValueChanged<List<CollageImage>> onChanged;

  /// Resolves signed urls for photos already stored server-side. The create
  /// flow has none, so it leaves this null.
  final Future<String> Function(String assetPath)? urlResolver;

  /// Reports a stored photo leaving the selection, replaced or deleted, so the
  /// edit flow can queue it for removal on submit.
  final ValueChanged<RemoteCollageImage>? onRemoteImageRemoved;

  const EventPhotoPickerWidget({
    super.key,
    required this.images,
    required this.onChanged,
    this.urlResolver,
    this.onRemoteImageRemoved,
  });

  /// Photos allowed for this event: the plan quota, probed one slot at a time
  /// through [SubscriptionState.canAddImageToEvent] so the helper stays the
  /// single authority, capped by what the collage can lay out.
  static int maxImagesForPlan(SubscriptionState subscription) {
    var max = 0;
    while (max < PolaroidCollageWidget.maxImages &&
        subscription.canAddImageToEvent(max)) {
      max++;
    }
    return max;
  }

  @override
  Widget build(BuildContext context) {
    return PolaroidCollageWidget(
      images: images,
      urlResolver: urlResolver,
      onTap: () => _openGrid(context),
      onImageTap: (_) => _openGrid(context),
    );
  }

  /// Entry point of the flow: straight to the picker while empty, otherwise the
  /// grid, from which a photo can be added, replaced or deleted.
  Future<void> _openGrid(BuildContext context) async {
    if (images.isEmpty) {
      await _add(context);
      return;
    }

    final selection = await EventImageGridBottomSheetWidget.show(
      context,
      images: List.of(images),
      urlResolver: urlResolver,
    );
    if (selection == null || !context.mounted) return;

    switch (selection) {
      case EventImageGridAddSelected():
        await _add(context);
      case EventImageGridImageSelected(:final index):
        await _openActions(context, index);
    }
  }

  Future<void> _add(BuildContext context) async {
    final subscription = context.read<SubscriptionCubit>().state;
    final maxImages = maxImagesForPlan(subscription);

    final picked = await AddImageBottomSheetWidget.show(context);
    if (picked == null || picked.isEmpty || !context.mounted) return;

    final remaining = maxImages - images.length;
    if (remaining <= 0) {
      QuotaUpsell.showEventImageQuota(context, subscription, maxImages);
      return;
    }

    onChanged([
      ...images,
      for (final image in picked.take(remaining)) LocalCollageImage(image),
    ]);
  }

  Future<void> _openActions(BuildContext context, int index) async {
    if (index < 0 || index >= images.length) return;

    final action = await EventImageActionBottomSheetWidget.show(context);
    if (action == null || !context.mounted) return;

    switch (action) {
      case EventImageAction.takePhoto:
        await _replace(context, index, ImageSource.camera);
      case EventImageAction.selectPhoto:
        await _replace(context, index, ImageSource.gallery);
      case EventImageAction.deletePhoto:
        _removeAt(index);
    }
  }

  /// Swaps the photo at [index] rather than dropping it and appending a new one,
  /// which would send it to the end of the collage.
  Future<void> _replace(
    BuildContext context,
    int index,
    ImageSource source,
  ) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked == null || !context.mounted || index >= images.length) return;

    final next = List.of(images);
    _reportRemoved(next[index]);
    next[index] = LocalCollageImage(picked);
    onChanged(next);
  }

  void _removeAt(int index) {
    final next = List.of(images);
    _reportRemoved(next.removeAt(index));
    onChanged(next);
  }

  void _reportRemoved(CollageImage image) {
    if (image is RemoteCollageImage) onRemoteImageRemoved?.call(image);
  }
}
