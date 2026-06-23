import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_profile/pet_card_widget/pet_card_item_widget.dart';

class PetCardWidget extends StatelessWidget {
  final String label;
  final List<PetCardItemWidget> items;
  final Color backgroundColor;
  final ButtonWidget? button;
  final bool isColumn;
  final Color? borderColor;

  const PetCardWidget({
    super.key,
    required this.label,
    required this.items,
    this.backgroundColor = AppColors.backgroundPrimary,
    this.button,
    this.isColumn = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg * 2),
          side: BorderSide(color: borderColor ?? Colors.transparent),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.textSmallBold
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          ..._buildItems(),
          if (button != null) ...[
            const SizedBox(height: AppSpacing.md),
            button!,
          ],
        ],
      ),
    );
  }

  List<Widget> _buildItems() {
    if (isColumn) {
      final column = <Widget>[];
      for (var i = 0; i < items.length; i++) {
        if (i > 0) {
          column.add(const SizedBox(height: AppSpacing.md));
        }
        column.add(items[i]);
      }
      return column;
    }

    final rows = <Widget>[];
    for (var i = 0; i < items.length; i += 2) {
      if (i > 0) {
        rows.add(const SizedBox(height: AppSpacing.lg));
      }
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: PetCardItemWidget(
                value: items[i].value,
                label: items[i].label,
                subValue: items[i].subValue,
                valueColor: items[i].valueColor,
              ),
            ),
            if (i + 1 < items.length)
              Expanded(
                child: PetCardItemWidget(
                  value: items[i + 1].value,
                  label: items[i + 1].label,
                  subValue: items[i + 1].subValue,
                  valueColor: items[i + 1].valueColor,
                ),
              ),
          ],
        ),
      );
    }
    return rows;
  }
}
