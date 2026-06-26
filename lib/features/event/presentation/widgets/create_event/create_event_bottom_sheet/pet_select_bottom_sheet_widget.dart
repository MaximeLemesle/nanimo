import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/pet_avatar_widget.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';

class PetSelectBottomSheetWidget extends StatefulWidget {
  final List<PetModel> pets;
  final List<String> selectedPetIds;
  final Map<String, String> iconsKey;

  const PetSelectBottomSheetWidget({
    super.key,
    required this.pets,
    required this.selectedPetIds,
    required this.iconsKey,
  });

  static Future<List<String>?> show(
    BuildContext context, {
    required List<PetModel> pets,
    required List<String> selectedPetIds,
    required Map<String, String> iconsKey,
  }) {
    return BottomSheetWidget.show<List<String>>(
      context,
      PetSelectBottomSheetWidget(
        pets: pets,
        selectedPetIds: selectedPetIds,
        iconsKey: iconsKey,
      ),
    );
  }

  @override
  State<PetSelectBottomSheetWidget> createState() =>
      _PetSelectBottomSheetWidgetState();
}

class _PetSelectBottomSheetWidgetState
    extends State<PetSelectBottomSheetWidget> {
  late final Set<String> _selected = {...widget.selectedPetIds};

  @override
  Widget build(BuildContext context) {
    final hasSelection = _selected.isNotEmpty;

    return BottomSheetWidget(
      title: 'Choisir au moins un animal',
      scrollable: true,
      action: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!hasSelection) ...[
            Text(
              'Sélectionnez au moins un animal pour ce souvenir.',
              textAlign: TextAlign.center,
              style: AppTextStyles.textSmall
                  .copyWith(color: AppColors.secondary500),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          ButtonWidget(
            label: 'Valider',
            fullWidth: true,
            state: hasSelection ? ButtonState.normal : ButtonState.disabled,
            onPressed: hasSelection
                ? () => Navigator.of(context).pop(_selected.toList())
                : null,
          ),
        ],
      ),
      children: [
        if (widget.pets.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Text(
              'Aucun animal disponible.',
              style:
                  AppTextStyles.text.copyWith(color: AppColors.textSecondary),
            ),
          )
        else
          for (final pet in widget.pets)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.md),
                onTap: () {
                  setState(() {
                    if (_selected.contains(pet.petId)) {
                      _selected.remove(pet.petId);
                    } else {
                      _selected.add(pet.petId);
                    }
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: _selected.contains(pet.petId)
                          ? AppColors.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      _petIcon(pet),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(pet.petName, style: AppTextStyles.text),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      ],
    );
  }

  Widget _petIcon(PetModel pet) {
    final iconKey = widget.iconsKey[pet.petSpeciesId];
    if (iconKey == null) {
      return const Icon(Icons.pets, color: AppColors.primary, size: 40);
    }
    return PetAvatarWidget(iconKey: iconKey, size: PetAvatarSize.small);
  }
}
