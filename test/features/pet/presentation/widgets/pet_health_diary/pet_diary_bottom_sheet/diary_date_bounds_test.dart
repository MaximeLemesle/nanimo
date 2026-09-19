import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/add_vaccine_bottom_sheet_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/add_vet_visit_bottom_sheet_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_profile/pet_bottom_sheet/add_weight_bottom_sheet_widget.dart';

final _birthdate = DateTime(2024, 3, 12);

/// NAN-090 lot 1: every date field of the diary carries its two bounds.
void main() {
  Future<CupertinoDatePicker> openPicker(
    WidgetTester tester,
    Widget sheet,
    String fieldLabel,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: sheet)));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(InputDecorator, fieldLabel));
    await tester.pumpAndSettle();

    return tester.widget<CupertinoDatePicker>(find.byType(CupertinoDatePicker));
  }

  void expectSameDay(DateTime actual, DateTime expected) {
    expect(
      DateTime(actual.year, actual.month, actual.day),
      DateTime(expected.year, expected.month, expected.day),
    );
  }

  group('vet visit date', () {
    testWidgets('starts at the birthdate and stays open ahead', (tester) async {
      final picker = await openPicker(
        tester,
        AddVetVisitBottomSheetWidget(
          birthdate: _birthdate,
          onSubmit: ({
            required String title,
            required DateTime visitedAt,
            String? vetName,
            String? clinicName,
            String? petId,
          }) {},
        ),
        'Date de la visite',
      );

      expectSameDay(picker.minimumDate!, _birthdate);
      expect(picker.maximumDate!.isAfter(DateTime.now()), isTrue);
    });

    /// Booked from the home, a date already gone is not a visit to come.
    testWidgets('booked ahead, the floor is today, not the birthdate',
        (tester) async {
      final picker = await openPicker(
        tester,
        AddVetVisitBottomSheetWidget(
          birthdate: _birthdate,
          upcomingOnly: true,
          onSubmit: ({
            required String title,
            required DateTime visitedAt,
            String? vetName,
            String? clinicName,
            String? petId,
          }) {},
        ),
        'Date de la visite',
      );

      expectSameDay(picker.minimumDate!, DateTime.now());
      expect(picker.maximumDate!.isAfter(DateTime.now()), isTrue);
    });
  });

  group('vaccine dates', () {
    Widget sheet({bool upcomingOnly = false}) => AddVaccineBottomSheetWidget(
          birthdate: _birthdate,
          upcomingOnly: upcomingOnly,
          onSubmit: ({
            required String vaccineName,
            required DateTime lastDate,
            required DateTime nextDate,
            String? petId,
          }) {},
        );

    // The defect found while framing the ticket: it accepted 2056.
    testWidgets('the last booster is a past event and stops today',
        (tester) async {
      final picker = await openPicker(tester, sheet(), 'Dernier rappel');

      expectSameDay(picker.minimumDate!, _birthdate);
      expectSameDay(picker.maximumDate!, DateTime.now());
    });

    testWidgets('the next booster is scheduled and stays open ahead',
        (tester) async {
      final picker = await openPicker(tester, sheet(), 'Prochain rappel');

      expectSameDay(picker.minimumDate!, _birthdate);
      expect(picker.maximumDate!.isAfter(DateTime.now()), isTrue);
    });

    /// Booked from the home, a booster already gone is not one to come.
    testWidgets('booked ahead, the next booster floors at today',
        (tester) async {
      final picker = await openPicker(
        tester,
        sheet(upcomingOnly: true),
        'Prochain rappel',
      );

      expectSameDay(picker.minimumDate!, DateTime.now());
      expect(picker.maximumDate!.isAfter(DateTime.now()), isTrue);
    });
  });

  group('weight date', () {
    testWidgets('starts at the birthdate and stops today', (tester) async {
      final picker = await openPicker(
        tester,
        AddWeightBottomSheetWidget(
          birthdate: _birthdate,
          onSubmit: (weight, loggedAt, {petId}) {},
        ),
        'Date de la pesée',
      );

      expectSameDay(picker.minimumDate!, _birthdate);
      expectSameDay(picker.maximumDate!, DateTime.now());
    });
  });
}
