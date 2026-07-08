import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/event/data/models/event_model.dart';
import 'package:nanimo/features/journal/presentation/cubit/journal_cubit.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_empty_state_widget.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_timeline/journal_timeline_widget.dart';

void main() {
  Widget wrap(JournalState state) {
    return MaterialApp(
      home: Scaffold(
        body: JournalTimelineWidget(state: state),
      ),
    );
  }

  testWidgets('renders the shared empty state when no event exists',
      (tester) async {
    await tester.pumpWidget(wrap(const JournalState()));

    expect(find.text(JournalEmptyStateWidget.message), findsOneWidget);
  });

  testWidgets('renders the shared empty state when filters remove all events',
      (tester) async {
    final state = JournalState(
      events: [
        EventModel(
          eventId: 'e1',
          title: 'Promenade',
          entryDate: DateTime(2026, 3, 5),
          eventTypeId: 'walk',
        ),
      ],
      selectedTypeIds: const {'missing-type'},
    );

    await tester.pumpWidget(wrap(state));

    expect(find.text(JournalEmptyStateWidget.message), findsOneWidget);
  });
}
