import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
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
import 'package:nanimo/features/event/presentation/widgets/create_event/create_event_bottom_sheet/add_image_bottom_sheet_widget.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/create_event_bottom_sheet/edit_event_image_bottom_sheet_widget.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/create_event_bottom_sheet/event_type_bottom_sheet_widget.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/create_event_bottom_sheet/pet_select_bottom_sheet_widget.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/polaroid_collage_widget.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/sticker_selector_widget.dart';
import 'package:nanimo/features/subscription/presentation/cubit/subscription_cubit.dart';

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

  /// Photos allowed for this event: the plan quota, capped by the collage max.
  int _maxImages(BuildContext context) {
    final quota = context.read<SubscriptionCubit>().state.maxImagesPerEvent;
    return quota < PolaroidCollageWidget.maxImages ? quota : PolaroidCollageWidget.maxImages;
  }


  String _quotaMessage(SubscriptionState subscription, int maxImages) {
    if (!subscription.isLoaded) {
      return 'Impossible de vérifier votre abonnement. Vérifiez votre connexion, puis réessayez.';
    }
    if (!subscription.isPremium) {
      return 'Le plan gratuit est limité à $maxImages photo${maxImages > 1 ? 's' : ''} par souvenir. '
          'Passez au premium pour en ajouter plus.';
    }
    return 'Vous pouvez ajouter $maxImages photos maximum.';
  }

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

  Future<void> _addImages() async {
    final messenger = ScaffoldMessenger.of(context);
    final maxImages = _maxImages(context);
    final subscription = context.read<SubscriptionCubit>().state;
    final picked = await AddImageBottomSheetWidget.show(context);
    if (picked == null || picked.isEmpty || !mounted) return;

    final remaining = maxImages - _images.length;
    if (remaining <= 0) {
      messenger
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(_quotaMessage(subscription, maxImages)),
          ),
        );
      return;
    }

    setState(() => _images.addAll([
          for (final image in picked.take(remaining)) LocalCollageImage(image),
        ]));
  }

  Future<void> _showImageGrid(String eventId) async {
    if (_images.isEmpty) {
      await _addImages();
      return;
    }

    final selection = await EditEventImageGridBottomSheetWidget.show(
      context,
      images: List.of(_images),
      urlResolver: context.read<EditEventCubit>().imageUrl,
      canAdd: _images.length < _maxImages(context),
    );
    if (selection == null || !mounted) return;

    switch (selection) {
      case EditEventImageGridAddSelected():
        await _addImages();
      case EditEventImageGridImageSelected(:final index):
        await _showImageActions(eventId, index);
    }
  }

  Future<void> _showImageActions(
    String eventId,
    int index,
  ) async {
    if (index < 0 || index >= _images.length) return;

    final action = await EditEventImageActionBottomSheetWidget.show(context);
    if (action == null || !mounted) return;

    switch (action) {
      case EditEventImageAction.takePhoto:
        await _replaceImage(index, eventId, ImageSource.camera);
      case EditEventImageAction.selectPhoto:
        await _replaceImage(index, eventId, ImageSource.gallery);
      case EditEventImageAction.deletePhoto:
        setState(() => _removeImageAt(index, eventId));
    }
  }

  Future<void> _replaceImage(
    int index,
    String eventId,
    ImageSource source,
  ) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked == null || !mounted || index >= _images.length) return;

    setState(() {
      _markImageRemoved(_images[index], eventId);
      _images[index] = LocalCollageImage(picked);
    });
  }

  void _removeImageAt(int index, String eventId) {
    final image = _images.removeAt(index);
    _markImageRemoved(image, eventId);
  }

  void _markImageRemoved(CollageImage image, String eventId) {
    if (image is! RemoteCollageImage) return;
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
              PolaroidCollageWidget(
                images: _images,
                urlResolver: context.read<EditEventCubit>().imageUrl,
                onTap: () => _showImageGrid(state.event!.eventId),
                onImageTap: (_) => _showImageGrid(state.event!.eventId),
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
