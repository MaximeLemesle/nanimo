import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/widgets/pet_avatar_widget.dart';
import 'package:nanimo/features/onboarding/presentation/cubit/onboarding_cubit.dart';

class PetCreationStepThreeWidget extends StatefulWidget {
  const PetCreationStepThreeWidget({super.key});

  @override
  State<PetCreationStepThreeWidget> createState() => _StepThreeWidgetState();
}

class _StepThreeWidgetState extends State<PetCreationStepThreeWidget> {
  static const _confettiColors = [
    AppColors.primary,
    AppColors.secondary,
    AppColors.tertiary,
    AppColors.primary300,
    AppColors.tertiary300,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _launchConfetti();
    });
  }

  void _launchConfetti() {
    Confetti.launch(
      context,
      options: const ConfettiOptions(
        particleCount: 60,
        angle: 60,
        spread: 55,
        x: 0,
        y: 0.7,
        colors: _confettiColors,
      ),
    );
    Confetti.launch(
      context,
      options: const ConfettiOptions(
        particleCount: 60,
        angle: 120,
        spread: 55,
        x: 1,
        y: 0.7,
        colors: _confettiColors,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final petName = context.select<OnboardingCubit, String>(
      (cubit) => cubit.state.petName.trim(),
    );
    final portrait = context.select<OnboardingCubit, PetPortrait?>(
      (cubit) => cubit.state.portrait,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - AppSpacing.lg * 2,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Félicitations !',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const Spacer(),
                  if (portrait != null)
                    Center(
                      child: PetAvatarWidget(
                        portrait: portrait,
                        size: PetAvatarSize.xlarge,
                      ),
                    ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    petName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Text(
                    'rejoint tes Nanimos !',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
