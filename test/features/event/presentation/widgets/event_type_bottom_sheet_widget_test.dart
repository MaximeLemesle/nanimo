import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/event/data/models/event_type_model.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/create_event_bottom_sheet/event_type_bottom_sheet_widget.dart';

const _types = [
  EventTypeModel(
    eventTypeId: 't-balade',
    name: 'Balade',
    code: 'balade',
    isPremium: false,
  ),
  EventTypeModel(
    eventTypeId: 't-calin',
    name: 'Câlin',
    code: 'calin',
    isPremium: false,
  ),
];

void main() {
  Widget harness(Future<void> Function(BuildContext) onTap) => MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => onTap(context),
              child: const Text('open'),
            ),
          ),
        ),
      );

  testWidgets('lists every type and returns the tapped id', (tester) async {
    String? result;
    await tester.pumpWidget(harness((context) async {
      result = await EventTypeBottomSheetWidget.show(
        context,
        types: _types,
        selectedTypeId: 't-balade',
      );
    }));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Choisir un type'), findsOneWidget);
    expect(find.text('Balade'), findsOneWidget);
    expect(find.text('Câlin'), findsOneWidget);

    await tester.tap(find.text('Câlin'));
    await tester.pumpAndSettle();

    expect(result, 't-calin');
  });

  testWidgets('shows an empty message when there is no type', (tester) async {
    await tester.pumpWidget(harness((context) async {
      await EventTypeBottomSheetWidget.show(
        context,
        types: const [],
        selectedTypeId: null,
      );
    }));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Aucun type disponible pour le moment.'), findsOneWidget);
  });
}
