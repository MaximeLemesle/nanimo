import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/error_banner_widget.dart';
import 'package:nanimo/features/onboarding/presentation/cubit/onboarding_cubit.dart';

class PetRaceSelectorWidget extends StatelessWidget {
  const PetRaceSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final petName = context.select<OnboardingCubit, String>(
      (cubit) => cubit.state.petName.trim(),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.md,
      children: [
        Text(
          'Quel est la race de $petName ?',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        BlocBuilder<OnboardingCubit, OnboardingState>(
          buildWhen: (previous, current) =>
              previous.racesStatus != current.racesStatus ||
              previous.races != current.races ||
              previous.petRaceId != current.petRaceId,
          builder: (context, state) {
            switch (state.racesStatus) {
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
                      message: state.racesError ?? 'Une erreur est survenue.',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ButtonWidget(
                      label: 'Réessayer',
                      type: ButtonType.secondary,
                      onPressed: () =>
                          context.read<OnboardingCubit>().retryRaces(),
                    ),
                  ],
                );
              case ReferentialStatus.loaded:
                if (state.races.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    child: Text(
                      'Aucune race trouvée pour cette espèce.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                }
                return DropdownButtonFormField<String>(
                  isExpanded: true,
                  menuMaxHeight: 300,
                  initialValue: state.petRaceId,
                  hint: Text(
                    'Choisis une race',
                    style: textTheme.titleLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  dropdownColor: AppColors.backgroundSurface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  style: textTheme.titleLarge,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.backgroundSurface,
                    contentPadding: const EdgeInsets.all(AppSpacing.md),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: const BorderSide(
                        color: AppColors.backgroundStroke,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  items: state.races
                      .map(
                        (race) => DropdownMenuItem<String>(
                          value: race.petRaceId,
                          child: Text(race.raceName),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      context.read<OnboardingCubit>().setRace(value);
                    }
                  },
                );
            }
          },
        ),
      ],
    );
  }
}
