import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/add_vaccine_bottom_sheet_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/add_vet_visit_bottom_sheet_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_profile/pet_bottom_sheet/add_weight_bottom_sheet_widget.dart';

/// NAN-118: the keyboard inset must not rebuild the sheet's subtree, or the
/// focused field is recreated and the keyboard closes as soon as it opens.
void main() {
  final birthdate = DateTime(2020, 1, 1);

  final sheets = <String, Widget>{
    'plain sheet': const BottomSheetWidget(title: 'Titre', children: [TextField()]),
    'add vaccine': AddVaccineBottomSheetWidget(
      birthdate: birthdate,
      onSubmit: ({required vaccineName, lastDate, nextDate, required recurrence, petId}) {},
    ),
    'add vet visit': AddVetVisitBottomSheetWidget(
      birthdate: birthdate,
      onSubmit: ({required title, required visitedAt, vetName, clinicName, petId}) {},
    ),
    'add weight': AddWeightBottomSheetWidget(
      birthdate: birthdate,
      onSubmit: (weight, loggedAt, {petId}) {},
    ),
  };

  for (final MapEntry(key: name, value: sheet) in sheets.entries) {
    testWidgets('$name keeps the field focused when the keyboard opens', (tester) async {
      addTearDown(tester.view.reset);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => BottomSheetWidget.show<void>(context, sheet),
              child: const Text('open'),
            ),
          ),
        ),
      ));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(TextField).first);
      await tester.pump();
      final editable = tester.state<EditableTextState>(find.byType(EditableText).first);
      expect(editable.widget.focusNode.hasFocus, isTrue);

      tester.view.viewInsets = const FakeViewPadding(bottom: 900);
      await tester.pumpAndSettle();

      final after = tester.state<EditableTextState>(find.byType(EditableText).first);
      expect(identical(after, editable), isTrue, reason: 'field was rebuilt by the keyboard inset');
      expect(after.widget.focusNode.hasFocus, isTrue, reason: 'keyboard would close');
    });
  }
}
