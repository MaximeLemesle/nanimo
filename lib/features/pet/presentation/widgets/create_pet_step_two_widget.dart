import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_attribute_selector/pet_birthdate_selector_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_attribute_selector/pet_gender_selector_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_attribute_selector/pet_race_selector_widget.dart';

class CreatePetStepTwoWidget extends StatelessWidget {
  const CreatePetStepTwoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Quelques détails',
            style: textTheme.displaySmall,
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
