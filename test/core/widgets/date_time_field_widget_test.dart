import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/date_field_widget.dart';
import 'package:nanimo/core/widgets/date_time_field_widget.dart';
import 'package:nanimo/core/widgets/pill_field_widget.dart';
import 'package:nanimo/core/widgets/time_field_widget.dart';

void main() {
  final value = DateTime(2026, 7, 17, 22, 57);

  Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('DateTimeFieldWidget', () {
    testWidgets('shows date and time inside a single box', (tester) async {
      await tester.pumpWidget(host(DateTimeFieldWidget(
        value: value,
        onDateChanged: (_) {},
        onTimeChanged: (_) {},
      )));

      expect(find.byType(DateFieldWidget), findsOneWidget);
      expect(find.byType(TimeFieldWidget), findsOneWidget);
      expect(find.text('17/07/2026'), findsOneWidget);
      expect(find.text('22:57'), findsOneWidget);
    });

    testWidgets('embedded pills drop their own border', (tester) async {
      await tester.pumpWidget(host(DateTimeFieldWidget(
        value: value,
        onDateChanged: (_) {},
        onTimeChanged: (_) {},
      )));

      final pills = tester.widgetList<PillFieldWidget>(
        find.byType(PillFieldWidget),
      );
      expect(pills, hasLength(2));
      expect(pills.every((p) => p.showBorder == false), isTrue);
    });

    testWidgets('tapping the date half opens a picker', (tester) async {
      await tester.pumpWidget(host(DateTimeFieldWidget(
        value: value,
        onDateChanged: (_) {},
        onTimeChanged: (_) {},
      )));

      await tester.tap(find.byType(DateFieldWidget));
      await tester.pumpAndSettle();

      expect(find.byType(BottomSheet), findsOneWidget);
    });

    testWidgets('tapping the time half opens a picker', (tester) async {
      await tester.pumpWidget(host(DateTimeFieldWidget(
        value: value,
        onDateChanged: (_) {},
        onTimeChanged: (_) {},
      )));

      await tester.tap(find.byType(TimeFieldWidget));
      await tester.pumpAndSettle();

      expect(find.byType(BottomSheet), findsOneWidget);
    });
  });

  /// Regression (NAN-057): the box split itself in two equal halves, which left
  /// the date without the room it needs, and it wrapped onto a second line.
  group('DateTimeFieldWidget layout', () {
    /// Reproduces the create-event header: page padding, back button, then the
    /// field filling what is left of the row.
    Widget header(double screenWidth, double textScale) => MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
          child: MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: screenWidth,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Row(
                    children: [
                      const SizedBox(width: 24),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: DateTimeFieldWidget(
                          value: value,
                          onDateChanged: (_) {},
                          onTimeChanged: (_) {},
                          textStyle: AppTextStyles.textBold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

    for (final screenWidth in [375.0, 393.0]) {
      for (final textScale in [1.0, 1.3, 1.6]) {
        testWidgets(
          'keeps the date on one line at ${screenWidth.toInt()}pt / x$textScale text',
          (tester) async {
            await tester.pumpWidget(header(screenWidth, textScale));

            /// Both halves share a text style, so a taller date means it wrapped.
            final date = tester.getSize(find.text('17/07/2026'));
            final time = tester.getSize(find.text('22:57'));

            expect(
              date.height,
              time.height,
              reason: 'date is ${date.height}px tall vs ${time.height}px for the '
                  'single-line time — it wrapped',
            );
          },
        );
      }
    }

    testWidgets('gives the date more room than the time', (tester) async {
      await tester.pumpWidget(header(375, 1));

      final date = tester.getSize(find.byType(DateFieldWidget));
      final time = tester.getSize(find.byType(TimeFieldWidget));

      expect(date.width, greaterThan(time.width));
    });

    /// Without a value both halves fall back to a placeholder. A sentence there
    /// would let the content-sized time half swallow the row.
    testWidgets('falls back to compact labels when empty', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 375 - AppSpacing.lg * 2,
              child: DateTimeFieldWidget(
                value: null,
                onDateChanged: (_) {},
                onTimeChanged: (_) {},
                textStyle: AppTextStyles.textBold,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Date'), findsOneWidget);
      expect(find.text('Heure'), findsOneWidget);
      expect(find.textContaining('Sélectionner'), findsNothing);

      final date = tester.getSize(find.byType(DateFieldWidget));
      final time = tester.getSize(find.byType(TimeFieldWidget));
      expect(date.width, greaterThan(time.width));
    });
  });
}
