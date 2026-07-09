import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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
import 'package:nanimo/features/home/presentation/widgets/home_memory_polaroid_widget.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';

class _MockPetRepository extends Mock implements PetRepository {}

class _MockReferentialRepository extends Mock
    implements ReferentialRepository {}

class _MockEventRepository extends Mock implements EventRepository {}

class _MockHealthRepository extends Mock implements HealthRepository {}

class _MockAuthRepository extends Mock implements AuthRepository {}

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
  iconKey: 'cat',
);

const _maxime = UserModel(
  userId: 'u1',
  userName: 'Maxime',
  mail: 'maxime@nanimo.fr',
  subscriptionStatus: SubscriptionStatus.freemium,
  subscriptionConfigId: '1',
);

void main() {
  late _MockPetRepository petRepo;
  late _MockReferentialRepository referentialRepo;
  late _MockEventRepository eventRepo;
  late _MockHealthRepository healthRepo;
  late _MockAuthRepository authRepo;
  late StreamController<List<PetModel>> petsController;

  setUp(() {
    petRepo = _MockPetRepository();
    referentialRepo = _MockReferentialRepository();
    eventRepo = _MockEventRepository();
    healthRepo = _MockHealthRepository();
    authRepo = _MockAuthRepository();
    petsController = StreamController<List<PetModel>>();

    when(() => petRepo.watchPets()).thenAnswer((_) => petsController.stream);
    when(() => referentialRepo.fetchSpecies())
        .thenAnswer((_) async => [_cat]);
    when(() => eventRepo.watchEvents())
        .thenAnswer((_) => Stream.value(const []));
    when(() => eventRepo.watchPetEvents())
        .thenAnswer((_) => Stream.value(const {}));
    when(() => eventRepo.watchAllImages())
        .thenAnswer((_) => Stream.value(const {}));
    when(() => healthRepo.watchAllDiaries())
        .thenAnswer((_) => Stream.value(const []));
    when(() => healthRepo.watchAllVaccines())
        .thenAnswer((_) => Stream.value(const []));
    when(() => authRepo.watchCurrentUser())
        .thenAnswer((_) => Stream.value(_maxime));
  });

  tearDown(() => petsController.close());

  HomeCubit buildCubit() {
    return HomeCubit(
      petRepository: petRepo,
      referentialRepository: referentialRepo,
      eventRepository: eventRepo,
      healthRepository: healthRepo,
      authRepository: authRepo,
    );
  }

  Widget buildPage(HomeCubit cubit) {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider.value(value: cubit, child: const HomePage()),
      ),
    );
  }

  testWidgets('shows a loader until the pets stream emits', (tester) async {
    final cubit = buildCubit();
    await tester.pumpWidget(buildPage(cubit));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await cubit.close();
  });

  testWidgets('shows an empty message when the user has no pet',
      (tester) async {
    final cubit = buildCubit();
    await tester.pumpWidget(buildPage(cubit));

    petsController.add(const []);
    await tester.pumpAndSettle();

    expect(find.text('Aucun animal pour le moment'), findsOneWidget);
    await cubit.close();
  });

  testWidgets('shows the masthead, the family tile and an all-clear health',
      (tester) async {
    final cubit = buildCubit();
    await tester.pumpWidget(buildPage(cubit));

    petsController.add([_milo]);
    await tester.pumpAndSettle();

    expect(find.text('La gazette de Maxime'), findsOneWidget);
    expect(find.text('Milo'), findsOneWidget);
    expect(find.text('Ma famille'), findsOneWidget);
    expect(find.text('Tout est à jour !'), findsOneWidget);
    expect(find.text('Cette semaine'), findsOneWidget);
    expect(find.text('Aucun souvenir'), findsOneWidget);
    await cubit.close();
  });

  testWidgets('counts the memories captured over the last 7 days',
      (tester) async {
    // Tall phone viewport so the bento tiles below the polaroid are built.
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    when(() => eventRepo.watchEvents()).thenAnswer(
      (_) => Stream.value([
        EventModel(
          eventId: 'e1',
          title: 'Balade au lac',
          entryDate: DateTime.now().subtract(const Duration(days: 1)),
          eventTypeId: 't1',
        ),
      ]),
    );

    final cubit = buildCubit();
    await tester.pumpWidget(buildPage(cubit));

    petsController.add([_milo]);
    await tester.pumpAndSettle();

    expect(find.text('1'), findsOneWidget);
    expect(find.text('souvenir capturé'), findsOneWidget);
    // The latest memory is also featured as the fallback polaroid.
    expect(find.text('Dernier souvenir'), findsOneWidget);
    expect(find.text('Balade au lac'), findsOneWidget);
    await cubit.close();
  });

  testWidgets('features the memory from one year ago as a polaroid',
      (tester) async {
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

  testWidgets('lists overdue and upcoming vaccines in the health tile',
      (tester) async {
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
    expect(find.text('Pas fait'), findsOneWidget);
    expect(find.text('Tout est à jour !'), findsNothing);
    await cubit.close();
  });
}
