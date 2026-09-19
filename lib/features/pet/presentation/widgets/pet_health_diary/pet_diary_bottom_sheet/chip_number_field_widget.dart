import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/chip_number.dart';
import 'package:nanimo/core/widgets/text_field_widget.dart';

/// Shared by the diary creation sheet and the health info edit sheet, so both
/// carry the same rule.
class ChipNumberFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onChanged;

  const ChipNumberFieldWidget({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final digits = controller.text.trim();
    final warning = ChipNumber.warningFor(digits);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldWidget(
          controller: controller,
          label: 'Numéro de puce',
          hint: '15 chiffres',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(ChipNumber.maxLength),
          ],
          onChanged: (_) => onChanged?.call(),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: warning == null
                  ? const SizedBox.shrink()
                  : Text(
                      warning,
                      style: AppTextStyles.textSmall
                          .copyWith(color: AppColors.secondary600),
                    ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              '${digits.length}/${ChipNumber.maxLength}',
              style: AppTextStyles.textSmall
                  .copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }
}
