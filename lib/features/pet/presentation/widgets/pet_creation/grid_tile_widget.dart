import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/widgets/rounded_border_widget.dart';

class GridTileWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget? leading;

  const GridTileWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return RoundedBorderWidget(
      onTap: onTap,
      backgroundColor:
          isSelected ? AppColors.primary100 : AppColors.backgroundSurface,
      borderColor: isSelected ? AppColors.primary : AppColors.backgroundStroke,
      borderWidth: 2,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leading != null) ...[
            Expanded(child: Center(child: leading!)),
            const SizedBox(height: AppSpacing.md),
          ],
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}
