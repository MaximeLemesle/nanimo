import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/data/models/referential/pet_species_model.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/event/data/event_repository.dart';
import 'package:nanimo/features/event/data/models/event_model.dart';
import 'package:nanimo/features/event/data/models/event_type_model.dart';
import 'package:nanimo/features/event/presentation/cubit/edit_event_cubit.dart';
import 'package:nanimo/features/event/presentation/page/edit_event_page.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/sticker_selector_widget.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';

class _MockEventRepository extends Mock implements EventRepository {}

class _MockReferentialRepository extends Mock
    implements ReferentialRepository {}

class _MockPetRepository extends Mock implements PetRepository {}

const _balade = EventTypeModel(
  eventTypeId: 't-balade',
  name: 'Balade',
  code: 'balade',
  isPremium: false,
);
const _calin = EventTypeModel(
  eventTypeId: 't-calin',
  name: 'Câlin',
  code: 'calin',
  isPremium: false,
);
const _catSpecies = PetSpeciesModel(
  petSpeciesId: 's-cat',
  speciesName: 'Chat',
  weightUnit: WeightUnit.kg,
  iconKey: 'cat',
);

final _milo = PetModel(
  petId: 'pet-milo',
  petName: 'Milo',
  birthdate: DateTime(2022, 5, 1),
  gender: Gender.male,
  createdAt: DateTime(2022, 5, 1),
  petRaceId: 'r',
  petSpeciesId: 's-cat',
);

final _event = EventModel(
  eventId: 'e1',
  title: 'Première balade',
  description: 'Une belle balade.',
  entryDate: DateTime(2026, 3, 5),
  createdAt: DateTime(2026, 3, 5),
  eventTypeId: 't-balade',
);

void main() {
  late _MockEventRepository eventRepo;
  late _MockReferentialRepository referentialRepo;
  late _MockPetRepository petRepo;

  setUpAll(() {
    registerFallbackValue(
      const EventModel(eventId: 'e', title: 't', eventTypeId: 't-balade'),
    );
  });

  setUp(() {
    eventRepo = _MockEventRepository();
    referentialRepo = _MockReferentialRepository();
    petRepo = _MockPetRepository();

    when(() => eventRepo.getEventById('e1')).thenAnswer((_) async => _event);
    when(() => eventRepo.getPetIdsForEvent('e1'))
        .thenAnswer((_) async => ['pet-milo']);
    when(() => eventRepo.watchImagesForEvent('e1'))
        .thenAnswer((_) => Stream.value(const []));
    when(() => petRepo.getPets()).thenAnswer((_) async => [_milo]);
    when(() => referentialRepo.fetchSpecies())
        .thenAnswer((_) async => [_catSpecies]);
    when(() => referentialRepo.fetchEventTypes())
        .thenAnswer((_) async => [_balade, _calin]);
    when(() => eventRepo.updateEvent(any())).thenAnswer((_) async {});
    when(() => eventRepo.updateEventPets(any(), any()))
        .thenAnswer((_) async {});
  });

  EditEventCubit buildCubit() => EditEventCubit(
        eventRepository: eventRepo,
        referentialRepository: referentialRepo,
        petRepository: petRepo,
      );

  /// Hosts the page behind a GoRouter so the success listener's `context.pop()`
  /// has a route to fall back to.
  Future<EditEventCubit> pumpPage(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1080, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final cubit = buildCubit()..load('e1');
    addTearDown(cubit.close);

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const Scaffold(body: SizedBox.shrink()),
        ),
        GoRoute(
          path: '/edit',
          builder: (_, __) => BlocProvider.value(
            value: cubit,
            child: const EditEventPage(),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    router.push('/edit');
    await tester.pumpAndSettle();
    return cubit;
  }

  testWidgets('shows a loader until the event is loaded', (tester) async {
    when(() => eventRepo.getEventById('e1')).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      return _event;
    });

    final cubit = buildCubit()..load('e1');
    addTearDown(cubit.close);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(value: cubit, child: const EditEventPage()),
      ),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('prefills the form from the loaded event', (tester) async {
    await pumpPage(tester);

    expect(find.text('Première balade'), findsOneWidget);
    expect(find.text('Une belle balade.'), findsOneWidget);
    expect(find.bySemanticsLabel('Balade'), findsOneWidget);
    expect(find.bySemanticsLabel('Milo'), findsOneWidget);
    expect(find.byType(StickerSelectorWidget), findsNWidgets(2));
  });

  testWidgets('submits the updated fields and pops on success',
      (tester) async {
    await pumpPage(tester);

    await tester.enterText(find.byType(TextField).first, 'Titre modifié');
    await tester.pump();

    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    final captured = verify(() => eventRepo.updateEvent(captureAny())).captured;
    expect((captured.single as EventModel).title, 'Titre modifié');
    verify(() => eventRepo.updateEventPets('e1', ['pet-milo'])).called(1);
    // Popped back to the host route.
    expect(find.byType(EditEventPage), findsNothing);
  });

  testWidgets('disables submit when the title is cleared', (tester) async {
    await pumpPage(tester);

    ButtonWidget button() =>
        tester.widget<ButtonWidget>(find.byType(ButtonWidget));

    expect(button().state, ButtonState.normal);

    await tester.enterText(find.byType(TextField).first, '');
    await tester.pump();

    expect(button().state, ButtonState.disabled);
  });

  testWidgets('changes the selected type from the bottom sheet',
      (tester) async {
    final cubit = await pumpPage(tester);

    await tester.tap(find.byType(StickerSelectorWidget).at(1));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Câlin'));
    await tester.pumpAndSettle();

    expect(cubit.state.selectedTypeId, 't-calin');
  });
}
