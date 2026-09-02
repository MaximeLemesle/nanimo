import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/date_field_widget.dart';
import 'package:nanimo/core/widgets/time_field_widget.dart';
import 'package:nanimo/data/models/referential/pet_species_model.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/event/data/event_repository.dart';
import 'package:nanimo/features/event/data/models/event_image_model.dart';
import 'package:nanimo/features/event/data/models/event_model.dart';
import 'package:nanimo/features/event/data/models/event_type_model.dart';
import 'package:nanimo/features/event/presentation/cubit/edit_event_cubit.dart';
import 'package:nanimo/features/event/presentation/page/edit_event_page.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/polaroid_collage_widget.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/sticker_selector_widget.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';
import 'package:nanimo/features/subscription/data/models/subscription_config_model.dart';
import 'package:nanimo/features/subscription/presentation/cubit/subscription_cubit.dart';

class _MockEventRepository extends Mock implements EventRepository {}

class _MockReferentialRepository extends Mock
    implements ReferentialRepository {}

class _MockPetRepository extends Mock implements PetRepository {}

class _FakeSubscriptionCubit extends Cubit<SubscriptionState>
    implements SubscriptionCubit {
  _FakeSubscriptionCubit(int maxImagesPerEvent)
      : super(SubscriptionState.loaded(SubscriptionConfigModel(
          configId: 'cfg',
          planName: 'test',
          maxImagesPerEvent: maxImagesPerEvent,
          maxPets: 1,
        )));

  @override
  void noSuchMethod(Invocation invocation) {}
}

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
  entryDate: DateTime(2026, 3, 5, 11, 43),
  createdAt: DateTime(2026, 3, 5),
  eventTypeId: 't-balade',
);

const _existingImage = EventImageModel(
  eventImageId: 'img-1',
  assetPath: 'events/e1/img-1.jpg',
  eventId: 'e1',
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
    when(() => eventRepo.deleteImage(any(), any())).thenAnswer((_) async {});
  });

  EditEventCubit buildCubit() => EditEventCubit(
        eventRepository: eventRepo,
        referentialRepository: referentialRepo,
        petRepository: petRepo,
      );

  /// Hosts the page behind a GoRouter so the success listener's `context.pop()`
  /// has a route to fall back to.
  Future<EditEventCubit> pumpPage(
    WidgetTester tester, {
    int maxImagesPerEvent = 5,
  }) async {
    await tester.binding.setSurfaceSize(const Size(1080, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final cubit = buildCubit()..load('e1');
    addTearDown(cubit.close);
    final subscriptionCubit = _FakeSubscriptionCubit(maxImagesPerEvent);
    addTearDown(subscriptionCubit.close);

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const Scaffold(body: SizedBox.shrink()),
        ),
        GoRoute(
          path: '/edit',
          builder: (_, __) => MultiBlocProvider(
            providers: [
              BlocProvider<EditEventCubit>.value(value: cubit),
              BlocProvider<SubscriptionCubit>.value(value: subscriptionCubit),
            ],
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

    expect(find.text('05/03/2026'), findsOneWidget);
    expect(find.text('11:43'), findsOneWidget);
    expect(find.text('Première balade'), findsOneWidget);
    expect(find.text('Une belle balade.'), findsOneWidget);
    expect(find.bySemanticsLabel('Balade'), findsOneWidget);
    expect(find.bySemanticsLabel('Milo'), findsOneWidget);
    expect(find.byType(StickerSelectorWidget), findsNWidgets(2));
  });

  testWidgets('submits the updated fields and pops on success', (tester) async {
    await pumpPage(tester);

    await tester.enterText(find.byType(TextField).first, 'Titre modifié');
    await tester.pump();

    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    final captured = verify(() => eventRepo.updateEvent(captureAny())).captured;
    final event = captured.single as EventModel;
    expect(event.title, 'Titre modifié');
    expect(event.entryDate, DateTime(2026, 3, 5, 11, 43));
    verify(() => eventRepo.updateEventPets('e1', ['pet-milo'])).called(1);
    // Popped back to the host route.
    expect(find.byType(EditEventPage), findsNothing);
  });

  testWidgets('combines the selected date and time before submitting',
      (tester) async {
    await pumpPage(tester);

    tester
        .widget<DateFieldWidget>(find.byType(DateFieldWidget))
        .onChanged(DateTime(2026, 4, 2));
    await tester.pump();
    tester
        .widget<TimeFieldWidget>(find.byType(TimeFieldWidget))
        .onChanged(const TimeOfDay(hour: 9, minute: 5));
    await tester.pump();

    expect(find.text('02/04/2026'), findsOneWidget);
    expect(find.text('09:05'), findsOneWidget);

    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    final captured = verify(() => eventRepo.updateEvent(captureAny())).captured;
    expect(
      (captured.single as EventModel).entryDate,
      DateTime(2026, 4, 2, 9, 5),
    );
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

  testWidgets(
      'opens the image grid when an existing image is tapped without deleting it',
      (tester) async {
    when(() => eventRepo.watchImagesForEvent('e1'))
        .thenAnswer((_) => Stream.value([_existingImage]));
    when(() => eventRepo.signedImageUrl(_existingImage.assetPath))
        .thenAnswer((_) async => 'https://example.com/img-1.jpg');

    await pumpPage(tester);

    await tester.tap(find.byType(PolaroidCollageWidget));
    await tester.pumpAndSettle();

    expect(find.text('Photos du souvenir'), findsOneWidget);

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    verifyNever(() => eventRepo.deleteImage(any(), any()));
  });

  testWidgets('deletes an existing image only after the explicit delete action',
      (tester) async {
    when(() => eventRepo.watchImagesForEvent('e1'))
        .thenAnswer((_) => Stream.value([_existingImage]));
    when(() => eventRepo.signedImageUrl(_existingImage.assetPath))
        .thenAnswer((_) async => 'https://example.com/img-1.jpg');

    await pumpPage(tester);

    await tester.tap(find.byType(PolaroidCollageWidget));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('event-image-grid-tile-0')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Modifier la photo'), findsOneWidget);

    await tester.tap(find.text('Supprimer la photo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    verify(() => eventRepo.deleteImage(
          _existingImage.eventImageId,
          _existingImage.assetPath,
        )).called(1);
  });
}
