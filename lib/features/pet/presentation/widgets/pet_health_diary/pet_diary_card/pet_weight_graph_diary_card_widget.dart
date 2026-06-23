import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/utils/weight_formatter.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/features/health/data/models/health_diary_weight_log_model.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_details_cubit.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_card_widget/pet_diary_card_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_card_widget/pet_diary_table_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/weight_chart_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_profile/pet_bottom_sheet/add_weight_bottom_sheet_widget.dart';

class PetWeightGraphDiaryCardWidget extends StatelessWidget {
  final List<HealthDiaryWeightLogModel> weightLogs;

  const PetWeightGraphDiaryCardWidget({super.key, required this.weightLogs});

  @override
  Widget build(BuildContext context) {
    return PetDiaryCardWidget(
      title: 'Évolution du poids',
      children: [
        WeightChartWidget(logs: weightLogs),
        const SizedBox(height: AppSpacing.md),
        PetDiaryTableWidget(
          rows: [
            PetDiaryRow(
              label: 'Poids naissance',
              value: weightLogs.isEmpty
                  ? '—'
                  : WeightFormatter.label(weightLogs.first.weight),
            ),
            PetDiaryRow(
              label: 'Dernier poids',
              value: weightLogs.isEmpty
                  ? '—'
                  : WeightFormatter.label(weightLogs.last.weight),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ButtonWidget(
          label: 'Mettre à jour le poids',
          icon: Icons.add,
          iconPosition: ButtonIcon.right,
          fullWidth: true,
          onPressed: () {
            BottomSheetWidget.show<void>(
              context,
              AddWeightBottomSheetWidget(
                onSubmit: context.read<PetDetailsCubit>().addWeightLog,
              ),
            );
          },
        ),
      ],
    );
  }
}
