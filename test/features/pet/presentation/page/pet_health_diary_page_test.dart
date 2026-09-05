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
import 'package:nanimo/features/pet/presentation/page/pet_health_diary_page.dart';

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
  chipNumber: '250 26 85 12345678',
);

final _vaccines = [
  HealthDiaryVaccineModel(
    healthDiaryVaccineId: 'v1',
    vaccineName: 'Typhus félin',
    lastDate: DateTime(2025, 5, 13),
    nextDate: DateTime.now().add(const Duration(days: 20)),
    recurrence: 365,
    doseNumber: 1,
    totalDoseNumber: 1,
    healthDiaryId: 'd1',
  ),
];

final _vetVisits = [
  VetVisitModel(
    vetVisitId: 'vv1',
    title: 'Bilan annuel',
    visitedAt: DateTime(2026, 1, 14),
    vetName: 'Dr.Martin',
    clinicName: 'Clinique des Pins',
    petId: 'p1',
  ),
];

final _weightLogs = [
  HealthDiaryWeightLogModel(
    healthDiaryWeightLogId: 'w1',
    weight: 1.2,
    loggedAt: DateTime(2026, 1, 1),
    petId: 'p1',
  ),
  HealthDiaryWeightLogModel(
    healthDiaryWeightLogId: 'w2',
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
    registerFallbackValue(HealthDiaryModel(healthDiaryId: 'f', petId: 'p'));
    registerFallbackValue(
      VetVisitModel(
        vetVisitId: 'f',
        title: 'x',
        visitedAt: DateTime(2026, 1, 1),
        petId: 'p',
      ),
    );
  });

  setUp(() {
    petRepo = _MockPetRepository();
    healthRepo = _MockHealthRepository();
    refRepo = _MockReferentialRepository();

    when(() => petRepo.watchPets()).thenAnswer((_) => Stream.value([_pet]));
    when(() => healthRepo.upsertDiary(any())).thenAnswer((_) async {});
    when(() => healthRepo.addVetVisit(any())).thenAnswer((_) async {});
    when(() => healthRepo.watchDiaryForPet(any()))
        .thenAnswer((_) => Stream.value(_diary));
    when(() => healthRepo.getVaccinesForDiary(any()))
        .thenAnswer((_) => Stream.value(_vaccines));
    when(() => healthRepo.getWeightLogsForPet(any()))
        .thenAnswer((_) => Stream.value(_weightLogs));
    when(() => healthRepo.getVetVisitsForPet(any()))
        .thenAnswer((_) => Stream.value(_vetVisits));
    when(() => refRepo.fetchSpecies()).thenAnswer((_) async => [_species]);
    when(() => refRepo.fetchRacesBySpecies(any()))
        .thenAnswer((_) async => _races);
  });

  Widget buildPage(PetDetailsCubit cubit) {
    return MaterialApp(
      home: BlocProvider<PetDetailsCubit>.value(
        value: cubit,
        child: const PetHealthDiaryPage(),
      ),
    );
  }

  PetDetailsCubit createCubit() => PetDetailsCubit(
        petRepository: petRepo,
        healthRepository: healthRepo,
        referentialRepository: refRepo,
      );

  testWidgets('renders every carnet de santé section', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 2000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final cubit = createCubit();
    await tester.pumpWidget(buildPage(cubit));
    await tester.pumpAndSettle();

    expect(find.text('Récapitulatif'), findsOneWidget);
    expect(find.text('Vaccins'), findsOneWidget);
    expect(find.text('Visites vétérinaires'), findsOneWidget);
    expect(find.text('Évolution du poids'), findsOneWidget);
    expect(find.text('Typhus félin'), findsOneWidget);
    expect(find.text('Bilan annuel'), findsOneWidget);
    expect(find.text('Européen'), findsOneWidget);
    // expect(find.text('Exporter en PDF'), findsOneWidget);

    await cubit.close();
  });

  testWidgets('opens the add vaccine modal', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 2000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final cubit = createCubit();
    await tester.pumpWidget(buildPage(cubit));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ajouter un vaccin'));
    await tester.pumpAndSettle();

    expect(find.text('Nom du vaccin'), findsOneWidget);

    await cubit.close();
  });

  testWidgets('adds a vet visit through the modal', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 2000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final cubit = createCubit();
    await tester.pumpWidget(buildPage(cubit));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ajouter une visite'));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(TextField, 'Motif de la visite'), 'Rappel vaccin');
    await tester.tap(find.text('Sélectionner une date'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(400, 50));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    verify(() => healthRepo.addVetVisit(any())).called(1);

    await cubit.close();
  });
}
