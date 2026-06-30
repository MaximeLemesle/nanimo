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
import 'package:nanimo/core/widgets/date_field_widget.dart';
import 'package:nanimo/features/event/presentation/cubit/event_creation_cubit.dart';
import 'package:nanimo/features/event/presentation/event_type_styles.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/create_event_bottom_sheet/add_image_bottom_sheet_widget.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/create_event_bottom_sheet/event_type_bottom_sheet_widget.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/create_event_bottom_sheet/pet_select_bottom_sheet_widget.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/polaroid_collage_widget.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/sticker_selector_widget.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  static const int _maxTitleLength = 30;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _entryDate = DateTime.now();
  final List<XFile> _images = [];

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_onTitleChanged);
  }

  void _onTitleChanged() => setState(() {});

  @override
  void dispose() {
    _titleController.removeListener(_onTitleChanged);
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventCreationCubit, EventCreationState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == EventCreationStatus.success) {
          context.pop();
        } else if (state.status == EventCreationStatus.error &&
            state.error != null) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },
      builder: (context, state) {
        if (state.types.isEmpty) {
          return const AppScaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final isLoading = state.status == EventCreationStatus.loading;
        final selectedType = state.types.firstWhere(
          (type) => type.eventTypeId == state.selectedTypeId,
          orElse: () => state.types.first,
        );
        final selectedStyle = EventTypeStyle.fromCode(selectedType.code);
        final selectedPets = state.pets
            .where((pet) => state.selectedPetIds.contains(pet.petId))
            .toList();

        final canSubmit =
            _titleController.text.trim().isNotEmpty && selectedPets.isNotEmpty;
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
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              /// Date selector
              DateFieldWidget(
                label: 'Date',
                value: _entryDate,
                onChanged: (date) => setState(() => _entryDate = date),
                bordered: false,
                textAlign: TextAlign.center,
                textStyle: AppTextStyles.textBold,
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
                        final state = context.read<EventCreationCubit>().state;
                        final selected = await PetSelectBottomSheetWidget.show(
                          context,
                          pets: state.pets,
                          selectedPetIds: state.selectedPetIds,
                          iconsKey: state.iconsKey,
                        );
                        if (selected == null || !mounted) return;
                        setState(() {
                          context
                              .read<EventCreationCubit>()
                              .setSelectedPets(selected);
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
                        final state = context.read<EventCreationCubit>().state;
                        final selected = await EventTypeBottomSheetWidget.show(
                          context,
                          types: state.types,
                          selectedTypeId: state.selectedTypeId,
                        );
                        if (selected == null || !mounted) return;
                        setState(() {
                          context
                              .read<EventCreationCubit>()
                              .selectType(selected);
                        });
                      },
                    ),
                  ),
                ],
              ),

              /// Images selector
              PolaroidCollageWidget(
                images: _images,
                onTap: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final picked = await AddImageBottomSheetWidget.show(context);
                  if (picked == null || picked.isEmpty) return;
                  final remaining =
                      PolaroidCollageWidget.maxImages - _images.length;
                  if (remaining <= 0) {
                    messenger
                      ..clearSnackBars()
                      ..showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Vous pouvez ajouter 5 photos maximum.',
                          ),
                        ),
                      );
                    return;
                  }
                  setState(() => _images.addAll(picked.take(remaining)));
                },
                onReplaceImage: (_) async {
                  /// Re-pick the whole set, replacing the current selection.
                  final picked = await ImagePicker().pickMultiImage(
                    limit: PolaroidCollageWidget.maxImages,
                  );
                  if (picked.isEmpty || !mounted) return;
                  setState(() {
                    _images
                      ..clear()
                      ..addAll(picked.take(PolaroidCollageWidget.maxImages));
                  });
                },
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
                  context.read<EventCreationCubit>().submit(
                        title: _titleController.text.trim(),
                        description: _descriptionController.text,
                        entryDate: _entryDate,
                        images: _images,
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
