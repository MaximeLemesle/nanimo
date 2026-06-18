import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_creation/pet_attribute_selector/pet_birthdate_selector_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_creation/pet_attribute_selector/pet_gender_selector_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_creation/pet_attribute_selector/pet_race_selector_widget.dart';

class PetCreationStepTwoWidget extends StatelessWidget {
  const PetCreationStepTwoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Quelques détails',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: AppSpacing.xl),
          PetGenderSelectorWidget(),
          const SizedBox(height: AppSpacing.xxl),
          PetRaceSelectorWidget(),
          const SizedBox(height: AppSpacing.xxl),
          PetBirthdateSelectorWidget(),
        ],
      ),
    );
  }
}
