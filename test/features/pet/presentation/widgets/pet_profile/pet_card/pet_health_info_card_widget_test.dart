import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nanimo/features/health/data/models/health_diary_model.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_profile/pet_card/pet_health_info_card_widget.dart';

HealthDiaryModel _diary({
  bool? isSterilized = true,
  bool? isChipped,
  String? chipNumber,
  DateTime? lastDeworming,
  DateTime? lastVetAppointment,
}) =>
    HealthDiaryModel(
      healthDiaryId: 'diary-1',
      petId: 'pet-1',
      isSterilized: isSterilized,
      isChipped: isChipped,
      chipNumber: chipNumber,
      lastDeworming: lastDeworming,
      lastVetAppointment: lastVetAppointment,
    );

VetVisitModel _visit(DateTime visitedAt) => VetVisitModel(
      vetVisitId: 'visit-${visitedAt.millisecondsSinceEpoch}',
      title: 'Contrôle',
      visitedAt: visitedAt,
      petId: 'pet-1',
    );

void main() {
  Future<void> pumpCard(
    WidgetTester tester, {
    HealthDiaryModel? diary,
    List<VetVisitModel> vetVisits = const [],
    VoidCallback? onEditPressed,
  }) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: PetHealthInfoCardWidget(
              diary: diary,
              vetVisits: vetVisits,
              onFillPressed: () {},
              onEditPressed: onEditPressed,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('the edit affordance', () {
    testWidgets('offers a pencil once the diary exists', (tester) async {
      await pumpCard(tester, diary: _diary(), onEditPressed: () {});

      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    });

    /// Before the diary exists the "Remplir le carnet" button is the way in,
    /// and two entry points on the same card would compete.
    testWidgets('shows no pencil while the diary is empty', (tester) async {
      await pumpCard(tester, diary: null, onEditPressed: () {});

      expect(find.byIcon(Icons.edit_outlined), findsNothing);
      expect(find.text('Remplir le carnet'), findsOneWidget);
    });

    testWidgets('fires the callback when tapped', (tester) async {
      var tapped = 0;
      await pumpCard(tester, diary: _diary(), onEditPressed: () => tapped++);

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();

      expect(tapped, 1);
    });
  });

  /// The bug NAN-084 fixes: `health_diary.last_vet_appointment` is only written
  /// when the diary form is filled, so visits added afterwards never showed.
  group('the last vet appointment', () {
    testWidgets('reads the most recent recorded visit', (tester) async {
      await pumpCard(
        tester,
        diary: _diary(lastVetAppointment: DateTime(2024, 1, 10)),
        vetVisits: [
          _visit(DateTime(2026, 3, 4)),
          _visit(DateTime(2026, 8, 21)),
          _visit(DateTime(2026, 5, 2)),
        ],
      );

      expect(find.text('21/08/2026'), findsOneWidget);
      expect(find.text('10/01/2024'), findsNothing);
    });

    /// Order of arrival must not win over the actual dates.
    testWidgets('takes the maximum, not the last one added', (tester) async {
      await pumpCard(
        tester,
        diary: _diary(),
        vetVisits: [
          _visit(DateTime(2026, 8, 21)),
          _visit(DateTime(2026, 2, 1)),
        ],
      );

      expect(find.text('21/08/2026'), findsOneWidget);
    });

    /// Users who typed a date without ever recording a visit must not lose it.
    testWidgets('falls back to the diary column when no visit exists',
        (tester) async {
      await pumpCard(
        tester,
        diary: _diary(lastVetAppointment: DateTime(2026, 4, 9)),
      );

      expect(find.text('09/04/2026'), findsOneWidget);
    });

    testWidgets('shows a dash with neither visit nor recorded date',
        (tester) async {
      await pumpCard(tester, diary: _diary());

      expect(find.text('Dernier rendez-vous vétérinaire'), findsOneWidget);
      expect(find.text('—'), findsWidgets);
    });

    /// A visit alone is enough to consider the card worth showing, even if
    /// every diary field is still empty.
    testWidgets('leaves the empty state when only a visit exists',
        (tester) async {
      await pumpCard(
        tester,
        diary: _diary(isSterilized: null),
        vetVisits: [_visit(DateTime(2026, 6, 15))],
      );

      expect(find.text('Remplir le carnet'), findsNothing);
      expect(find.text('15/06/2026'), findsOneWidget);
    });
  });
}
