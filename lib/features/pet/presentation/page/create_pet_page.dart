import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/step_indicator_widget.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nanimo/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_creation_cubit.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_creation/pet_creation_step_one_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_creation/pet_creation_step_three_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_creation/pet_creation_step_two_widget.dart';

class CreatePetPage extends StatefulWidget {
  const CreatePetPage({super.key});

  @override
  State<CreatePetPage> createState() => _CreatePetPageState();
}

class _CreatePetPageState extends State<CreatePetPage> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    final initialStep = context.read<OnboardingCubit>().state.currentStep;
    _pageController = PageController(initialPage: initialStep - 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool _isInApp(BuildContext context) =>
      context.read<AuthCubit>().state.status == AuthStatus.authenticated;

  void _handleBack(BuildContext context, OnboardingState state) {
    if (state.currentStep == 1) {
      context.read<OnboardingCubit>().reset();
      if (_isInApp(context)) {
        context.pop();
      } else {
        context.go(RouteNames.onboarding);
      }
    } else {
      context.read<OnboardingCubit>().previousStep();
    }
  }

  /// Go to the next step or the signup page if it's the last step
  void _handleNext(BuildContext context, OnboardingState state) {
    if (state.currentStep < 3) {
      context.read<OnboardingCubit>().nextStep();
      return;
    }

    context.read<PetCreationCubit>().prepare(
          petName: state.petName.trim(),
          petSpeciesId: state.petSpeciesId!,
          petRaceId: state.petRaceId!,
          gender: state.gender!,
          birthdate: state.birthdate!,
        );
    if (_isInApp(context)) {
      context.read<OnboardingCubit>().reset();
      context.go(RouteNames.pet);
    } else {
      context.go(RouteNames.signup);
    }
  }

  bool _isNextEnabled(OnboardingState state) {
    switch (state.currentStep) {
      case 1:
        return state.canGoToStep2;
      case 2:
        return state.canGoToStep3;
      case 3:
        return state.canFinish;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listenWhen: (previous, current) =>
          previous.currentStep != current.currentStep,
      listener: (context, state) {
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            state.currentStep - 1,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOut,
          );
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) return;
            _handleBack(context, state);
          },
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _handleBack(context, state),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        color: AppColors.textPrimary,
                      ),
                      Expanded(
                        child: StepIndicatorWidget(
                          currentStep: state.currentStep,
                          totalSteps: 3,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: const [
                        PetCreationStepOneWidget(),
                        PetCreationStepTwoWidget(),
                        PetCreationStepThreeWidget(),
                      ],
                    ),
                  ),

                  /// Button next step
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: ButtonWidget(
                      label: state.currentStep == 3
                          ? (_isInApp(context) ? 'Créer' : 'Créer mon compte')
                          : 'Continuer',
                      onPressed: _isNextEnabled(state)
                          ? () => _handleNext(context, state)
                          : null,
                      state: _isNextEnabled(state)
                          ? ButtonState.normal
                          : ButtonState.disabled,
                      fullWidth: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
