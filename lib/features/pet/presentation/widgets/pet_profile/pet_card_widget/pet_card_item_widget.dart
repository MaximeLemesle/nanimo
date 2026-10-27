import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';

class PetCardItemWidget extends StatelessWidget {
  final String label;
  final String value;
  final String? subValue;
  final Color? valueColor;
  final bool showCheckbox;
  final bool isChecked;
  final ValueChanged<bool?>? onCheckChanged;

  /// Makes the item a row that opens something, marked by a chevron.
  final VoidCallback? onTap;

  const PetCardItemWidget({
    super.key,
    required this.label,
    required this.value,
    this.subValue,
    this.valueColor,
    this.showCheckbox = false,
    this.isChecked = false,
    this.onCheckChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (onTap == null) return _content();
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(child: _content()),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  Widget _content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showCheckbox)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: AppSpacing.lg,
                height: AppSpacing.lg,
                child: Checkbox(
                  value: isChecked,
                  onChanged: onCheckChanged,
                  activeColor: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                value,
                style: AppTextStyles.title03.copyWith(
                  color: valueColor,
                  decoration: isChecked ? TextDecoration.lineThrough : null,
                ),
              ),
            ],
          )
        else
          Text(
            value,
            style: AppTextStyles.title03.copyWith(color: valueColor),
          ),
        if (subValue != null)
          Text(
            subValue!,
            style: AppTextStyles.textSmallBold
                .copyWith(color: AppColors.textSecondary),
          ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style:
              AppTextStyles.textLabel.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
