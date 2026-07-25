import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/app_scaffold.dart';
import 'package:nanimo/core/widgets/species_icon_widget.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/date_time_field_widget.dart';
import 'package:nanimo/features/event/data/models/event_image_model.dart';
import 'package:nanimo/features/event/data/models/event_model.dart';
import 'package:nanimo/features/event/presentation/cubit/edit_event_cubit.dart';
import 'package:nanimo/features/event/presentation/event_type_styles.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/create_event_bottom_sheet/event_type_bottom_sheet_widget.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/create_event_bottom_sheet/pet_select_bottom_sheet_widget.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/polaroid_collage_widget.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/sticker_selector_widget.dart';
import 'package:nanimo/features/event/presentation/widgets/event_photo/event_photo_picker_widget.dart';

class EditEventPage extends StatefulWidget {
  const EditEventPage({super.key});

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  static const int _maxTitleLength = 30;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _entryDate = DateTime.now();
  List<CollageImage> _images = [];
  final List<EventImageModel> _removedImages = [];
  bool _seeded = false;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_onTitleChanged);
  }

  void _onTitleChanged() => setState(() {});

  void _setEntryDate(DateTime date) {
    setState(() {
      _entryDate = DateTime(
        date.year,
        date.month,
        date.day,
        _entryDate.hour,
        _entryDate.minute,
        _entryDate.second,
        _entryDate.millisecond,
        _entryDate.microsecond,
      );
    });
  }

  void _setEntryTime(TimeOfDay time) {
    setState(() {
      _entryDate = DateTime(
        _entryDate.year,
        _entryDate.month,
        _entryDate.day,
        time.hour,
        time.minute,
      );
    });
  }

  @override
  void dispose() {
    _titleController.removeListener(_onTitleChanged);
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// Prefills the form from the loaded event
  void _seedFromEvent(EventModel event, List<EventImageModel> images) {
    _seeded = true;
    _entryDate = event.entryDate ?? DateTime.now();
    _images = [
      for (final image in images)
        RemoteCollageImage(
          eventImageId: image.eventImageId,
          assetPath: image.assetPath,
        ),
    ];
    _titleController.removeListener(_onTitleChanged);
    _titleController.text = event.title;
    _titleController.addListener(_onTitleChanged);
    _descriptionController.text = event.description ?? '';
  }

  /// Queues a stored photo for deletion on submit. Dropping it from [_images]
  /// only removes it from the form — the row and its file live on until then.
  void _markImageRemoved(RemoteCollageImage image, String eventId) {
    final alreadyRemoved = _removedImages.any(
      (removed) => removed.eventImageId == image.eventImageId,
    );
    if (alreadyRemoved) return;

    _removedImages.add(EventImageModel(
      eventImageId: image.eventImageId,
      assetPath: image.assetPath,
      eventId: eventId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditEventCubit, EditEventState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == EditEventStatus.success) {
          context.pop();
        } else if (state.status == EditEventStatus.error && state.error != null) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },
      builder: (context, state) {
        if (!state.isLoaded) {
          return const AppScaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!_seeded) {
          _seedFromEvent(state.event!, state.existingImages);
        }

        final isLoading = state.status == EditEventStatus.loading;
        final selectedType = state.types.firstWhere(
          (type) => type.eventTypeId == state.selectedTypeId,
          orElse: () => state.types.first,
        );
        final selectedStyle = EventTypeStyle.fromCode(selectedType.code);
        final selectedPets = state.pets.where((pet) => state.selectedPetIds.contains(pet.petId)).toList();

        final canSubmit = _titleController.text.trim().isNotEmpty && selectedPets.isNotEmpty;
        final String petLabel;
        if (selectedPets.isEmpty) {
          petLabel = 'Animal';
        } else if (selectedPets.length == 1) {
          petLabel = selectedPets.first.petName;
        } else {
          petLabel = '${selectedPets.length} animaux';
        }

        return AppScaffold(
          body: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.bottomBarInset,
            ),
            children: [
              Row(
                children: [
                  /// Back button
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back),
                    color: AppColors.textPrimary,
                    tooltip: 'Retour',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    visualDensity: VisualDensity.compact,
                  ),
                  const SizedBox(width: AppSpacing.sm),

                  /// Date and time selector
                  Expanded(
                    child: DateTimeFieldWidget(
                      value: _entryDate,
                      onDateChanged: _setEntryDate,
                      onTimeChanged: _setEntryTime,
                      textStyle: AppTextStyles.textBold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              /// Title selector
              TextField(
                controller: _titleController,
                style: AppTextStyles.title02,
                maxLines: null,
                maxLength: _maxTitleLength,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(_maxTitleLength),
                ],
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Ajouter un titre',
                  hintStyle: AppTextStyles.title02.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              /// Pet and type selectors
              Row(
                spacing: AppSpacing.md,
                children: [
                  /// Pet selector
                  Expanded(
                    child: StickerSelectorWidget(
                      semanticLabel: petLabel,
                      stickers: [
                        for (final pet in selectedPets)
                          if (state.iconsKey[pet.petSpeciesId] != null)
                            SpeciesIconWidget(
                              iconKey: state.iconsKey[pet.petSpeciesId]!,
                              height: StickerSelectorWidget.stickerHeight,
                            ),
                      ],
                      onTap: () async {
                        final state = context.read<EditEventCubit>().state;
                        final selected = await PetSelectBottomSheetWidget.show(
                          context,
                          pets: state.pets,
                          selectedPetIds: state.selectedPetIds,
                          iconsKey: state.iconsKey,
                        );
                        if (selected == null || !mounted) return;
                        setState(() {
                          context.read<EditEventCubit>().setSelectedPets(selected);
                        });
                      },
                    ),
                  ),

                  /// Type selector
                  Expanded(
                    child: StickerSelectorWidget(
                      semanticLabel: selectedType.name,
                      stickers: [
                        Image.asset(
                          selectedStyle.iconAsset,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      ],
                      onTap: () async {
                        final state = context.read<EditEventCubit>().state;
                        final selected = await EventTypeBottomSheetWidget.show(
                          context,
                          types: state.types,
                          selectedTypeId: state.selectedTypeId,
                        );
                        if (selected == null || !mounted) return;
                        setState(() {
                          context.read<EditEventCubit>().selectType(selected);
                        });
                      },
                    ),
                  ),
                ],
              ),

              /// Images selector
              EventPhotoPickerWidget(
                images: _images,
                urlResolver: context.read<EditEventCubit>().imageUrl,
                onChanged: (images) => setState(() => _images = images),
                onRemoteImageRemoved: (image) =>
                    _markImageRemoved(image, state.event!.eventId),
              ),
              const SizedBox(height: AppSpacing.lg),

              /// Description selector
              TextField(
                controller: _descriptionController,
                style: AppTextStyles.text,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Ajouter une description',
                  hintStyle: AppTextStyles.title03.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              ButtonWidget(
                label: 'Enregistrer',
                fullWidth: true,
                isLoading: isLoading,
                state: canSubmit ? ButtonState.normal : ButtonState.disabled,
                onPressed: () {
                  context.read<EditEventCubit>().submit(
                        title: _titleController.text.trim(),
                        description: _descriptionController.text,
                        entryDate: _entryDate,
                        newImages: [
                          for (final image in _images)
                            if (image is LocalCollageImage) image.file,
                        ],
                        removedImages: List.of(_removedImages),
                      );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
