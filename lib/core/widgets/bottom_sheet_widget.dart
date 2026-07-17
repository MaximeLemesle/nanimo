import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/config/theme/app_colors.dart';

/// Bottom padding a sheet's content needs to stay readable.
///
/// Sheets are pushed onto the shell's Navigator, while the nav bar is the shell
/// Scaffold's `bottomNavigationBar` — so the bar paints *over* the sheet and
/// would hide whatever sits at its bottom. Content must clear it. An open
/// keyboard already lifts the content past the bar, so the two never add up.
double bottomInsetFor(BuildContext context) {
  final keyboardInset = MediaQuery.of(context).viewInsets.bottom;
  return keyboardInset > 0
      ? keyboardInset + AppSpacing.lg
      : AppSpacing.bottomBarInset;
}

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
      builder: (_) => child,
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
        bottom: bottomInsetFor(context),
      ),
      child: scrollable ? SingleChildScrollView(child: column) : column,
    );
  }
}
