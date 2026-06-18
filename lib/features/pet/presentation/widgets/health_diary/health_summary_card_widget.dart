import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/features/pet/presentation/widgets/health_diary/health_card_widget.dart';

/// Récapitulatif card: label/value rows separated by dividers, with an
/// edit affordance for the editable diary fields.
class HealthSummaryCardWidget extends StatelessWidget {
  final List<({String label, String value})> rows;
  final VoidCallback onEdit;

  const HealthSummaryCardWidget({
    super.key,
    required this.rows,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return HealthCardWidget(
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0)
              const Divider(height: AppSpacing.lg, color: AppColors.backgroundStroke),
            _buildRow(rows[i]),
          ],
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Modifier'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(({String label, String value}) row) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(row.label, style: AppTextStyles.textBold),
        ),
        const SizedBox(width: AppSpacing.md),
        Text(
          row.value,
          textAlign: TextAlign.right,
          style: AppTextStyles.text.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
