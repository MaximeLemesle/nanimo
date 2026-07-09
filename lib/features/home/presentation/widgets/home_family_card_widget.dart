import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/utils/vaccine_status.dart';
import 'package:nanimo/core/widgets/species_icon_widget.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';

/// Family bento tile: one row per pet with its health status dot.
class HomeFamilyCardWidget extends StatelessWidget {
  final List<PetModel> pets;
  final Map<String, String> iconsKey;
  final Map<String, VaccineStatus> statusByPet;
  final void Function(String petId)? onPetTap;

  const HomeFamilyCardWidget({
    super.key,
    required this.pets,
    required this.iconsKey,
    required this.statusByPet,
    this.onPetTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.backgroundSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.backgroundStroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ma famille',
            style: AppTextStyles.textLabel.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final pet in pets)
            _PetRow(
              pet: pet,
              iconKey: iconsKey[pet.petSpeciesId],
              status: statusByPet[pet.petId] ?? VaccineStatus.done,
              onTap: onPetTap,
            ),
        ],
      ),
    );
  }
}

class _PetRow extends StatelessWidget {
  final PetModel pet;
  final String? iconKey;
  final VaccineStatus status;
  final void Function(String petId)? onTap;

  const _PetRow({
    required this.pet,
    required this.status,
    this.iconKey,
    this.onTap,
  });

  Color get _statusColor {
    switch (status) {
      case VaccineStatus.done:
        return AppColors.primary400;
      case VaccineStatus.soon:
        return AppColors.tertiary400;
      case VaccineStatus.overdue:
        return AppColors.secondary500;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap == null ? null : () => onTap!(pet.petId),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: [
            if (iconKey != null)
              SpeciesIconWidget(iconKey: iconKey!, height: AppSpacing.xl)
            else
              const Icon(
                Icons.pets,
                size: AppSpacing.lg,
                color: AppColors.textSecondary,
              ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.petName,
                    style: AppTextStyles.textSmallBold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    DateFormatter.age(pet.birthdate),
                    style: AppTextStyles.textSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Container(
              width: AppSpacing.sm + 2,
              height: AppSpacing.sm + 2,
              decoration: BoxDecoration(
                color: _statusColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
