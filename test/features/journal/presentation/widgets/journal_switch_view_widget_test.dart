import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/features/journal/presentation/cubit/journal_cubit.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_switch_view_widget.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        home: Scaffold(body: child),
      );

  testWidgets('shows the selected segment with inverted text color',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        JournalSwitchViewWidget(
          selectedViewMode: JournalViewMode.timeline,
          onChanged: (_) {},
        ),
      ),
    );

    final timelineText = tester.widget<Text>(find.text('timeline'));
    final calendarText = tester.widget<Text>(find.text('calendrier'));

    expect(timelineText.style?.color, AppColors.textInvert);
    expect(calendarText.style?.color, AppColors.textPrimary);
  });

  testWidgets('tapping another segment emits the selected view mode',
      (tester) async {
    JournalViewMode? selected;

    await tester.pumpWidget(
      wrap(
        JournalSwitchViewWidget(
          selectedViewMode: JournalViewMode.timeline,
          onChanged: (viewMode) => selected = viewMode,
        ),
      ),
    );

    await tester.tap(find.text('calendrier'));
    await tester.pumpAndSettle();

    expect(selected, JournalViewMode.calendar);
  });
}
