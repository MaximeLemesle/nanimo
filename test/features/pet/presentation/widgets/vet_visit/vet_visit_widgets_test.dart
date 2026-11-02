import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/widgets/bottom_bar_widget/bottom_bar_menu_widget.dart';
import 'package:nanimo/features/event/data/models/event_model.dart';
import 'package:nanimo/features/health/data/models/vet_document_model.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';
import 'package:nanimo/features/home/presentation/cubit/home_cubit.dart';
import 'package:nanimo/features/journal/presentation/cubit/journal_cubit.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_timeline/journal_vet_visit_card_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/add_vet_visit_bottom_sheet_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/vet_visit/add_vet_document_bottom_sheet_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/vet_visit/vet_visit_status_widget.dart';

VetVisitModel _visit({
  String id = 'v1',
  DateTime? at,
  bool hasTime = false,
  String? report,
  int documentCount = 0,
}) =>
    VetVisitModel(
      vetVisitId: id,
      title: 'Contrôle annuel',
      visitedAt: at ?? DateTime(2026, 10, 20),
      hasTime: hasTime,
      petId: 'p1',
      report: report,
      documentCount: documentCount,
    );

Future<void> _pump(WidgetTester tester, Widget child) async {
  await tester.binding.setSurfaceSize(const Size(800, 1800));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));
  await tester.pumpAndSettle();
}

