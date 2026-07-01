import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/errors/repository_network_exception.dart';
import 'package:nanimo/data/models/referential/pet_species_model.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/event/data/event_repository.dart';
import 'package:nanimo/features/event/data/models/event_model.dart';
import 'package:nanimo/features/event/data/models/event_type_model.dart';
import 'package:nanimo/features/journal/presentation/cubit/journal_cubit.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_event_detail/journal_event_detail_bottom_sheet_widget.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';

class _MockEventRepository extends Mock implements EventRepository {}

class _MockPetRepository extends Mock implements PetRepository {}

class _MockReferentialRepository extends Mock
    implements ReferentialRepository {}

final _saiko = PetModel(
  petId: 'p1',
  petName: 'Saïko',
  birthdate: DateTime(2024, 1, 1),
  gender: Gender.female,
  createdAt: DateTime(2024, 1, 1),
  petRaceId: 'r1',
  petSpeciesId: 's1',
);

const _walkType = EventTypeModel(
  eventTypeId: 't1',
  name: 'Balade',
  code: 'balade',
  isPremium: false,
);

const _species = [
  PetSpeciesModel(
    petSpeciesId: 's1',
    speciesName: 'Chat',
    weightUnit: WeightUnit.kg,
    iconKey: 'cat',
  ),
];

final _event = EventModel(
  eventId: 'e1',
  title: 'Promenade au parc',
  description: 'Une belle journée ensoleillée.',
  entryDate: DateTime(2026, 3, 5, 11, 43),
  eventTypeId: 't1',
);

void main() {
  late _MockEventRepository eventRepo;
  late _MockPetRepository petRepo;
  late _MockReferentialRepository refRepo;

  setUp(() {
    eventRepo = _MockEventRepository();
    petRepo = _MockPetRepository();
    refRepo = _MockReferentialRepository();

    when(() => eventRepo.watchEvents())
        .thenAnswer((_) => Stream.value([_event]));
    when(() => eventRepo.watchPetEvents()).thenAnswer((_) => Stream.value({
          'e1': ['p1']
        }));
    when(() => eventRepo.watchAllImages()).thenAnswer((_) => Stream.value({}));
    when(() => petRepo.getPets()).thenAnswer((_) async => [_saiko]);
    when(() => refRepo.fetchEventTypes()).thenAnswer((_) async => [_walkType]);
    when(() => refRepo.fetchSpecies()).thenAnswer((_) async => _species);
  });

  Future<JournalCubit> pumpSheet(
    WidgetTester tester, {
    VoidCallback? onEdit,
  }) async {
    final cubit = JournalCubit(
      eventRepository: eventRepo,
      petRepository: petRepo,
      referentialRepository: refRepo,
    );
    await tester.pumpAndSettle();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => JournalEventDetailBottomSheetWidget.show(
                  context,
                  event: _event,
                  onEdit: onEdit,
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return cubit;
  }

  testWidgets('shows title, date, description, pet and action buttons',
      (tester) async {
    final cubit = await pumpSheet(tester);

    expect(find.text('Promenade au parc'), findsOneWidget);
    expect(find.text('05 mars à 11h43'), findsOneWidget);
    expect(find.text('Une belle journée ensoleillée.'), findsOneWidget);
    expect(find.text('Saïko'), findsOneWidget);
    expect(find.text('Modifier'), findsOneWidget);
    expect(find.text('Supprimer'), findsOneWidget);

    await cubit.close();
  });

  testWidgets('tapping Modifier closes the sheet and fires onEdit',
      (tester) async {
    var edited = false;
    final cubit = await pumpSheet(tester, onEdit: () => edited = true);

    await tester.tap(find.text('Modifier'));
    await tester.pumpAndSettle();

    expect(edited, isTrue);
    expect(find.text('Promenade au parc'), findsNothing);

    await cubit.close();
  });

  testWidgets('confirming deletion calls the repository and closes the sheet',
      (tester) async {
    when(() => eventRepo.deleteEvent('e1')).thenAnswer((_) async {});
    final cubit = await pumpSheet(tester);

    await tester.tap(find.text('Supprimer'));
    await tester.pumpAndSettle();

    /// Confirm inside the alert dialog.
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Supprimer'),
      ),
    );
    await tester.pumpAndSettle();

    verify(() => eventRepo.deleteEvent('e1')).called(1);
    expect(find.text('Promenade au parc'), findsNothing);

    await cubit.close();
  });

  testWidgets('cancelling deletion keeps the sheet open', (tester) async {
    final cubit = await pumpSheet(tester);

    await tester.tap(find.text('Supprimer'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Annuler'));
    await tester.pumpAndSettle();

    verifyNever(() => eventRepo.deleteEvent(any()));
    expect(find.text('Promenade au parc'), findsOneWidget);

    await cubit.close();
  });

  testWidgets('a failed deletion shows a snackbar and keeps the sheet',
      (tester) async {
    when(() => eventRepo.deleteEvent('e1'))
        .thenThrow(const RepositoryNetworkException('Pas de réseau'));
    final cubit = await pumpSheet(tester);

    await tester.tap(find.text('Supprimer'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Supprimer'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pas de réseau'), findsOneWidget);
    expect(find.text('Promenade au parc'), findsOneWidget);

    await cubit.close();
  });
}
