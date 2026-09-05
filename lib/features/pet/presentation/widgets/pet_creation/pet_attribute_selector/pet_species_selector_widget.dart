import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/error_banner_widget.dart';
import 'package:nanimo/core/widgets/species_icon_widget.dart';
import 'package:nanimo/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_creation/grid_tile_widget.dart';

class PetSpeciesSelectorWidget extends StatelessWidget {
  const PetSpeciesSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.md,
      children: [
        Text(
          'Quel est l’espèce de ton animal ?',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        BlocBuilder<OnboardingCubit, OnboardingState>(
          buildWhen: (previous, current) =>
              previous.speciesStatus != current.speciesStatus ||
              previous.species != current.species ||
              previous.petSpeciesId != current.petSpeciesId,
          builder: (context, state) {
            switch (state.speciesStatus) {
              case ReferentialStatus.idle:
              case ReferentialStatus.loading:
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                  child: Center(child: CircularProgressIndicator()),
                );
              case ReferentialStatus.error:
                return Column(
                  children: [
                    ErrorBannerWidget(
                      message: state.speciesError ?? 'Une erreur est survenue.',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ButtonWidget(
                      label: 'Réessayer',
                      type: ButtonType.secondary,
                      onPressed: () =>
                          context.read<OnboardingCubit>().fetchSpecies(),
                    ),
                  ],
                );
              case ReferentialStatus.loaded:
                if (state.species.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    child: Text(
                      'Aucune espèce disponible.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  );
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: state.species.length,
                  itemBuilder: (context, index) {
                    final species = state.species[index];
                    final isSelected =
                        state.petSpeciesId == species.petSpeciesId;
                    return GridTileWidget(
                      label: species.speciesName,
                      isSelected: isSelected,
                      onTap: () => context
                          .read<OnboardingCubit>()
                          .selectSpecies(species.petSpeciesId),
                      leading: SpeciesIconWidget(
                        portrait: PetPortrait.species(species.iconKey),
                        width: double.infinity,
                      ),
                    );
                  },
                );
            }
          },
        ),
      ],
    );
  }
}
