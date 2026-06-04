import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/features/onboarding/presentation/cubit/onboarding_cubit.dart';

class PetBirthdateSelectorWidget extends StatelessWidget {
  const PetBirthdateSelectorWidget({super.key});

  String _format(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

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
          'Quel est la date de naissance de $petName ?',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        BlocBuilder<OnboardingCubit, OnboardingState>(
          buildWhen: (previous, current) =>
              previous.birthdate != current.birthdate,
          builder: (context, state) {
            final hasDate = state.birthdate != null;
            return InkWell(
              onTap: () async {
                final now = DateTime.now();
                var picked = state.birthdate ?? now;

                await showModalBottomSheet<void>(
                  context: context,
                  builder: (context) {
                    return SizedBox(
                      height: 350,
                      width: double.infinity,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        dateOrder: DatePickerDateOrder.dmy,
                        initialDateTime: picked,
                        minimumDate: DateTime(now.year - 40),
                        maximumDate: now,
                        onDateTimeChanged: (date) => picked = date,
                      ),
                    );
                  },
                );

                if (context.mounted) {
                  context.read<OnboardingCubit>().setBirthdate(picked);
                }
              },
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: AppColors.backgroundSurface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: hasDate
                        ? AppColors.primary
                        : AppColors.backgroundStroke,
                    width: hasDate ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color:
                          hasDate ? AppColors.primary : AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      hasDate
                          ? _format(state.birthdate!)
                          : 'Sélectionner une date',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: hasDate
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
