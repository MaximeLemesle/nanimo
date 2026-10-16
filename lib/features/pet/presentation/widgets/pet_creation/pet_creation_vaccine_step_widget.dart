import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/diary_date_bounds.dart';
import 'package:nanimo/core/utils/vaccine_schedule.dart';
import 'package:nanimo/core/widgets/chip_widget.dart';
import 'package:nanimo/core/widgets/date_field_widget.dart';
import 'package:nanimo/core/widgets/nanimo_text_field_widget.dart';
import 'package:nanimo/features/onboarding/presentation/cubit/onboarding_cubit.dart';

/// Onboarding only (NAN-105): the owner leaves with a first reminder set.
class PetCreationVaccineStepWidget extends StatefulWidget {
  const PetCreationVaccineStepWidget({super.key});

  @override
  State<PetCreationVaccineStepWidget> createState() => _PetCreationVaccineStepWidgetState();
}

class _PetCreationVaccineStepWidgetState extends State<PetCreationVaccineStepWidget> {
  late final TextEditingController _nameController =
      TextEditingController(text: context.read<OnboardingCubit>().state.vaccineName);

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _pickSuggestion(String name) {
    _nameController.text = name;
    context.read<OnboardingCubit>().setVaccineName(name);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final cubit = context.read<OnboardingCubit>();
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Où en sont ses vaccins ?', style: textTheme.displaySmall),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Note son dernier vaccin, on te rappellera le prochain.',
                style: AppTextStyles.text.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xl),
              NanimoTextFieldWidget(
                controller: _nameController,
                label: 'Quel vaccin ?',
                hint: 'Rage, CHPPiL...',
                textInputAction: TextInputAction.done,
                onChanged: cubit.setVaccineName,
              ),
              if (state.vaccineSuggestions.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final name in state.vaccineSuggestions)
                      ChipWidget(
                        label: name,
                        isSelected: state.vaccineName == name,
                        onTap: () => _pickSuggestion(name),
                      ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              DateFieldWidget(
                label: 'Date du vaccin',
                value: state.vaccineDate,
                firstDate: state.birthdate,
                lastDate: DiaryDateBounds.openEnd(),
                onChanged: cubit.setVaccineDate,
              ),
              if (state.vaccineAsksNext) ...[
                const SizedBox(height: AppSpacing.lg),
                Text('Quand est le prochain rappel ?', style: AppTextStyles.textBold),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final months in VaccineSchedule.intervals)
                      ChipWidget(
                        label: 'Dans $months mois',
                        isSelected: !state.vaccineNextUnknown && state.vaccineMonths == months,
                        onTap: () => cubit.setVaccineNext(months: months),
                      ),
                    ChipWidget(
                      label: 'Je ne sais pas',
                      isSelected: state.vaccineNextUnknown,
                      onTap: () => cubit.setVaccineNext(),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
