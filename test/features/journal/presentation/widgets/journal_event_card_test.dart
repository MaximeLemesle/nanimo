import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/widgets/species_icon_widget.dart';
import 'package:nanimo/features/event/data/models/event_model.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_timeline/journal_timeline_event_card_widget.dart';

void main() {
  final event = EventModel(
    eventId: 'e1',
    title: 'Promenade au parc',
    description: 'Une belle journée ensoleillée.',
    entryDate: DateTime(2026, 3, 5, 11, 43),
    eventTypeId: 't1',
  );

  Future<String> resolver(String path) async => 'https://example.com/$path';

  Widget wrap(Widget child) => MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: child)),
      );

  testWidgets('renders the date header, title and description', (tester) async {
    await tester.pumpWidget(
      wrap(
        JournalTimelineEventCardWidget(
          event: event,
          imagePaths: const [],
          portraits: const [PetPortrait.species('cat')],
          urlResolver: resolver,
          imageFirst: true,
        ),
      ),
    );

    expect(find.text('05 mars à 11h43'), findsOneWidget);
    expect(find.text('Promenade au parc'), findsOneWidget);
    expect(find.text('Une belle journée ensoleillée.'), findsOneWidget);
  });

  testWidgets('renders one sticker and its shadow per pet icon key', (tester) async {
    await tester.pumpWidget(
      wrap(
        JournalTimelineEventCardWidget(
          event: event,
          imagePaths: const [],
          portraits: const [
            PetPortrait.species('cat'),
            PetPortrait.species('dog'),
          ],
          urlResolver: resolver,
          imageFirst: false,
        ),
      ),
    );

    /// The shadows of an icon is created using a second icon
    expect(find.byType(SpeciesIconWidget), findsNWidgets(4));
  });
}
