import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_profile/pet_card_widget/pet_card_item_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_profile/pet_card_widget/pet_card_widget.dart';

class PetHealthOnboardingCardWidget extends StatelessWidget {
  final VoidCallback? onFillPressed;

  const PetHealthOnboardingCardWidget({super.key, this.onFillPressed});

  @override
  Widget build(BuildContext context) {
    return PetCardWidget(
      label: 'Carnet de santé',
      backgroundColor: AppColors.backgroundSurface,
      borderColor: AppColors.backgroundStroke,
      items: [
        PetCardItemWidget(
          label:
              'Remplis le carnet de santé de ton animal pour voir ses infos.',
          value: 'Aucune information pour le moment',
        ),
      ],
      button: ButtonWidget(
        label: 'Remplir le carnet',
        fullWidth: true,
        iconPosition: ButtonIcon.left,
        icon: Icons.add,
        onPressed: onFillPressed,
      ),
    );
  }
}
