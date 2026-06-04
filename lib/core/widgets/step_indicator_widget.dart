import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';

class StepIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicatorWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final isActive = (index + 1) <= currentStep;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.only(
              right: index == totalSteps - 1 ? 0 : AppSpacing.xs,
            ),
            height: 4,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.backgroundStroke,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}
