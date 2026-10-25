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

  /// [safeArea] false lets a scrolling sheet run under the home indicator;
  /// it then pads its own content with `MediaQuery.paddingOf`.
  static Future<T?> show<T>(BuildContext context, Widget child,
      {bool safeArea = true}) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.backgroundSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (sheetContext) {
        // Under the tab bar's Scaffold the inherited insets are the bar's and a
        // body already lifted over the keyboard: the view's own are the truth.
        final view = MediaQueryData.fromView(View.of(sheetContext));
        final inherited = MediaQuery.of(sheetContext);
        // The keyboard inset is already animated by iOS: following it frame by
        // frame keeps the sheet glued to the keyboard, as a native sheet is.
        return Padding(
          padding: EdgeInsets.only(bottom: inherited.viewInsets.bottom),
          child: MediaQuery(
            data: inherited.copyWith(
              viewInsets: view.viewInsets,
              padding: inherited.padding.copyWith(bottom: view.padding.bottom),
            ),
            child: SafeArea(top: false, bottom: safeArea, child: child),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Always the same tree: swapping it when the keyboard opens would
          // recreate the focused field and close the keyboard (NAN-118).
          Flexible(
            child: SingleChildScrollView(
              physics: scrollable || keyboardOpen
                  ? null
                  : const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.title02),
                  const SizedBox(height: AppSpacing.lg),
                  ...children,
                ],
              ),
            ),
          ),
          // Outside the scroll view: the fields scroll, the action stays whole.
          if (action != null) ...[
            const SizedBox(height: AppSpacing.lg),
            action!,
          ],
        ],
      ),
    );
  }
}
