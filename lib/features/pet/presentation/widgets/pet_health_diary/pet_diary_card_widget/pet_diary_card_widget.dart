import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/rounded_border_widget.dart';

class PetDiaryCardWidget extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const PetDiaryCardWidget({
    super.key,
    required this.title,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.textSmallBold
              .copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.sm),
        RoundedBorderWidget(
          borderColor: AppColors.backgroundStroke,
          child: Column(children: children),
        ),
      ],
    );
  }
}
