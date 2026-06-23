import 'package:flutter/cupertino.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';

class HealthDiarySectionWidget extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget? child;

  const HealthDiarySectionWidget({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(label, style: AppTextStyles.text)),
            CupertinoSwitch(
              value: value,
              onChanged: onChanged,
              activeTrackColor: AppColors.primary,
            ),
          ],
        ),
        if (value && child != null) ...[
          const SizedBox(height: AppSpacing.sm),
          child!,
        ],
      ],
    );
  }
}
