import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/widgets/date_field_widget.dart';
import 'package:nanimo/core/widgets/field_variant.dart';
import 'package:nanimo/core/widgets/pill_field_widget.dart';
import 'package:nanimo/core/widgets/time_field_widget.dart';

void main() {
  final value = DateTime(2026, 7, 17, 14, 30);

  Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('DateFieldWidget', () {
    testWidgets('field variant renders a labelled InputDecorator',
        (tester) async {
      await tester.pumpWidget(host(DateFieldWidget(
        label: 'Date de naissance',
        value: value,
        onChanged: (_) {},
      )));

      expect(find.byType(InputDecorator), findsOneWidget);
      expect(find.byType(PillFieldWidget), findsNothing);
      expect(find.text('Date de naissance'), findsOneWidget);
    });

    testWidgets('pill variant renders a tappable chip with a calendar icon',
        (tester) async {
      await tester.pumpWidget(host(DateFieldWidget(
        label: 'Date',
        value: value,
        onChanged: (_) {},
        variant: FieldVariant.pill,
      )));

      expect(find.byType(PillFieldWidget), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today_outlined), findsOneWidget);
      expect(find.byType(InputDecorator), findsNothing);
    });

    testWidgets('pill variant opens the date picker on tap', (tester) async {
      await tester.pumpWidget(host(DateFieldWidget(
        label: 'Date',
        value: value,
        onChanged: (_) {},
        variant: FieldVariant.pill,
      )));

      await tester.tap(find.byType(PillFieldWidget));
      await tester.pumpAndSettle();

      expect(find.byType(BottomSheet), findsOneWidget);
    });
  });

  group('TimeFieldWidget', () {
    testWidgets('pill variant renders a tappable chip with a clock icon',
        (tester) async {
      await tester.pumpWidget(host(TimeFieldWidget(
        label: 'Heure',
        value: value,
        onChanged: (_) {},
        variant: FieldVariant.pill,
      )));

      expect(find.byType(PillFieldWidget), findsOneWidget);
      expect(find.byIcon(Icons.schedule_outlined), findsOneWidget);
    });

    testWidgets('pill variant opens the time picker on tap', (tester) async {
      await tester.pumpWidget(host(TimeFieldWidget(
        label: 'Heure',
        value: value,
        onChanged: (_) {},
        variant: FieldVariant.pill,
      )));

      await tester.tap(find.byType(PillFieldWidget));
      await tester.pumpAndSettle();

      expect(find.byType(BottomSheet), findsOneWidget);
    });
  });
}
