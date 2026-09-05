import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/pet_avatar_widget.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';

class HomePetListWidget extends StatelessWidget {
  final List<PetModel> pets;
  final Map<String, PetPortrait> portraits;
  final void Function(String petId)? onPetTap;

  const HomePetListWidget({
    super.key,
    required this.pets,
    required this.portraits,
    this.onPetTap,
  });

  static final double _avatar = PetAvatarSize.medium.dimension;

  Widget _petItem(PetModel pet) {
    return GestureDetector(
      onTap: onPetTap == null ? null : () => onPetTap!(pet.petId),
      behavior: HitTestBehavior.opaque,

      child: SizedBox(
        width: _avatar,
        child: Column(
          children: [
            if (portraits[pet.petId] != null)
              PetAvatarWidget(portrait: portraits[pet.petId]!)
            else
              SizedBox(
                width: _avatar,
                height: _avatar,
                child: const Icon(
                  Icons.pets,
                  color: AppColors.textSecondary,
                  size: AppSpacing.xl,
                ),
              ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              pet.petName,
              style: AppTextStyles.textSmallBold,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

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
        LayoutBuilder(
          builder: (context, constraints) {
            final peek = _avatar / 2;
            final width = constraints.maxWidth;
            // How many avatars sit fully on screen before one peeks in half.
            final fullCount = ((width - peek) / (_avatar + AppSpacing.xl))
                .round()
                .clamp(1, pets.length);
            final overflows = pets.length > fullCount;
            // When the row overflows, stretch the gap so avatar #fullCount is
            // cut exactly at its middle on any screen width — a permanent cue
            // that the row keeps going. Otherwise use the design gap.
            final gap = overflows
                ? (width - peek) / fullCount - _avatar
                : AppSpacing.xl;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var i = 0; i < pets.length; i++) ...[
                    if (i > 0) SizedBox(width: gap),
                    _petItem(pets[i]),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
