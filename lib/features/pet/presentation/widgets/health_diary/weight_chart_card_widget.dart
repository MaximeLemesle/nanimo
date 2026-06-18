import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/features/health/data/models/health_diary_weight_log_model.dart';
import 'package:nanimo/features/pet/presentation/widgets/health_diary/health_card_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/health_diary/weight_chart_widget.dart';

class WeightChartCardWidget extends StatelessWidget {
  final List<HealthDiaryWeightLogModel> logs;
  final VoidCallback onUpdate;

  const WeightChartCardWidget({
    super.key,
    required this.logs,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return HealthCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRangeChip(),
          const SizedBox(height: AppSpacing.md),
          WeightChartWidget(logs: logs),
          const SizedBox(height: AppSpacing.md),
          _buildSummaryRow(
            'Poids naissance',
            logs.isEmpty ? '—' : _formatWeight(logs.first.weight),
          ),
          const Divider(
              height: AppSpacing.lg, color: AppColors.backgroundStroke),
          _buildSummaryRow(
            'Dernier poids',
            logs.isEmpty ? '—' : _formatWeight(logs.last.weight),
          ),
          const SizedBox(height: AppSpacing.md),
          ButtonWidget(
            label: 'Mettre à jour le poids',
            icon: Icons.add,
            iconPosition: ButtonIcon.right,
            fullWidth: true,
            onPressed: onUpdate,
          ),
        ],
      ),
    );
  }

  Widget _buildRangeChip() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.backgroundStroke),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('6 derniers mois', style: AppTextStyles.textSmall),
          const SizedBox(width: AppSpacing.xs),
          const Icon(Icons.keyboard_arrow_down, size: 18),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.textBold),
        Text(value, style: AppTextStyles.numberSmall),
      ],
    );
  }

  String _formatWeight(double weight) =>
      '${weight.toStringAsFixed(1).replaceAll('.', ',')} kg';
}
