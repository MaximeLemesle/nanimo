import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/data/models/referential/pet_species_model.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/event/data/event_repository.dart';
import 'package:nanimo/features/event/data/models/event_model.dart';
import 'package:nanimo/features/event/data/models/event_type_model.dart';
import 'package:nanimo/features/journal/presentation/cubit/journal_cubit.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_filter/journal_filter_list_widget.dart';
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
  title: 'Promenade',
  entryDate: DateTime(2026, 3, 5),
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

  Future<JournalCubit> pumpBar(WidgetTester tester) async {
    final cubit = JournalCubit(
      eventRepository: eventRepo,
      petRepository: petRepo,
      referentialRepository: refRepo,
    );
    await tester.pumpAndSettle();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider.value(
            value: cubit,
            child: BlocBuilder<JournalCubit, JournalState>(
              builder: (context, state) =>
                  JournalFilterListWidget(state: state),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return cubit;
  }

  testWidgets('shows the open chip and no active chip by default',
      (tester) async {
    final cubit = await pumpBar(tester);

    expect(find.text('Filtres'), findsOneWidget);
    expect(find.text('Saïko'), findsNothing);
    expect(find.byIcon(Icons.close), findsNothing);

    await cubit.close();
  });

  testWidgets('shows a removable chip per active pet and type filter',
      (tester) async {
    final cubit = await pumpBar(tester);

    cubit.togglePetFilter('p1');
    cubit.toggleTypeFilter('t1');
    await tester.pumpAndSettle();

    expect(find.text('Saïko'), findsOneWidget);
    expect(find.text('Balade'), findsOneWidget);
    expect(find.byIcon(Icons.close), findsNWidgets(2));

    await cubit.close();
  });

  testWidgets('tapping an active chip removes that filter', (tester) async {
    final cubit = await pumpBar(tester);

    cubit.togglePetFilter('p1');
    await tester.pumpAndSettle();
    expect(find.text('Saïko'), findsOneWidget);

    await tester.tap(find.text('Saïko'));
    await tester.pumpAndSettle();

    expect(cubit.state.selectedPetIds, isEmpty);
    expect(find.text('Saïko'), findsNothing);

    await cubit.close();
  });
}
