import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_creation/grid_tile_widget.dart';

class PetGenderSelectorWidget extends StatelessWidget {
  const PetGenderSelectorWidget({super.key});

  static const _genderOptions =
      <({Gender gender, String label, IconData icon})>[
    (gender: Gender.female, label: 'Femelle', icon: Icons.female),
    (gender: Gender.male, label: 'Mâle', icon: Icons.male),
  ];

  @override
  Widget build(BuildContext context) {
    final petName = context.select<OnboardingCubit, String>(
      (cubit) => cubit.state.petName.trim(),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.md,
      children: [
        Text(
          'Quel est le genre de $petName ?',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        BlocBuilder<OnboardingCubit, OnboardingState>(
          buildWhen: (previous, current) => previous.gender != current.gender,
          builder: (context, state) {
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                childAspectRatio: 1.1,
              ),
              itemCount: _genderOptions.length,
              itemBuilder: (context, index) {
                final option = _genderOptions[index];
                final isSelected = state.gender == option.gender;
                return GridTileWidget(
                  label: option.label,
                  isSelected: isSelected,
                  onTap: () =>
                      context.read<OnboardingCubit>().setGender(option.gender),
                  leading: Icon(
                    option.icon,
                    size: 32,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
