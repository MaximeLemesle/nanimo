import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/widgets/app_icon_widget.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/date_field_widget.dart';
import 'package:nanimo/core/widgets/time_field_widget.dart';
import 'package:nanimo/data/models/referential/pet_species_model.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/event/data/event_repository.dart';
import 'package:nanimo/features/event/data/models/event_image_model.dart';
import 'package:nanimo/features/event/data/models/event_model.dart';
import 'package:nanimo/features/event/data/models/event_type_model.dart';
import 'package:nanimo/features/event/presentation/cubit/event_creation_cubit.dart';
import 'package:nanimo/features/event/presentation/page/create_event_page.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/polaroid_collage_widget.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/sticker_selector_widget.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';
import 'package:nanimo/features/subscription/data/models/subscription_config_model.dart';
import 'package:nanimo/features/subscription/presentation/cubit/subscription_cubit.dart';

import '../../../../helpers/app_icon_finder.dart';

class _MockEventRepository extends Mock implements EventRepository {}

class _MockReferentialRepository extends Mock
    implements ReferentialRepository {}

class _MockPetRepository extends Mock implements PetRepository {}

class _FakeSubscriptionCubit extends Cubit<SubscriptionState>
    implements SubscriptionCubit {
  _FakeSubscriptionCubit(int maxImagesPerEvent, String planName)
      : super(SubscriptionState.loaded(SubscriptionConfigModel(
          configId: 'cfg',
          planName: planName,
          maxImagesPerEvent: maxImagesPerEvent,
          maxPets: 1,
        )));

  @override
  void noSuchMethod(Invocation invocation) {}
}

/// Returns a fixed set of images so quota enforcement can be exercised.
class _FakeImagePicker extends ImagePickerPlatform {
  _FakeImagePicker(this._paths);
  final List<String> _paths;

  @override
  Future<List<XFile>> getMultiImageWithOptions({
    MultiImagePickerOptions options = const MultiImagePickerOptions(),
  }) async =>
      _paths.map(XFile.new).toList();

