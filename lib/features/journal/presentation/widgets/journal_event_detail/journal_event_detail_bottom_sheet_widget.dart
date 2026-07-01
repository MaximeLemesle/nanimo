import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/species_icon_widget.dart';
import 'package:nanimo/features/event/data/models/event_model.dart';
import 'package:nanimo/features/journal/presentation/cubit/journal_cubit.dart';

class JournalEventDetailBottomSheetWidget extends StatefulWidget {
  final String eventId;
  final VoidCallback? onEdit;

  const JournalEventDetailBottomSheetWidget({
    super.key,
    required this.eventId,
    this.onEdit,
  });

  static Future<void> show(
    BuildContext context, {
    required EventModel event,
    VoidCallback? onEdit,
  }) {
    final cubit = context.read<JournalCubit>();
    return BottomSheetWidget.show<void>(
      context,
      BlocProvider.value(
        value: cubit,
        child: JournalEventDetailBottomSheetWidget(
          eventId: event.eventId,
          onEdit: onEdit,
        ),
      ),
    );
  }

  @override
  State<JournalEventDetailBottomSheetWidget> createState() =>
      _JournalEventDetailBottomSheetWidgetState();
}

class _JournalEventDetailBottomSheetWidgetState
    extends State<JournalEventDetailBottomSheetWidget> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JournalCubit, JournalState>(
      builder: (context, state) {
        final event =
            state.events.where((e) => e.eventId == widget.eventId).firstOrNull;

        if (event == null) return const SizedBox.shrink();

        final imagePaths = state.imagePathsByEvent[widget.eventId] ?? const [];
        final petIds = state.petIdsByEvent[widget.eventId] ?? const [];
        final pets =
            state.pets.where((pet) => petIds.contains(pet.petId)).toList();
        final date = event.entryDate;

        return BottomSheetWidget(
          title: event.title,
          scrollable: true,
          action: _Actions(
            isDeleting: _isDeleting,
            onEdit: () {
              Navigator.of(context).pop();
              widget.onEdit?.call();
            },
            onDelete: () => _confirmAndDelete(context),
          ),
          children: [
            if (date != null) ...[
              Text(
                DateFormatter.eventHeader(date),
                style: AppTextStyles.numberSmall
                    .copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            if (imagePaths.isNotEmpty) ...[
              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: imagePaths.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: AppSpacing.md),
                  itemBuilder: (_, index) => _EventPhoto(
                    assetPath: imagePaths[index],
                    urlResolver: context.read<JournalCubit>().imageUrl,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            if (event.description != null &&
                event.description!.trim().isNotEmpty) ...[
              Text(event.description!, style: AppTextStyles.text),
              const SizedBox(height: AppSpacing.lg),
            ],
            if (pets.isNotEmpty) ...[
              Text(
                'Animaux',
                style: AppTextStyles.textSmallBold
                    .copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final pet in pets)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSurface,
                        border: Border.all(color: AppColors.backgroundStroke),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (state.iconsKey[pet.petSpeciesId] != null) ...[
                            SpeciesIconWidget(
                                iconKey: state.iconsKey[pet.petSpeciesId]!,
                                height: 28),
                            const SizedBox(width: AppSpacing.sm),
                          ],
                          Text(pet.petName, style: AppTextStyles.textBold),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }

  Future<void> _confirmAndDelete(BuildContext context) async {
    final cubit = context.read<JournalCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.backgroundSurface,
        title: Text('Supprimer ce souvenir ?', style: AppTextStyles.title03),
        content: Text(
          'Cette action est définitive.',
          style: AppTextStyles.text,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              'Annuler',
              style: AppTextStyles.textBold
                  .copyWith(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              'Supprimer',
              style: AppTextStyles.textBold
                  .copyWith(color: AppColors.secondary600),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isDeleting = true);
    final error = await cubit.deleteEvent(widget.eventId);
    if (!mounted) return;

    if (error != null) {
      setState(() => _isDeleting = false);
      messenger
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    navigator.pop();
  }
}

class _Actions extends StatelessWidget {
  final bool isDeleting;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _Actions({
    required this.isDeleting,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ButtonWidget(
            label: 'Modifier',
            type: ButtonType.secondary,
            fullWidth: true,
            state: isDeleting ? ButtonState.disabled : ButtonState.active,
            onPressed: onEdit,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: ButtonWidget(
            label: 'Supprimer',
            type: ButtonType.delete,
            fullWidth: true,
            isLoading: isDeleting,
            onPressed: onDelete,
          ),
        ),
      ],
    );
  }
}

class _EventPhoto extends StatelessWidget {
  final String assetPath;
  final Future<String> Function(String assetPath) urlResolver;

  const _EventPhoto({required this.assetPath, required this.urlResolver});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ShapeBorderClipper(
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md * 2),
        ),
      ),
      child: FutureBuilder<String>(
        future: urlResolver(assetPath),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return _placeholder();
          }
          if (!snapshot.hasData || snapshot.hasError) {
            return _placeholder(icon: Icons.broken_image_outlined);
          }
          return CachedNetworkImage(
            imageUrl: snapshot.data!,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
            placeholder: (_, __) => _placeholder(),
            errorWidget: (_, __, ___) =>
                _placeholder(icon: Icons.broken_image_outlined),
          );
        },
      ),
    );
  }

  Widget _placeholder({IconData icon = Icons.photo}) {
    return Container(
      width: 200,
      height: 200,
      color: AppColors.background,
      alignment: Alignment.center,
      child: Icon(icon, color: AppColors.textSecondary, size: AppSpacing.xl),
    );
  }
}
