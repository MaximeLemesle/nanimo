import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
      expect(find.byIcon(Icons.calendar_today_outlined), findsOneWidget);
      expect(find.byIcon(Icons.schedule_outlined), findsOneWidget);
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
}
