import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/features/onboarding/presentation/cubit/onboarding_cubit.dart';

class CreatePetStepThreeWidget extends StatefulWidget {
  const CreatePetStepThreeWidget({super.key});

  @override
  State<CreatePetStepThreeWidget> createState() => _StepThreeWidgetState();
}

class _StepThreeWidgetState extends State<CreatePetStepThreeWidget> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Création réussie !',
                textAlign: TextAlign.center,
                style: textTheme.displaySmall?.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              BlocBuilder<OnboardingCubit, OnboardingState>(
                buildWhen: (p, c) => p.petName != c.petName,
                builder: (context, state) {
                  final name = state.petName.trim();
                  return Text(
                    name.isEmpty
                        ? 'Le profil de ton compagnon est prêt'
                        : 'Le profil de $name est prêt',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              const _AvatarPreview(),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: math.pi / 2,
            blastDirectionality: BlastDirectionality.explosive,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            maxBlastForce: 20,
            minBlastForce: 8,
            gravity: 0.2,
            colors: const [
              AppColors.primary,
              AppColors.secondary,
              AppColors.tertiary,
              AppColors.primary300,
              AppColors.tertiary300,
            ],
          ),
        ),
      ],
    );
  }
}

/// Shows the avatar automatically derived from the selected species.
class _AvatarPreview extends StatelessWidget {
  const _AvatarPreview();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      buildWhen: (p, c) =>
          p.petSpeciesId != c.petSpeciesId || p.species != c.species,
      builder: (context, state) {
        final matches = state.species
            .where((s) => s.petSpeciesId == state.petSpeciesId)
            .toList();
        if (matches.isEmpty) return const SizedBox.shrink();
        final iconKey = matches.first.iconKey;
        return Center(
          child: ClipOval(
            child: Image.asset(
              'assets/icons/species/$iconKey.png',
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
