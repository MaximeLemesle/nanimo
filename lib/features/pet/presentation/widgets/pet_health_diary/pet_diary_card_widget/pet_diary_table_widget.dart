import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';

class PetDiaryRow {
  final String label;
  final String? value;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const PetDiaryRow({
    required this.label,
    this.value,
    this.subtitle,
    this.trailing,
    this.onTap,
  });
}

class PetDiaryTableWidget extends StatelessWidget {
  final List<PetDiaryRow> rows;
  final String? emptyLabel;

  const PetDiaryTableWidget({
    super.key,
    required this.rows,
    this.emptyLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty && emptyLabel != null) {
      return Text(
        emptyLabel!,
        style: AppTextStyles.textSmall.copyWith(color: AppColors.textSecondary),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0)
            const Divider(
              height: AppSpacing.lg,
              color: AppColors.backgroundStroke,
            ),
          _buildRow(rows[i]),
        ],
      ],
    );
  }

  Widget _buildRow(PetDiaryRow row) {
    final hasSubtitle = row.subtitle != null;

    final label = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(row.label, style: AppTextStyles.textBold),
        if (hasSubtitle) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            row.subtitle!,
            style: AppTextStyles.textLabel
                .copyWith(color: AppColors.textSecondary),
          ),
        ],
      ],
    );

    final content = Row(
      crossAxisAlignment:
          hasSubtitle ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Expanded(child: label),
        const SizedBox(width: AppSpacing.md),
        if (row.trailing != null)
          row.trailing!
        else if (row.value != null)
          Text(
            row.value!,
            textAlign: TextAlign.right,
            style: AppTextStyles.text.copyWith(color: AppColors.textSecondary),
          ),
      ],
    );

    if (row.onTap == null) return content;

    return InkWell(
      onTap: row.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: content,
      ),
    );
  }
}
