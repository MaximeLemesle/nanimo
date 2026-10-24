import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/utils/vaccine_status.dart';
import 'package:nanimo/core/widgets/pet_avatar_widget.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';
import 'package:nanimo/features/home/presentation/cubit/home_cubit.dart';
import 'package:nanimo/features/home/presentation/widgets/home_health_card_widget.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';

void main() {
  testWidgets('shows the pet icon and vaccine due date', (tester) async {
    final pet = PetModel(
      petId: 'pet-1',
      petName: 'Milo',
      birthdate: DateTime(2022, 6, 15),
      gender: Gender.male,
      createdAt: DateTime(2026, 6, 10),
      petRaceId: 'race-1',
      petSpeciesId: 'species-1',
    );
    final vaccine = HealthDiaryVaccineModel(
      healthDiaryVaccineId: 'vaccine-1',
      vaccineName: 'Rage',
      lastDate: DateTime(2025, 8, 24),
      nextDate: DateTime(2026, 8, 24),
      recurrence: 365,
      doseNumber: 1,
      totalDoseNumber: 1,
      healthDiaryId: 'diary-1',
    );
    final VaccineAlert alert = (
      vaccine: vaccine,
      pet: pet,
      status: VaccineStatus.soon,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomeHealthCardWidget(
            alerts: [alert],
            portraits: const {'pet-1': PetPortrait.species('cat-europeen')},
          ),
        ),
      ),
    );

    expect(find.byType(PetAvatarWidget), findsOneWidget);
    expect(find.byIcon(Icons.pets), findsNothing);
    expect(find.text('24/08/2026'), findsOneWidget);
    expect(find.text('Milo'), findsNothing);
  });

  /// The way in is not an empty-state affordance: a second booster is booked
  /// from the same place as the first.
  group('the way to book a booster', () {
    Future<void> pumpCard(
      WidgetTester tester,
      List<VaccineAlert> alerts, {
      VoidCallback? onAddPressed,
      List<LastHealthEntry> lastVaccinations = const [],
    }) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: HomeHealthCardWidget(
            alerts: alerts,
            portraits: const {},
            onAddPressed: onAddPressed,
            lastVaccinations: lastVaccinations,
            now: DateTime(2026, 10, 18, 19),
          ),
        ),
      ));
      await tester.pumpAndSettle();
    }

    /// NAN-115: the same words as the visits, and no icon in the text.
    testWidgets('says nothing is planned when nothing is recorded', (tester) async {
      var tapped = false;
      await pumpCard(tester, const [], onAddPressed: () => tapped = true);

      expect(find.text(HomeHealthCardWidget.emptyMessage), findsOneWidget);
      expect(find.byIcon(Icons.vaccines_outlined), findsNothing);

      await tester.tap(find.text('Ajouter un vaccin'));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });

    testWidgets('without a booster ahead, tells when each pet was last vaccinated', (tester) async {
      await pumpCard(tester, const [], lastVaccinations: [
        (pet: _alert().pet!, at: DateTime(2026, 7, 10)),
        (
          pet: PetModel(
            petId: 'pet-2',
            petName: 'Dobby',
            birthdate: DateTime(2024, 1, 1),
            gender: Gender.male,
            createdAt: DateTime(2026, 6, 10),
            petRaceId: 'race-1',
            petSpeciesId: 'species-1',
          ),
          at: DateTime(2026, 10, 6),
        ),
      ]);

      expect(_spoken('Dernier vaccin pour Milo il y a 3 mois'), findsOneWidget);
      expect(_spoken('Dernier vaccin pour Dobby il y a 12 jours'), findsOneWidget);
      expect(find.text(HomeHealthCardWidget.emptyMessage), findsNothing);
    });

    testWidgets('the empty state fits the narrowest phone', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await pumpCard(tester, const []);

      expect(tester.takeException(), isNull);
    });

    testWidgets('still shows once a booster is listed', (tester) async {
      await pumpCard(tester, [_alert()]);

      expect(find.text('Ajouter un vaccin à venir'), findsOneWidget);
    });

    testWidgets('a booster months away counts down instead of reading « Terminé »', (tester) async {
      await pumpCard(tester, [
        (
          vaccine: HealthDiaryVaccineModel(
            healthDiaryVaccineId: 'far',
            vaccineName: 'Rage',
            nextDate: DateTime(2027, 2, 1),
            recurrence: 365,
            doseNumber: 1,
            totalDoseNumber: 1,
            healthDiaryId: 'diary-1',
          ),
          pet: _alert().pet,
          status: VaccineStatus.done,
        ),
      ]);

      expect(find.text('Terminé'), findsNothing);
      expect(find.textContaining('Dans '), findsOneWidget);
    });
  });
  group('dewormings', () {
    final milo = PetModel(
      petId: 'pet-1',
      petName: 'Milo',
      birthdate: DateTime(2022, 6, 15),
      gender: Gender.male,
      createdAt: DateTime(2026, 6, 10),
      petRaceId: 'race-1',
      petSpeciesId: 'species-1',
    );
    final now = DateTime(2026, 10, 22, 9);
    DewormingAlert deworming(DateTime next) => (
          pet: milo,
          nextDate: next,
          lastDate: DateTime(2026, 7, 1),
          intervalMonths: 3,
          status: vaccineStatusFor(next, now: now),
        );
    final VaccineAlert booster = (
      vaccine: HealthDiaryVaccineModel(
        healthDiaryVaccineId: 'vaccine-1',
        vaccineName: 'Rage',
        nextDate: DateTime(2026, 11, 10),
        recurrence: 365,
        doseNumber: 1,
        totalDoseNumber: 1,
        healthDiaryId: 'diary-1',
      ),
      pet: milo,
      status: VaccineStatus.soon,
    );

    Future<List<String>> pump(WidgetTester tester, HomeHealthCardWidget card) async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: SingleChildScrollView(child: card))));
      return tester.widgetList<Text>(find.byType(Text)).map((text) => text.data ?? '').toList();
    }

    testWidgets('sit among the boosters, by date', (tester) async {
      final texts = await pump(
        tester,
        HomeHealthCardWidget(
          alerts: [booster],
          dewormings: [deworming(DateTime(2026, 11, 1))],
          portraits: const {},
          now: now,
        ),
      );
      expect(find.text('Soins à venir'), findsOneWidget);
      expect(texts.indexOf('Vermifuge'), lessThan(texts.indexOf('Rage')));
      expect(find.text('01/11/2026'), findsOneWidget);
    });

    testWidgets('can be ticked once due within the month, not before', (tester) async {
      String? done;
      await pump(
        tester,
        HomeHealthCardWidget(
          alerts: const [],
          dewormings: [deworming(DateTime(2026, 11, 1))],
          portraits: const {},
          onDewormingDone: (petId) => done = petId,
          now: now,
        ),
      );
      await tester.tap(find.text('C’est fait'));
      expect(done, 'pet-1');

      await pump(
        tester,
        HomeHealthCardWidget(
          alerts: const [],
          dewormings: [deworming(DateTime(2027, 1, 10))],
          portraits: const {},
          onDewormingDone: (_) {},
          now: now,
        ),
      );
      expect(find.text('C’est fait'), findsNothing);
    });

    testWidgets('a pet without one is invited to note it', (tester) async {
      String? noted;
      await pump(
        tester,
        HomeHealthCardWidget(
          alerts: const [],
          petsWithoutDeworming: [milo],
          portraits: const {},
          onDewormingTap: (petId) => noted = petId,
        ),
      );
      expect(find.text(HomeHealthCardWidget.emptyMessage), findsNothing);
      await tester.tap(find.text('Noter'));
      expect(noted, 'pet-1');
    });
  });
}

VaccineAlert _alert() => (
      vaccine: HealthDiaryVaccineModel(
        healthDiaryVaccineId: 'vaccine-1',
        vaccineName: 'Rage',
        lastDate: DateTime(2025, 8, 24),
        nextDate: DateTime(2026, 8, 24),
        recurrence: 365,
        doseNumber: 1,
        totalDoseNumber: 1,
        healthDiaryId: 'diary-1',
      ),
      pet: PetModel(
        petId: 'pet-1',
        petName: 'Milo',
        birthdate: DateTime(2022, 6, 15),
        gender: Gender.male,
        createdAt: DateTime(2026, 6, 10),
        petRaceId: 'race-1',
        petSpeciesId: 'species-1',
      ),
      status: VaccineStatus.soon,
    );

/// Matches a label whose spaces may be non-breaking.
Finder _spoken(String text) => find.byWidgetPredicate(
      (widget) => widget is Text && widget.data?.replaceAll('\u00A0', ' ') == text,
    );
