import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/features/journal/presentation/cubit/journal_cubit.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_picker_widget.dart';

class JournalFilterBottomSheetWidget extends StatelessWidget {
  const JournalFilterBottomSheetWidget({super.key});

  static Future<void> show(BuildContext context) {
    final cubit = context.read<JournalCubit>();
    return BottomSheetWidget.show<void>(
      context,
      BlocProvider.value(
        value: cubit,
        child: const JournalFilterBottomSheetWidget(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JournalCubit, JournalState>(
      builder: (context, state) {
        final cubit = context.read<JournalCubit>();

        return BottomSheetWidget(
          title: 'Choisir un animal',
          scrollable: true,
          action: state.hasActiveFilters
              ? SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: cubit.clearFilters,
                    child: Text(
                      'Réinitialiser les filtres',
                      style: AppTextStyles.textBold
                          .copyWith(color: AppColors.primary),
                    ),
                  ),
                )
              : null,
          children: [
            PetPickerWidget.multi(
              pets: state.pets,
              iconsKey: state.iconsKey,
              selectedPetIds: state.selectedPetIds,
              onToggled: cubit.togglePetFilter,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text("Choisir un type\nd’évènement", style: AppTextStyles.title02),
            const SizedBox(height: AppSpacing.lg),
            for (final type in state.types)
              InkWell(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                onTap: () => cubit.toggleTypeFilter(type.eventTypeId),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color:
                              state.selectedTypeIds.contains(type.eventTypeId)
                                  ? AppColors.primary
                                  : AppColors.backgroundSurface,
                          borderRadius: BorderRadius.circular(AppRadius.sm / 2),
                          border: Border.all(
                            color:
                                state.selectedTypeIds.contains(type.eventTypeId)
                                    ? AppColors.primary
                                    : AppColors.backgroundStroke,
                            width: 2,
                          ),
                        ),
                        child: state.selectedTypeIds.contains(type.eventTypeId)
                            ? const Icon(Icons.check,
                                size: 16, color: AppColors.textInvert)
                            : null,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          type.name,
                          style: AppTextStyles.textBold.copyWith(
                            color:
                                state.selectedTypeIds.contains(type.eventTypeId)
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
