import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/notifications/notification_priming.dart';
import 'package:nanimo/core/notifications/notifications.dart';
import 'package:nanimo/features/home/presentation/widgets/home_first_steps_card_widget.dart';
import 'package:nanimo/core/widgets/pet_avatar_widget.dart';
import 'package:nanimo/data/models/referential/pet_species_model.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/auth/data/auth_repository.dart';
import 'package:nanimo/features/auth/data/models/user_model.dart';
import 'package:nanimo/features/event/data/event_repository.dart';
import 'package:nanimo/features/event/data/models/event_model.dart';
import 'package:nanimo/features/health/data/health_repository.dart';
import 'package:nanimo/features/health/data/models/health_diary_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';
import 'package:nanimo/features/home/presentation/cubit/home_cubit.dart';
import 'package:nanimo/features/home/presentation/page/home_page.dart';
import 'package:nanimo/features/home/presentation/widgets/home_health_card_widget.dart';
import 'package:nanimo/features/home/presentation/widgets/home_memory_polaroid_widget.dart';
import 'package:nanimo/features/journal/presentation/cubit/journal_cubit.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_creation_cubit.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_details_cubit.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/vaccine_status_badge_widget.dart';
import 'package:nanimo/features/home/data/article_repository.dart';
import 'package:nanimo/features/subscription/presentation/cubit/subscription_cubit.dart'
    hide SubscriptionStatus;
import 'package:nanimo/features/subscription/data/models/subscription_config_model.dart';

import '../../../../core/notifications/fake_notification_client.dart';

class _MockPetRepository extends Mock implements PetRepository {}

class _MockReferentialRepository extends Mock implements ReferentialRepository {}

class _MockEventRepository extends Mock implements EventRepository {}

class _MockHealthRepository extends Mock implements HealthRepository {}

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockArticleRepository extends Mock implements ArticleRepository {}

final _milo = PetModel(
  petId: 'p1',
  petName: 'Milo',
  birthdate: DateTime.utc(2022, 6, 15),
  gender: Gender.female,
  createdAt: DateTime.utc(2026, 6, 10),
  petRaceId: 'r1',
  petSpeciesId: 's1',
);

const _cat = PetSpeciesModel(
  petSpeciesId: 's1',
  speciesName: 'Chat',
  weightUnit: WeightUnit.kg,
  iconKey: 'cat-europeen',
);

const _maxime = UserModel(
  userId: 'u1',
  userName: 'Maxime',
  mail: 'maxime@nanimo.fr',
  subscriptionStatus: SubscriptionStatus.freemium,
);

