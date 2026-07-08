import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/data/models/referential/pet_species_model.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/event/data/event_repository.dart';
import 'package:nanimo/features/event/data/models/event_model.dart';
import 'package:nanimo/features/event/data/models/event_type_model.dart';
import 'package:nanimo/features/journal/presentation/cubit/journal_cubit.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_calendar/calendar_widget/calendar_day_cell_widget.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_calendar/journal_calendar_widget.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_empty_state_widget.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';

const _calendarEndMessage =
    "Vous n'avez pas d'évènement antérieur à cette date";

Color? _decorationColor(Decoration decoration) {
  if (decoration is BoxDecoration) return decoration.color;
  if (decoration is ShapeDecoration) return decoration.color;
  return null;
}

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

final _firstEvent = EventModel(
  eventId: 'e2',
  title: 'Premier souvenir',
  entryDate: DateTime(2026, 1, 10, 8, 0),
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

  Future<JournalCubit> pumpCalendar(
    WidgetTester tester, {
    DateTime? today,
  }) async {
    final cubit = JournalCubit(
      eventRepository: eventRepo,
      petRepository: petRepo,
      referentialRepository: refRepo,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: Scaffold(
            body: BlocBuilder<JournalCubit, JournalState>(
              builder: (context, state) => JournalCalendarWidget(
                state: state,
                today: today ?? DateTime(2026, 3, 30),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return cubit;
  }

  testWidgets('renders month headers and event day markers', (tester) async {
    final cubit = await pumpCalendar(tester);

    expect(find.text('Mars 2026'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);

    await cubit.close();
  });

  testWidgets('renders the shared empty state when no event exists',
      (tester) async {
    when(() => eventRepo.watchEvents()).thenAnswer((_) => Stream.value([]));
    when(() => eventRepo.watchPetEvents()).thenAnswer((_) => Stream.value({}));
    final cubit = await pumpCalendar(tester);

    expect(find.text(JournalEmptyStateWidget.message), findsOneWidget);
    expect(find.text(_calendarEndMessage), findsNothing);

    await cubit.close();
  });

  testWidgets('renders the shared empty state when filters remove all events',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: JournalCalendarWidget(
            state: JournalState(
              events: [_event],
              selectedTypeIds: const {'missing-type'},
            ),
            today: DateTime(2026, 3, 30),
          ),
        ),
      ),
    );

    expect(find.text(JournalEmptyStateWidget.message), findsOneWidget);
    expect(find.text(_calendarEndMessage), findsNothing);
  });

  testWidgets('renders month days from oldest week to newest week',
      (tester) async {
    final cubit = await pumpCalendar(tester);

    expect(
      tester.getTopLeft(find.text('1')).dy,
      lessThan(tester.getTopLeft(find.text('31')).dy),
    );

    await cubit.close();
  });

  testWidgets('renders the current month at the bottom on first display',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    when(() => eventRepo.watchEvents())
        .thenAnswer((_) => Stream.value([_event, _firstEvent]));
    when(() => eventRepo.watchPetEvents()).thenAnswer((_) => Stream.value({
          'e1': ['p1'],
          'e2': ['p1'],
        }));
    final cubit = await pumpCalendar(tester, today: DateTime(2026, 7, 30));

    expect(find.text('Juillet 2026'), findsOneWidget);
    expect(find.text('Juin 2026'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Juillet 2026')).dy,
      greaterThan(tester.getTopLeft(find.text('Juin 2026')).dy),
    );

    await cubit.close();
  });

  testWidgets('loads months by six without going before the first event month',
      (tester) async {
    when(() => eventRepo.watchEvents())
        .thenAnswer((_) => Stream.value([_event, _firstEvent]));
    when(() => eventRepo.watchPetEvents()).thenAnswer((_) => Stream.value({
          'e1': ['p1'],
          'e2': ['p1'],
        }));
    final cubit = await pumpCalendar(tester, today: DateTime(2026, 7, 30));

    expect(find.text('Juillet 2026'), findsOneWidget);
    expect(find.text('Janvier 2026'), findsNothing);
    expect(find.text(_calendarEndMessage), findsNothing);

    for (var i = 0;
        i < 12 && find.text('Janvier 2026').evaluate().isEmpty;
        i++) {
      await tester.drag(find.byType(ListView), const Offset(0, 600));
      await tester.pumpAndSettle();
    }

    expect(find.text('Janvier 2026'), findsOneWidget);

    for (var i = 0;
        i < 12 && find.text(_calendarEndMessage).evaluate().isEmpty;
        i++) {
      await tester.drag(find.byType(ListView), const Offset(0, 600));
      await tester.pumpAndSettle();
    }

    expect(find.text('Décembre 2025'), findsNothing);
    expect(find.text(_calendarEndMessage), findsOneWidget);

    await cubit.close();
  });

  testWidgets('renders today as a black circle even without events',
      (tester) async {
    final cubit = await pumpCalendar(tester, today: DateTime(2026, 3, 30));

    final todayFinder = find.ancestor(
      of: find.text('30'),
      matching: find.byType(AnimatedContainer),
    );
    final todayMarker = tester.widget<AnimatedContainer>(todayFinder);
    final todaySize = tester.getSize(todayFinder);

    expect(todaySize, const Size(32, 32));
    expect(
        _decorationColor(todayMarker.decoration!), AppColors.backgroundInvert);

    await cubit.close();
  });

  testWidgets('renders today event with event tile and black circle',
      (tester) async {
    final cubit = await pumpCalendar(tester, today: DateTime(2026, 3, 5));

    final todayTileFinder = find.ancestor(
      of: find.text('5'),
      matching: find.byType(AnimatedContainer),
    );
    final todayTile = tester.widget<AnimatedContainer>(todayTileFinder);

    final todayCircleFinder = find.ancestor(
      of: find.text('5'),
      matching: find.byWidgetPredicate((widget) {
        if (widget is! Container) return false;
        final decoration = widget.decoration;
        return decoration is BoxDecoration &&
            decoration.color == AppColors.backgroundInvert;
      }),
    );
    final todayCircleSize = tester.getSize(todayCircleFinder);

    expect(tester.getSize(todayTileFinder), const Size(44, 54));
    expect(
        _decorationColor(todayTile.decoration!), AppColors.backgroundPrimary);
    expect(todayCircleSize, const Size(32, 32));

    await cubit.close();
  });

  testWidgets('calendar day cell shows a black circle only for today',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CalendarDayCell(
            day: DateTime(2026, 3, 5),
            hasEvents: true,
            isToday: false,
          ),
        ),
      ),
    );

    final tileFinder = find.ancestor(
      of: find.text('5'),
      matching: find.byType(AnimatedContainer),
    );
    final tile = tester.widget<AnimatedContainer>(tileFinder);

    expect(_decorationColor(tile.decoration!), AppColors.backgroundPrimary);
    expect(
      find.byWidgetPredicate((widget) {
        if (widget is! Container) return false;
        final decoration = widget.decoration;
        return decoration is BoxDecoration &&
            decoration.color == AppColors.backgroundInvert;
      }),
      findsNothing,
    );
  });

  testWidgets('tapping an event day opens the day sheet then event detail',
      (tester) async {
    final cubit = await pumpCalendar(tester);

    await tester.ensureVisible(find.text('5'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('5'));
    await tester.pumpAndSettle();

    expect(cubit.state.selectedCalendarDay, DateTime(2026, 3, 5));
    expect(find.text('5 mars 2026'), findsOneWidget);
    expect(find.text('Promenade au parc'), findsOneWidget);

    await tester.tap(find.text('Promenade au parc'));
    await tester.pumpAndSettle();

    expect(find.text('05 mars à 11h43'), findsOneWidget);
    expect(find.text('Modifier'), findsOneWidget);
    expect(find.text('Supprimer'), findsOneWidget);

    await cubit.close();
  });
}
