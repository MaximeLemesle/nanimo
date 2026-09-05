import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/widgets/pet_avatar_widget.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';

class PetPickerWidget extends StatelessWidget {
  final List<PetModel> pets;
  final Map<String, PetPortrait> portraits;
  final Set<String> selectedPetIds;
  final ValueChanged<String> onPetTap;

  const PetPickerWidget._({
    super.key,
    required this.pets,
    required this.portraits,
    required this.selectedPetIds,
    required this.onPetTap,
  });

  factory PetPickerWidget.single({
    Key? key,
    required List<PetModel> pets,
    required Map<String, PetPortrait> portraits,
    required String? selectedPetId,
    required ValueChanged<String> onSelected,
  }) {
    return PetPickerWidget._(
      key: key,
      pets: pets,
      portraits: portraits,
      selectedPetIds: selectedPetId == null ? const {} : {selectedPetId},
      onPetTap: onSelected,
    );
  }

  factory PetPickerWidget.multi({
    Key? key,
    required List<PetModel> pets,
    required Map<String, PetPortrait> portraits,
    required Set<String> selectedPetIds,
    required ValueChanged<String> onToggled,
  }) {
    return PetPickerWidget._(
      key: key,
      pets: pets,
      portraits: portraits,
      selectedPetIds: selectedPetIds,
      onPetTap: onToggled,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final pet in pets)
          _PetChoiceWidget(
            key: ValueKey(pet.petId),
            portrait: portraits[pet.petId],
            isSelected: selectedPetIds.contains(pet.petId),
            onTap: () => onPetTap(pet.petId),
          ),
      ],
    );
  }
}

class _PetChoiceWidget extends StatelessWidget {
  final PetPortrait? portrait;
  final bool isSelected;
  final VoidCallback onTap;

  const _PetChoiceWidget({
    super.key,
    required this.portrait,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.backgroundPrimary
              : AppColors.backgroundSurface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.backgroundStroke,
            width: 2,
          ),
        ),
        child: portrait == null
            ? const SizedBox.shrink()
            : PetAvatarWidget(portrait: portrait!, size: PetAvatarSize.small),
      ),
    );
  }
}