class _FakePetCreationCubit extends Cubit<PetCreationState>
    implements PetCreationCubit {
  _FakePetCreationCubit(super.initialState);

  void created(String petId) => emit(PetCreationState(
      status: PetCreationStatus.success, awaitedPetId: petId));

  @override
  void petShown() => emit(state.copyWith(clearAwaitedPet: true));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSubscriptionCubit extends Cubit<SubscriptionState>
    implements SubscriptionCubit {
  _FakeSubscriptionCubit()
      : super(SubscriptionState.loaded(const SubscriptionConfigModel(
          configId: 'cfg',
          planName: 'premium',
          maxImagesPerEvent: 5,
          maxPets: 10,
        )));

  @override
  void noSuchMethod(Invocation invocation) {}
}

void main() {
  late _MockPetRepository petRepo;
  late _MockReferentialRepository referentialRepo;
  late _MockEventRepository eventRepo;
  late _MockHealthRepository healthRepo;
  late _MockAuthRepository authRepo;
  late _MockArticleRepository articleRepo;
  late StreamController<List<PetModel>> petsController;

  setUpAll(() => registerFallbackValue(
      const HealthDiaryModel(healthDiaryId: 'f', petId: 'f')));

  setUp(() {
    petRepo = _MockPetRepository();
    referentialRepo = _MockReferentialRepository();
    eventRepo = _MockEventRepository();
    healthRepo = _MockHealthRepository();
    authRepo = _MockAuthRepository();
    articleRepo = _MockArticleRepository();
    when(() => articleRepo.watchCurrentArticle())
        .thenAnswer((_) => Stream.value(null));
    petsController = StreamController<List<PetModel>>();

    when(() => petRepo.watchPets()).thenAnswer((_) => petsController.stream);
    when(() => referentialRepo.fetchSpecies()).thenAnswer((_) async => [_cat]);
    when(() => eventRepo.watchEvents()).thenAnswer((_) => Stream.value(const []));
    when(() => eventRepo.watchPetEvents()).thenAnswer((_) => Stream.value(const {}));
    when(() => eventRepo.watchAllImages()).thenAnswer((_) => Stream.value(const {}));
    when(() => healthRepo.watchAllDiaries()).thenAnswer((_) => Stream.value(const []));
    when(() => healthRepo.watchAllVaccines()).thenAnswer((_) => Stream.value(const []));
    when(() => healthRepo.watchAllVetVisits()).thenAnswer((_) => Stream.value(const []));
    when(() => authRepo.watchCurrentUser()).thenAnswer((_) => Stream.value(_maxime));
  });

  tearDown(() => petsController.close());

  HomeCubit buildCubit() {
    return HomeCubit(
      petRepository: petRepo,
      referentialRepository: referentialRepo,
      eventRepository: eventRepo,
      healthRepository: healthRepo,
      authRepository: authRepo,
      articleRepository: articleRepo,
    );
  }

  Widget buildPage(HomeCubit cubit, {PetCreationCubit? petCreation}) {
    return MaterialApp(
      home: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider<HomeCubit>.value(value: cubit),
            if (petCreation != null)
              BlocProvider<PetCreationCubit>.value(value: petCreation),
            BlocProvider<SubscriptionCubit>.value(
              value: _FakeSubscriptionCubit(),
            ),
          ],
          child: const HomePage(),
        ),
      ),
    );
  }

  testWidgets('shows a loader until the pets stream emits', (tester) async {
    final cubit = buildCubit();
    await tester.pumpWidget(buildPage(cubit));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await cubit.close();
  });

  testWidgets('shows an empty message when the user has no pet', (tester) async {
    final cubit = buildCubit();
    await tester.pumpWidget(buildPage(cubit));

    petsController.add(const []);
    await tester.pumpAndSettle();

    expect(find.text('Aucun animal pour le moment'), findsOneWidget);
    await cubit.close();
  });

  testWidgets('keeps the loader while the signup pet is being written', (tester) async {
    final cubit = buildCubit();
    final petCreation = _FakePetCreationCubit(
      PetCreationState(pendingPet: _milo, status: PetCreationStatus.creating),
    );
    await tester.pumpWidget(buildPage(cubit, petCreation: petCreation));

    petsController.add(const []);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Aucun animal pour le moment'), findsNothing);

    /// Written, but the cache has not shown it yet: still no empty state.
    petCreation.created('p1');
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Aucun animal pour le moment'), findsNothing);

    petsController.add([_milo]);
    await tester.pump();

    expect(find.text('Aucun animal pour le moment'), findsNothing);
    expect(petCreation.state.awaitedPetId, isNull);
    await petCreation.close();
    await cubit.close();
  });

  testWidgets('shows the masthead, the pets strip and a first-vaccine invite', (tester) async {
    // Tall phone viewport so the health card below the pets strip is built.
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    final cubit = buildCubit();
    await tester.pumpWidget(buildPage(cubit));

    petsController.add([_milo]);
    await tester.pumpAndSettle();

    expect(find.text('Carnet de Maxime'), findsOneWidget);
    expect(find.text('Milo'), findsOneWidget);
    expect(find.text('Soins à venir'), findsOneWidget);
    expect(find.text('Quand était le dernier ?'), findsOneWidget);
    expect(find.text('Ajouter un vaccin'), findsOneWidget);
    await cubit.close();
  });

  testWidgets('opens the article in a bottom sheet', (tester) async {
    // Tall phone viewport so the article card at the bottom is built.
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    final cubit = buildCubit();
    await tester.pumpWidget(buildPage(cubit));

    petsController.add([_milo]);
    await tester.pumpAndSettle();

    expect(find.text('Lire la suite'), findsOneWidget);

    await tester.tap(find.text('Lire la suite'));
    await tester.pumpAndSettle();

    // The back button at the top of the sheet closes it.
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('Lire la suite'), findsOneWidget);
    await cubit.close();
  });

  testWidgets('features the memory from one year ago as a polaroid', (tester) async {
    final now = DateTime.now();
    when(() => eventRepo.watchEvents()).thenAnswer(
      (_) => Stream.value([
        EventModel(
          eventId: 'e1',
          title: 'Première baignade',
          entryDate: DateTime(now.year - 1, now.month, now.day, 12),
          eventTypeId: 't1',
        ),
      ]),
    );

    final cubit = buildCubit();
    await tester.pumpWidget(buildPage(cubit));

    petsController.add([_milo]);
    await tester.pumpAndSettle();

    expect(find.byType(HomeMemoryPolaroidWidget), findsOneWidget);
    expect(find.text('Il y a 1 an'), findsOneWidget);
    expect(find.text('Première baignade'), findsOneWidget);
    await cubit.close();
  });

  testWidgets('opens the event detail sheet when tapping the polaroid', (tester) async {
    // Tall AND wide viewport: the polaroid must be tappable and the sheet
    // action buttons need room for the wide test font glyphs.
    tester.view.physicalSize = const Size(1600, 2560);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    final now = DateTime.now();
    when(() => eventRepo.watchEvents()).thenAnswer(
      (_) => Stream.value([
        EventModel(
          eventId: 'e1',
          title: 'Première baignade',
          entryDate: DateTime(now.year - 1, now.month, now.day, 12),
          eventTypeId: 't1',
        ),
      ]),
    );
    // Stubs required by the JournalCubit backing the detail sheet.
    var petStreams = 0;
    when(() => petRepo.watchPets())
        .thenAnswer((_) => petStreams++ == 0 ? petsController.stream : Stream.value([_milo]));
    when(() => referentialRepo.fetchEventTypes()).thenAnswer((_) async => const []);

    final cubit = buildCubit();
    final journalCubit = JournalCubit(
      eventRepository: eventRepo,
      petRepository: petRepo,
      referentialRepository: referentialRepo,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: cubit),
              BlocProvider.value(value: journalCubit),
              BlocProvider<SubscriptionCubit>.value(
                value: _FakeSubscriptionCubit(),
              ),
            ],
            child: const HomePage(),
          ),
        ),
      ),
    );

    petsController.add([_milo]);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(HomeMemoryPolaroidWidget));
    await tester.pumpAndSettle();

    // The event title now appears on both the polaroid and the sheet.
    expect(find.text('Première baignade'), findsNWidgets(2));
    expect(find.text('Modifier'), findsOneWidget);
    expect(find.text('Supprimer'), findsOneWidget);
    await journalCubit.close();
    await cubit.close();
  });

  /// NAN-115: a booster ten months away is listed, not hidden behind an all-clear.
  testWidgets('lists a booster months away', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);
    when(() => healthRepo.watchAllDiaries()).thenAnswer(
      (_) => Stream.value(
        const [HealthDiaryModel(healthDiaryId: 'd1', petId: 'p1')],
      ),
    );
    when(() => healthRepo.watchAllVaccines()).thenAnswer(
      (_) => Stream.value([
        HealthDiaryVaccineModel(
          healthDiaryVaccineId: 'v1',
          vaccineName: 'Rage',
          lastDate: DateTime.now().subtract(const Duration(days: 30)),
          nextDate: DateTime.now().add(const Duration(days: 300)),
          recurrence: 365,
          doseNumber: 1,
          totalDoseNumber: 1,
          healthDiaryId: 'd1',
        ),
      ]),
    );

    final cubit = buildCubit();
    await tester.pumpWidget(buildPage(cubit));

    petsController.add([_milo]);
    await tester.pumpAndSettle();

    expect(find.text('Rage'), findsOneWidget);
    expect(find.text('Aucun vaccin de prévu'), findsNothing);
    await cubit.close();
  });

  testWidgets('lists overdue and upcoming vaccines in the health tile', (tester) async {
    when(() => healthRepo.watchAllDiaries()).thenAnswer(
      (_) => Stream.value(
        const [HealthDiaryModel(healthDiaryId: 'd1', petId: 'p1')],
      ),
    );
    when(() => healthRepo.watchAllVaccines()).thenAnswer(
      (_) => Stream.value([
        HealthDiaryVaccineModel(
          healthDiaryVaccineId: 'v1',
          vaccineName: 'Rage',
          lastDate: DateTime(2025, 6, 26),
          nextDate: DateTime.now().subtract(const Duration(days: 12)),
          recurrence: 365,
          doseNumber: 1,
          totalDoseNumber: 1,
          healthDiaryId: 'd1',
        ),
      ]),
    );

    final cubit = buildCubit();
    await tester.pumpWidget(buildPage(cubit));

    petsController.add([_milo]);
    await tester.pumpAndSettle();

    expect(find.text('Rage'), findsOneWidget);
    expect(find.text('En retard'), findsOneWidget);
    expect(find.text('Tout est à jour !'), findsNothing);
    await cubit.close();
  });

  /// NAN-065: health_diary_vaccines leaks other accounts' rows, whose diary
  /// resolves to no pet. Those alerts used to render an empty icon slot.
  testWidgets('shows a pet icon on every vaccine alert of the health tile', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    when(() => healthRepo.watchAllDiaries()).thenAnswer(
      (_) => Stream.value(
        [HealthDiaryModel(healthDiaryId: 'd1', petId: 'p1', lastDeworming: DateTime.now())],
      ),
    );
    when(() => healthRepo.watchAllVaccines()).thenAnswer(
      (_) => Stream.value([
        HealthDiaryVaccineModel(
          healthDiaryVaccineId: 'v1',
          vaccineName: 'Rage',
          lastDate: DateTime(2025, 6, 26),
          nextDate: DateTime.now().subtract(const Duration(days: 12)),
          recurrence: 365,
          doseNumber: 1,
          totalDoseNumber: 1,
          healthDiaryId: 'd1',
        ),
        HealthDiaryVaccineModel(
          healthDiaryVaccineId: 'v2',
          vaccineName: 'Leucose',
          lastDate: DateTime(2025, 6, 26),
          nextDate: DateTime.now().add(const Duration(days: 5)),
          recurrence: 365,
          doseNumber: 1,
          totalDoseNumber: 1,
          healthDiaryId: 'd-someone-else',
        ),
      ]),
    );

    final cubit = buildCubit();
    await tester.pumpWidget(buildPage(cubit));

    petsController.add([_milo]);
    await tester.pumpAndSettle();

    final card = find.byType(HomeHealthCardWidget);
    final rows = find.descendant(
      of: card,
      matching: find.byType(VaccineStatusBadgeWidget),
    );
    final icons = find.descendant(
      of: card,
      matching: find.byType(PetAvatarWidget),
    );

    // The overdue booster and Milo's deworming, each with its pet.
    expect(icons, findsNWidgets(2));
    expect(rows, findsOneWidget);
    expect(find.text('Vermifuge'), findsOneWidget);
    expect(find.text('Leucose'), findsNothing);
    await cubit.close();
  });

  /// NAN-126: a snack bar with an action persists by default since Flutter 3.32.
  testWidgets('the « C’est fait » confirmation leaves on its own', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);
    final overdue = HealthDiaryModel(
        healthDiaryId: 'd1', petId: 'p1', lastDeworming: DateTime(2025, 1, 1));
    when(() => healthRepo.watchAllDiaries()).thenAnswer((_) => Stream.value([overdue]));
    when(() => healthRepo.getDiaryForPet('p1')).thenAnswer((_) async => overdue);
    when(() => healthRepo.upsertDiary(any())).thenAnswer((_) async {});
    final detailsPets = _MockPetRepository();
    when(() => detailsPets.watchPets()).thenAnswer((_) => const Stream.empty());
    when(() => referentialRepo.fetchIcons()).thenAnswer((_) async => []);
    final details = PetDetailsCubit(
        petRepository: detailsPets,
        healthRepository: healthRepo,
        referentialRepository: referentialRepo);
    addTearDown(details.close);

    final cubit = buildCubit();
    await tester.pumpWidget(BlocProvider<PetDetailsCubit>.value(
        value: details, child: buildPage(cubit)));
    petsController.add([_milo]);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('C’est fait'));
    await tester.tap(find.text('C’est fait'));
    await tester.pumpAndSettle();
    expect(find.text('Vermifuge de Milo noté'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(find.text('Vermifuge de Milo noté'), findsNothing);
    await cubit.close();
  });

  // NAN-121: scrolling back up must move the page by the drag, not jump.
  testWidgets('keeps its scroll position steady with the first steps card', (tester) async {
    tester.view
      ..devicePixelRatio = 3
      ..physicalSize = const Size(393, 600) * 3;
    addTearDown(tester.view.reset);
    final previousPriming = notificationPriming;
    final previousStore = firstStepsStore;
    notificationPriming =
        NotificationPriming(client: () => FakeNotificationClient(), store: MemoryPrimingStore());
    firstStepsStore = MemoryFirstStepsStore();
    addTearDown(() {
      notificationPriming = previousPriming;
      firstStepsStore = previousStore;
    });

    final cubit = buildCubit();
    await tester.pumpWidget(buildPage(cubit));
    petsController.add([_milo]);
    await tester.pumpAndSettle();
    expect(find.text('Premiers pas'), findsOneWidget);

    final scrollable = find.byType(Scrollable).first;
    ScrollPosition position() => tester.state<ScrollableState>(scrollable).position;

    position().jumpTo(position().maxScrollExtent);
    await tester.pumpAndSettle();
    final bottom = position().pixels;
    expect(bottom, greaterThan(0));

    for (var target = bottom - 100; target > 0; target -= 100) {
      position().jumpTo(target);
      await tester.pumpAndSettle();
      expect(position().pixels, closeTo(target, 1), reason: 'page jumped while scrolling up to $target');
    }
    await cubit.close();
  });
}
