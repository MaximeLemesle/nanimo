import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';
import 'package:nanimo/features/pet/presentation/widgets/health_diary/health_card_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/health_diary/vaccine_status_badge_widget.dart';

/// Vaccines card: one row per vaccine with a status badge, plus an add action.
class VaccineListWidget extends StatelessWidget {
  final List<HealthDiaryVaccineModel> vaccines;
  final VoidCallback onAdd;
  final ValueChanged<HealthDiaryVaccineModel> onTapVaccine;

  const VaccineListWidget({
    super.key,
    required this.vaccines,
    required this.onAdd,
    required this.onTapVaccine,
  });

  @override
  Widget build(BuildContext context) {
    return HealthCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (vaccines.isEmpty)
            Text(
              'Aucun vaccin enregistré pour le moment.',
              style: AppTextStyles.textSmall
                  .copyWith(color: AppColors.textSecondary),
            )
          else
            for (var i = 0; i < vaccines.length; i++) ...[
              if (i > 0)
                const Divider(
                    height: AppSpacing.lg, color: AppColors.backgroundStroke),
              _buildRow(vaccines[i]),
            ],
          const SizedBox(height: AppSpacing.md),
          ButtonWidget(
            label: 'Ajouter un vaccin',
            type: ButtonType.secondary,
            iconPosition: ButtonIcon.left,
            icon: Icons.add,
            fullWidth: true,
            onPressed: onAdd,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(HealthDiaryVaccineModel vaccine) {
    final isDone = vaccineStatusFor(vaccine.nextDate) == VaccineStatus.done;
    final subtitle = isDone
        ? 'Dernier rappel le ${DateFormatter.date(vaccine.lastDate)}'
        : 'Prochain rappel le ${DateFormatter.date(vaccine.nextDate)}';

    return InkWell(
      onTap: () => onTapVaccine(vaccine),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vaccine.vaccineName, style: AppTextStyles.textBold),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle,
                    style: AppTextStyles.textLabel
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            VaccineStatusBadgeWidget(nextDate: vaccine.nextDate),
          ],
        ),
      ),
    );
  }
}
