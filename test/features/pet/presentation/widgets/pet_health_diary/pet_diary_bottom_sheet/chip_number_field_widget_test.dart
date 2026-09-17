import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/utils/chip_number.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/chip_number_field_widget.dart';

void main() {
  late TextEditingController controller;

  setUp(() => controller = TextEditingController());
  tearDown(() => controller.dispose());

  Widget harness() {
    return MaterialApp(
      home: Scaffold(
        body: StatefulBuilder(
          builder: (context, setState) => ChipNumberFieldWidget(
            controller: controller,
            onChanged: () => setState(() {}),
          ),
        ),
      ),
    );
  }

  testWidgets('shows the expected length and an empty counter at rest',
      (tester) async {
    await tester.pumpWidget(harness());

    expect(find.text('15 chiffres'), findsOneWidget);
    expect(find.text('0/15'), findsOneWidget);
    expect(find.text(ChipNumber.incompleteMessage), findsNothing);
  });

  testWidgets('counts the digits typed and warns while incomplete',
      (tester) async {
    await tester.pumpWidget(harness());

    await tester.enterText(find.byType(TextField), '25026850000000');
    await tester.pumpAndSettle();

    expect(find.text('14/15'), findsOneWidget);
    expect(find.text(ChipNumber.incompleteMessage), findsOneWidget);
  });

  testWidgets('drops the warning once the number is complete', (tester) async {
    await tester.pumpWidget(harness());

    await tester.enterText(find.byType(TextField), '250268500000001');
    await tester.pumpAndSettle();

    expect(find.text('15/15'), findsOneWidget);
    expect(find.text(ChipNumber.incompleteMessage), findsNothing);
  });

  testWidgets('keeps only digits and stops at fifteen', (tester) async {
    await tester.pumpWidget(harness());

    await tester.enterText(find.byType(TextField), '250-268 500000001999');
    await tester.pumpAndSettle();

    expect(controller.text, '250268500000001');
    expect(find.text('15/15'), findsOneWidget);
  });
}