  @override
  Future<XFile?> getImageFromSource({
    required ImageSource source,
    ImagePickerOptions options = const ImagePickerOptions(),
  }) async =>
      _paths.isEmpty ? null : XFile(_paths.first);
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

void main() {
  late _MockEventRepository eventRepo;
  late _MockReferentialRepository referentialRepo;
  late _MockPetRepository petRepo;

  setUpAll(() {
    registerFallbackValue(
      const EventModel(eventId: 'e', title: 't', eventTypeId: 't-balade'),
    );
    registerFallbackValue(
      const EventImageModel(eventImageId: 'i', assetPath: 'p', eventId: 'e'),
    );
    registerFallbackValue(File('fallback.jpg'));
  });

  setUp(() {
    eventRepo = _MockEventRepository();
    referentialRepo = _MockReferentialRepository();
    petRepo = _MockPetRepository();

    when(() => petRepo.getPets()).thenAnswer((_) async => [_milo]);
    when(() => referentialRepo.fetchSpecies())
        .thenAnswer((_) async => [_catSpecies]);
    when(() => referentialRepo.fetchEventTypes())
        .thenAnswer((_) async => [_balade, _calin]);
    when(() => eventRepo.createEvent(any(), petIds: any(named: 'petIds')))
        .thenAnswer((_) async {});
  });

  EventCreationCubit buildCubit() => EventCreationCubit(
        eventRepository: eventRepo,
        referentialRepository: referentialRepo,
        petRepository: petRepo,
      );

  /// Hosts the page behind a GoRouter so the success listener's `context.pop()`
  /// has a route to fall back to.
  Future<EventCreationCubit> pumpPage(
    WidgetTester tester, {
    int maxImagesPerEvent = 5,
    String planName = 'freemium',
    DateTime? initialEntryDate,
  }) async {
    await tester.binding.setSurfaceSize(const Size(1080, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final cubit = buildCubit()..load();
    addTearDown(cubit.close);
    final subscriptionCubit =
        _FakeSubscriptionCubit(maxImagesPerEvent, planName);
    addTearDown(subscriptionCubit.close);

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const Scaffold(body: SizedBox.shrink()),
        ),
        GoRoute(
          path: '/create',
          builder: (_, __) => MultiBlocProvider(
            providers: [
              BlocProvider<EventCreationCubit>.value(value: cubit),
              BlocProvider<SubscriptionCubit>.value(value: subscriptionCubit),
            ],
            child: CreateEventPage(initialEntryDate: initialEntryDate),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    router.push('/create');
    await tester.pumpAndSettle();
    return cubit;
  }

  testWidgets('shows a loader until types are loaded', (tester) async {
    when(() => referentialRepo.fetchEventTypes()).thenAnswer(
      (_) async {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        return [_balade];
      },
    );

    final cubit = buildCubit()..load();
    addTearDown(cubit.close);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(value: cubit, child: const CreateEventPage()),
      ),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('defaults to the balade type and the first pet', (tester) async {
    final cubit = await pumpPage(tester);

    expect(cubit.state.selectedTypeId, 't-balade');
    expect(cubit.state.selectedPetIds, ['pet-milo']);
    // Two sticker selectors: one for pets, one for the type.
    expect(find.byType(StickerSelectorWidget), findsNWidgets(2));
    expect(find.bySemanticsLabel('Balade'), findsOneWidget);
    expect(find.bySemanticsLabel('Milo'), findsOneWidget);
  });

  testWidgets('keeps the submit button disabled until a title is entered',
      (tester) async {
    await pumpPage(tester);

    ButtonWidget button() =>
        tester.widget<ButtonWidget>(find.byType(ButtonWidget));

    expect(button().state, ButtonState.disabled);

    await tester.enterText(find.byType(TextField).first, 'Première balade');
    await tester.pump();

    expect(button().state, ButtonState.normal);
  });

  testWidgets('submits the event linked to the pet and pops on success',
      (tester) async {
    final initialEntryDate = DateTime(2026, 3, 5, 14, 37, 12);
    await pumpPage(tester, initialEntryDate: initialEntryDate);

    expect(find.text('05/03/2026'), findsOneWidget);
    expect(find.text('14:37'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Première balade');
    await tester.pump();

    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    final captured = verify(
      () => eventRepo.createEvent(
        captureAny(),
        petIds: captureAny(named: 'petIds'),
      ),
    ).captured;
    final event = captured[0] as EventModel;
    expect(event.title, 'Première balade');
    expect(event.entryDate, initialEntryDate);
    expect(captured[1] as List<String>, ['pet-milo']);
    // Popped back to the host route.
    expect(find.byType(CreateEventPage), findsNothing);
  });

  testWidgets('combines the selected date and time before submitting',
      (tester) async {
    await pumpPage(
      tester,
      initialEntryDate: DateTime(2026, 3, 5, 14, 37, 12),
    );

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

    await tester.enterText(find.byType(TextField).first, 'Matin câlin');
    await tester.pump();
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    final captured = verify(
      () => eventRepo.createEvent(
        captureAny(),
        petIds: captureAny(named: 'petIds'),
      ),
    ).captured;
    expect(
      (captured[0] as EventModel).entryDate,
      DateTime(2026, 4, 2, 9, 5),
    );
  });

  testWidgets('changes the selected type from the bottom sheet',
      (tester) async {
    final cubit = await pumpPage(tester);

    // The type selector is the second sticker selector.
    await tester.tap(find.byType(StickerSelectorWidget).at(1));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Câlin'));
    await tester.pumpAndSettle();

    expect(cubit.state.selectedTypeId, 't-calin');
  });

  testWidgets('changes the selected pets from the bottom sheet',
      (tester) async {
    final cubit = await pumpPage(tester);

    // The pet selector is the first sticker selector.
    await tester.tap(find.byType(StickerSelectorWidget).first);
    await tester.pumpAndSettle();

    // Deselect Milo then validate stays disabled (no pet selected).
    expect(find.text('Choisir au moins un animal'), findsOneWidget);
    await tester.tap(find.text('Milo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Valider'));
    await tester.pumpAndSettle();

    // Sheet still open because validation is disabled.
    expect(find.text('Choisir au moins un animal'), findsOneWidget);
    // Re-select and validate.
    await tester.tap(find.text('Milo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Valider'));
    await tester.pumpAndSettle();

    expect(cubit.state.selectedPetIds, ['pet-milo']);
  });

  group('photo quota', () {
    setUp(() {
      // The picker offers three photos on every call.
      ImagePickerPlatform.instance =
          _FakeImagePicker(['/tmp/a.jpg', '/tmp/b.jpg', '/tmp/c.jpg']);
      when(() => eventRepo.uploadEventImage(any(), any()))
          .thenAnswer((_) async => 'u/e/x.jpg');
      when(() => eventRepo.addImage(any())).thenAnswer((_) async {});
    });

    testWidgets('a free plan (max 1) uploads the one photo it picked',
        (tester) async {
      await pumpPage(tester, maxImagesPerEvent: 1);

      await tester.tap(find.byType(PolaroidCollageWidget));
      await tester.pumpAndSettle();
      expect(findAppIcon(AppIcons.crown), findsOneWidget);
      
      await tester.tap(find.text('Sélectionner une photo'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'Balade');
      await tester.pump();
      await tester.tap(find.text('Enregistrer'));
      await tester.pumpAndSettle();

      verify(() => eventRepo.uploadEventImage(any(), any())).called(1);
    });

    testWidgets('a premium plan (max 5) keeps every picked photo',
        (tester) async {
      await pumpPage(tester, maxImagesPerEvent: 5, planName: 'premium');

      await tester.tap(find.byType(PolaroidCollageWidget));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sélectionner plusieurs photos'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'Balade');
      await tester.pump();
      await tester.tap(find.text('Enregistrer'));
      await tester.pumpAndSettle();

      verify(() => eventRepo.uploadEventImage(any(), any())).called(3);
    });
  });
}