void main() {
  group('VetVisitStatusWidget', () {
    final now = DateTime(2026, 10, 18, 12);

    testWidgets('an upcoming visit says « À venir »', (tester) async {
      await _pump(tester, VetVisitStatusWidget(visit: _visit(), now: now));
      expect(find.text('À venir'), findsOneWidget);
    });

    testWidgets('an empty past visit says « À compléter »', (tester) async {
      await _pump(tester, VetVisitStatusWidget(visit: _visit(at: DateTime(2026, 10, 15)), now: now));
      expect(find.text('À compléter'), findsOneWidget);
    });

    testWidgets('a filled past visit only shows its documents', (tester) async {
      await _pump(tester, VetVisitStatusWidget(visit: _visit(at: DateTime(2026, 10, 15), documentCount: 2), now: now));
      expect(find.text('2'), findsOneWidget);
      expect(find.text('À compléter'), findsNothing);
      expect(find.bySemanticsLabel(RegExp('2 documents')), findsOneWidget);
    });
  });

  testWidgets('the journal card names the visit, the animal and opens on tap', (tester) async {
    var tapped = false;
    await _pump(
      tester,
      JournalVetVisitCardWidget(visit: _visit(), petName: 'Saïko', onTap: () => tapped = true),
    );

    expect(find.text('Contrôle annuel'), findsOneWidget);
    expect(find.text('Visite véto · Saïko · 20/10/2026'), findsOneWidget);
    await tester.tap(find.text('Contrôle annuel'));
    expect(tapped, isTrue);
  });

  group('AddVetVisitBottomSheetWidget (NAN-133)', () {
    testWidgets('an existing visit keeps its time and hands back a full draft', (tester) async {
      VetVisitDraft? draft;
      final visit = _visit(at: DateTime(2026, 10, 15, 14, 30), hasTime: true, documentCount: 2)
          .copyWith(reason: () => 'Toux');
      await _pump(tester, AddVetVisitBottomSheetWidget(initial: visit, onSubmit: (value) => draft = value));

      expect(find.text('Retirer l’heure'), findsOneWidget);
      expect(find.text('Toux'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Compte-rendu (optionnel)'), findsOneWidget);
      await tester.enterText(find.widgetWithText(TextField, 'Compte-rendu (optionnel)'), 'RAS');
      await tester.tap(find.text('Enregistrer'));
      await tester.pumpAndSettle();

      expect(draft!.hasTime, isTrue);
      expect(draft!.visitedAt, DateTime(2026, 10, 15, 14, 30));
      expect(draft!.reason, 'Toux');
      expect(draft!.report, 'RAS');
      final applied = draft!.applyTo(visit);
      expect(applied.documentCount, 2);
      expect(applied.report, 'RAS');
    });

    testWidgets('removing the time saves the visit at midnight', (tester) async {
      VetVisitDraft? draft;
      await _pump(
        tester,
        AddVetVisitBottomSheetWidget(
          initial: _visit(at: DateTime(2026, 10, 15, 9), hasTime: true),
          onSubmit: (value) => draft = value,
        ),
      );

      await tester.tap(find.text('Retirer l’heure'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Enregistrer'));
      await tester.pumpAndSettle();

      expect(draft!.hasTime, isFalse);
      expect(draft!.visitedAt, DateTime(2026, 10, 15));
    });

    testWidgets('a visit still to come has no report field', (tester) async {
      await _pump(
        tester,
        AddVetVisitBottomSheetWidget(initial: _visit(at: DateTime(2099, 1, 1)), onSubmit: (_) {}),
      );

      expect(find.widgetWithText(TextField, 'Compte-rendu (optionnel)'), findsNothing);
      expect(find.widgetWithText(TextField, 'Détails du motif (optionnel)'), findsOneWidget);
    });

    testWidgets('deleting a visit with documents says they go too', (tester) async {
      var deleted = false;
      await _pump(
        tester,
        AddVetVisitBottomSheetWidget(
          initial: _visit(documentCount: 3),
          onSubmit: (_) {},
          onDelete: () => deleted = true,
        ),
      );

      await tester.tap(find.text('Supprimer la visite'));
      await tester.pumpAndSettle();

      expect(find.textContaining('ses 3 documents'), findsOneWidget);
      expect(deleted, isFalse);
    });
  });

  testWidgets('the document sheet returns the chosen type and source', (tester) async {
    VetDocumentChoice? choice;
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () async => choice = await AddVetDocumentBottomSheetWidget.show(context),
            child: const Text('open'),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Facture'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Prendre une photo'));
    await tester.pumpAndSettle();

    expect(choice, (source: VetDocumentSource.camera, type: VetDocumentType.facture));
  });

  testWidgets('the create menu offers a vet visit only when wired', (tester) async {
    var opened = false;
    await _pump(
      tester,
      BottomBarMenuWidget(
        isOpen: true,
        onAddWeight: () {},
        onAddEvent: () {},
        onAddPet: () {},
        onAddVetVisit: () => opened = true,
      ),
    );

    await tester.tap(find.text('Ajouter une visite véto'));
    expect(opened, isTrue);

    await _pump(
      tester,
      BottomBarMenuWidget(isOpen: true, onAddWeight: () {}, onAddEvent: () {}, onAddPet: () {}),
    );
    expect(find.text('Ajouter une visite véto'), findsNothing);
  });

  group('a visit is an event, not a memory', () {
    final souvenir = EventModel(eventId: 'e1', title: 'Balade', entryDate: DateTime(2025, 10, 18), eventTypeId: 't1');
    final visitEvent = EventModel(eventId: 'v1', title: 'Contrôle annuel', entryDate: DateTime(2026, 10, 25), eventTypeId: '');

    test('the home leaves visits out of its memories', () {
      final state = HomeState(events: [visitEvent, souvenir], vetVisits: [_visit(at: DateTime(2026, 10, 25))]);

      expect(state.memories.map((e) => e.eventId), ['e1']);
      expect(state.latestEvent!.eventId, 'e1');
      expect(state.anniversaryEvent(now: DateTime(2026, 10, 18))!.eventId, 'e1');
      expect(state.weekEvents(now: DateTime(2026, 10, 26)), isEmpty);
    });

    test('the journal recognises a visit by its id', () {
      final state = JournalState(events: [visitEvent, souvenir], vetVisits: {'v1': _visit()});

      expect(state.vetVisitFor(visitEvent)!.title, 'Contrôle annuel');
      expect(state.vetVisitFor(souvenir), isNull);
      expect(state.petNameOf('p1'), isNull);
    });
  });
}
