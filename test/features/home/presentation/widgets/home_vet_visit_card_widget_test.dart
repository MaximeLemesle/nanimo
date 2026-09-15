import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';
import 'package:nanimo/features/home/presentation/cubit/home_cubit.dart';
import 'package:nanimo/features/home/presentation/widgets/home_vet_visit_card_widget.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';

final _now = DateTime(2026, 9, 16, 12);

PetModel _pet(String id, String name) => PetModel(
      petId: id,
      petName: name,
      birthdate: DateTime(2024, 1, 1),
      gender: Gender.male,
      createdAt: DateTime(2024, 1, 1),
      petRaceId: 'r1',
      petSpeciesId: 's1',
    );

UpcomingVetVisit _entry(
  String id,
  String title,
  int inDays, {
  String? vetName,
  String? clinicName,
  PetModel? pet,
}) =>
    (
      visit: VetVisitModel(
        vetVisitId: id,
        title: title,
        visitedAt: _now.add(Duration(days: inDays)),
        vetName: vetName,
        clinicName: clinicName,
        petId: pet?.petId ?? 'p1',
      ),
      pet: pet ?? _pet('p1', 'Yummy'),
    );

void main() {
  Future<void> pumpCard(
    WidgetTester tester,
    List<UpcomingVetVisit> visits, {
    VoidCallback? onAddPressed,
    void Function(String petId)? onVisitTap,
  }) async {
    await tester.binding.setSurfaceSize(const Size(400, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: HomeVetVisitCardWidget(
            visits: visits,
            portraits: const {},
            now: _now,
            onAddPressed: onAddPressed,
            onVisitTap: onVisitTap,
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('titles the section', (tester) async {
    await pumpCard(tester, const []);

    expect(find.text('Visites à venir'), findsOneWidget);
  });

  group('with nothing booked', () {
    testWidgets('says so and offers a way to book', (tester) async {
      var tapped = false;
      await pumpCard(tester, const [], onAddPressed: () => tapped = true);

      expect(
        find.text('Aucune visite chez le vétérinaire de prévue'),
        findsOneWidget,
      );
      expect(find.text('Ajouter une visite à venir'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('Ajouter une visite à venir'));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });
  });

  group('with a booked appointment', () {
    testWidgets('shows the title, the vet, the clinic, the date and the count',
        (tester) async {
      await pumpCard(tester, [
        _entry('v1', 'Rappel annuel', 24,
            vetName: 'Dr.Martin', clinicName: 'Clinique des Pins'),
      ]);

      expect(find.text('Rappel annuel'), findsOneWidget);
      expect(
        find.text('Dr.Martin · Clinique des Pins · 10/10/2026'),
        findsOneWidget,
      );
      expect(find.text('Dans 24 j'), findsOneWidget);
      expect(find.text('Ajouter une visite à venir'), findsNothing);
    });

    testWidgets('drops the missing fields from the subtitle', (tester) async {
      await pumpCard(tester, [_entry('v1', 'Contrôle', 3)]);

      expect(find.text('19/09/2026'), findsOneWidget);
    });

    testWidgets('taps through to the pet', (tester) async {
      String? tappedPetId;
      await pumpCard(
        tester,
        [_entry('v1', 'Contrôle', 3)],
        onVisitTap: (petId) => tappedPetId = petId,
      );

      await tester.tap(find.text('Contrôle'));
      await tester.pumpAndSettle();

      expect(tappedPetId, 'p1');
    });
  });
}
