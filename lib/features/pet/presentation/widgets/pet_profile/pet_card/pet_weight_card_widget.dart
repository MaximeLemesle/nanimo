import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/rounded_border_widget.dart';
import 'package:nanimo/features/health/data/models/health_diary_weight_log_model.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/weight_chart_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_profile/pet_bottom_sheet/add_weight_bottom_sheet_widget.dart';

class PetWeightCardWidget extends StatelessWidget {
  final List<HealthDiaryWeightLogModel> logs;
  final WeightSubmit onWeightSubmitted;

  /// Floor of the date picker of the weight sheet.
  final DateTime birthdate;

  /// Drops the update button: the chart is still read, nothing is written.
  final bool readOnly;

  const PetWeightCardWidget({
    super.key,
    required this.logs,
    required this.birthdate,
    required this.onWeightSubmitted,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedBorderWidget(
      borderColor: AppColors.backgroundStroke,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.md,
        children: [
          Text(
            'Poids',
            style: AppTextStyles.textSmallBold
                .copyWith(color: AppColors.textSecondary),
          ),
          WeightChartWidget(logs: logs),
          if (!readOnly)
            ButtonWidget(
              label: 'Ajouter une pesée',
              icon: Icons.add,
              iconPosition: ButtonIcon.right,
              fullWidth: true,
              onPressed: () {
                BottomSheetWidget.show<void>(
                  context,
                  AddWeightBottomSheetWidget(
                    birthdate: birthdate,
                    onSubmit: onWeightSubmitted,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
