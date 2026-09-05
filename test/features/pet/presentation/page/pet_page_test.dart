import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/data/models/referential/pet_race_model.dart';
import 'package:nanimo/data/models/referential/pet_species_model.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/health/data/health_repository.dart';
import 'package:nanimo/features/health/data/models/health_diary_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_weight_log_model.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_details_cubit.dart';
import 'package:nanimo/features/pet/presentation/page/pet_page.dart';

class _MockPetRepository extends Mock implements PetRepository {}

class _MockHealthRepository extends Mock implements HealthRepository {}

class _MockReferentialRepository extends Mock
    implements ReferentialRepository {}

final _pet = PetModel(
  petId: 'p1',
  petName: 'Yummy',
  birthdate: DateTime(2024, 1, 1),
  gender: Gender.male,
  createdAt: DateTime(2024, 1, 1),
  petRaceId: 'r1',
  petSpeciesId: 's1',
);

const _species = PetSpeciesModel(
  petSpeciesId: 's1',
  speciesName: 'Chat',
  weightUnit: WeightUnit.kg,
  iconKey: 'cat-europeen',
);

const _races = [
  PetRaceModel(petRaceId: 'r1', raceName: 'Européen', petSpeciesId: 's1'),
];

final _diary = HealthDiaryModel(
  healthDiaryId: 'd1',
  petId: 'p1',
  isSterilized: true,
  isChipped: true,
  chipNumber: '250',
);

final _weightLogs = [
  HealthDiaryWeightLogModel(
    healthDiaryWeightLogId: 'w1',
    weight: 3.2,
    loggedAt: DateTime(2026, 6, 1),
    petId: 'p1',
  ),
];

void main() {
  late _MockPetRepository petRepo;
  late _MockHealthRepository healthRepo;
  late _MockReferentialRepository refRepo;

  setUpAll(() {
    registerFallbackValue(
      HealthDiaryWeightLogModel(
        healthDiaryWeightLogId: 'fallback',
        weight: 1,
        loggedAt: DateTime(2026, 1, 1),
        petId: 'p',
      ),
    );
  });

  setUp(() {
    petRepo = _MockPetRepository();
    healthRepo = _MockHealthRepository();
    refRepo = _MockReferentialRepository();

    when(() => petRepo.watchPets()).thenAnswer((_) => Stream.value([_pet]));
    when(() => healthRepo.watchDiaryForPet(any()))
        .thenAnswer((_) => Stream.value(_diary));
    when(() => healthRepo.getVaccinesForDiary(any()))
        .thenAnswer((_) => Stream.value(const <HealthDiaryVaccineModel>[]));
    when(() => healthRepo.getWeightLogsForPet(any()))
        .thenAnswer((_) => Stream.value(_weightLogs));
    when(() => healthRepo.getVetVisitsForPet(any()))
        .thenAnswer((_) => Stream.value(const <VetVisitModel>[]));
    when(() => healthRepo.addWeightLog(any())).thenAnswer((_) async {});
    when(() => refRepo.fetchSpecies()).thenAnswer((_) async => [_species]);
    when(() => refRepo.fetchRacesBySpecies(any()))
        .thenAnswer((_) async => _races);
  });

  Widget buildPage(PetDetailsCubit cubit) {
    return MaterialApp(
      home: BlocProvider<PetDetailsCubit>.value(
        value: cubit,
        child: const PetPage(),
      ),
    );
  }

  testWidgets('renders the pet identity, health and vaccines sections',
      (tester) async {
    final cubit = PetDetailsCubit(
      petRepository: petRepo,
      healthRepository: healthRepo,
      referentialRepository: refRepo,
    );
    await tester.pumpWidget(buildPage(cubit));
    await tester.pumpAndSettle();

    expect(find.text('Yummy'), findsOneWidget);
    expect(find.text('Chat'), findsOneWidget);
    expect(find.text('Européen'), findsOneWidget);
    expect(find.text('Mâle'), findsOneWidget);
    expect(find.text('3,2 kg'), findsOneWidget);
    expect(find.text('Informations de santé'), findsOneWidget);
    expect(find.text('Liste des vaccins'), findsOneWidget);
    expect(find.text('Voir le carnet de santé'), findsOneWidget);

    await cubit.close();
  });

  testWidgets('opens the update weight modal when tapping the action',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final cubit = PetDetailsCubit(
      petRepository: petRepo,
      healthRepository: healthRepo,
      referentialRepository: refRepo,
    );
    await tester.pumpWidget(buildPage(cubit));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Mettre à jour le poids'));
    await tester.pumpAndSettle();

    expect(find.text('Enregistrer'), findsOneWidget);

    await cubit.close();
  });

  testWidgets('shows the onboarding card when the diary is empty',
      (tester) async {
    when(() => healthRepo.watchDiaryForPet(any()))
        .thenAnswer((_) => Stream.value(null));
    when(() => healthRepo.getWeightLogsForPet(any()))
        .thenAnswer((_) => Stream.value(const <HealthDiaryWeightLogModel>[]));

    final cubit = PetDetailsCubit(
      petRepository: petRepo,
      healthRepository: healthRepo,
      referentialRepository: refRepo,
    );
    await tester.pumpWidget(buildPage(cubit));
    await tester.pumpAndSettle();

    expect(find.text('Identité'), findsOneWidget);
    expect(find.text('Remplir le carnet'), findsOneWidget);
    expect(find.text('Voir le carnet de santé'), findsNothing);
    expect(find.text('Liste des vaccins'), findsNothing);

    await cubit.close();
  });

  testWidgets('opens the onboarding modal from the empty card',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    when(() => healthRepo.watchDiaryForPet(any()))
        .thenAnswer((_) => Stream.value(null));
    when(() => healthRepo.getWeightLogsForPet(any()))
        .thenAnswer((_) => Stream.value(const <HealthDiaryWeightLogModel>[]));

    final cubit = PetDetailsCubit(
      petRepository: petRepo,
      healthRepository: healthRepo,
      referentialRepository: refRepo,
    );
    await tester.pumpWidget(buildPage(cubit));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Remplir le carnet'));
    await tester.pumpAndSettle();

    expect(find.text('Création du carnet de santé'), findsOneWidget);

    await cubit.close();
  });
}
