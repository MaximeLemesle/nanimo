import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';

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
    return InkWell(
      onTap: onTap,
      customBorder: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg * 2),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: ShapeDecoration(
          color:
              isSelected ? AppColors.primary100 : AppColors.backgroundSurface,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg * 2),
            side: BorderSide(
              color:
                  isSelected ? AppColors.primary : AppColors.backgroundStroke,
              width: 2,
            ),
          ),
        ),
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
      ),
    );
  }
}
