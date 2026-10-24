import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/features/home/presentation/widgets/home_article_card_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/add_vaccine_bottom_sheet_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/add_vet_visit_bottom_sheet_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_profile/pet_bottom_sheet/add_weight_bottom_sheet_widget.dart';

/// NAN-120: sheets must sit on the keyboard like a native iOS sheet, and
/// scrollable content must run to the bottom edge.
const _screen = Size(393, 852);
const _homeIndicator = 34.0;
const _keyboard = 336.0;

void _iphone(WidgetTester tester) {
  tester.view
    ..devicePixelRatio = 3
    ..physicalSize = _screen * 3
    ..padding = const FakeViewPadding(bottom: _homeIndicator * 3)
    ..viewPadding = const FakeViewPadding(bottom: _homeIndicator * 3);
  addTearDown(tester.view.reset);
}

// The engine reports no bottom padding while the keyboard covers the indicator.
void _keyboardUp(WidgetTester tester) {
  tester.view
    ..viewInsets = const FakeViewPadding(bottom: _keyboard * 3)
    ..padding = FakeViewPadding.zero;
}

void _keyboardDown(WidgetTester tester) {
  tester.view
    ..viewInsets = FakeViewPadding.zero
    ..padding = const FakeViewPadding(bottom: _homeIndicator * 3);
}

Future<void> _open(WidgetTester tester, Widget sheet) async {
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
}

void main() {
  final birthdate = DateTime(2020, 1, 1);

  final sheets = <String, Widget>{
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
    testWidgets('$name sits right on top of the keyboard', (tester) async {
      _iphone(tester);
      await _open(tester, sheet);
      await tester.tap(find.byType(TextField).first);
      _keyboardUp(tester);
      await tester.pumpAndSettle();

      final save = tester.getRect(find.ancestor(of: find.text('Enregistrer'), matching: find.byType(ButtonWidget)));
      final keyboardTop = _screen.height - _keyboard;
      expect(keyboardTop - save.bottom, inInclusiveRange(0, AppSpacing.md));
    });

    testWidgets('$name follows the keyboard down with no delay', (tester) async {
      _iphone(tester);
      await _open(tester, sheet);
      await tester.tap(find.byType(TextField).first);
      _keyboardUp(tester);
      await tester.pumpAndSettle();

      _keyboardDown(tester);
      await tester.pump();
      final firstFrame = tester.getRect(find.byType(BottomSheetWidget));
      await tester.pumpAndSettle();

      expect(firstFrame, tester.getRect(find.byType(BottomSheetWidget)),
          reason: 'sheet content still animating down after the keyboard closed');
    });
  }

  testWidgets('article text scrolls down to the bottom edge', (tester) async {
    _iphone(tester);
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: HomeArticleCardWidget())));
    await tester.tap(find.text('Lire la suite'));
    await tester.pumpAndSettle();

    final viewport = tester.getRect(find.descendant(
      of: find.byType(BottomSheet),
      matching: find.byType(SingleChildScrollView),
    ));
    expect(viewport.bottom, _screen.height, reason: 'dead white band under the scrolling text');
  });
}
