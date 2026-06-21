import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';

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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: ShapeDecoration(
            color: AppColors.backgroundSurface,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg * 2),
              side: BorderSide(color: AppColors.backgroundStroke),
            ),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}
