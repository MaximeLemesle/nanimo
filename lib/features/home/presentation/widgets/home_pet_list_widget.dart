import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/pet_avatar_widget.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';

class HomePetListWidget extends StatelessWidget {
  final List<PetModel> pets;
  final Map<String, String> iconsKey;
  final void Function(String petId)? onPetTap;

  const HomePetListWidget({
    super.key,
    required this.pets,
    required this.iconsKey,
    this.onPetTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        Text(
          pets.length > 1 ? 'Mes Nanimo' : 'Mon Nanimo',
          style: AppTextStyles.text.copyWith(color: AppColors.textSecondary),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < pets.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.xl),
                GestureDetector(
                  onTap: onPetTap == null ? null : () => onPetTap!(pets[i].petId),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    children: [
                      if (iconsKey[pets[i].petSpeciesId] != null)
                        PetAvatarWidget(iconKey: iconsKey[pets[i].petSpeciesId]!)
                      else
                        SizedBox(
                          width: PetAvatarSize.medium.dimension,
                          height: PetAvatarSize.medium.dimension,
                          child: const Icon(
                            Icons.pets,
                            color: AppColors.textSecondary,
                            size: AppSpacing.xl,
                          ),
                        ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        pets[i].petName,
                        style: AppTextStyles.textSmallBold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
