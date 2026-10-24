import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/config/theme/app_colors.dart';

class BottomSheetWidget extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget? action;
  final bool scrollable;

  const BottomSheetWidget({
    super.key,
    required this.title,
    required this.children,
    this.action,
    this.scrollable = false,
  });

  static Future<T?> show<T>(BuildContext context, Widget child) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (sheetContext) => AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom),
        child: SafeArea(top: false, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final column = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.title02),
        const SizedBox(height: AppSpacing.lg),
        ...children,
        if (action != null) ...[
          const SizedBox(height: AppSpacing.lg),
          action!,
        ],
      ],
    );

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: AppSpacing.xxl,
      ),
      // Always the same tree: swapping it when the keyboard opens would
      // recreate the focused field and close the keyboard (NAN-118).
      child: SingleChildScrollView(
        physics: scrollable || MediaQuery.viewInsetsOf(context).bottom > 0
            ? null
            : const NeverScrollableScrollPhysics(),
        child: column,
      ),
    );
  }
}
