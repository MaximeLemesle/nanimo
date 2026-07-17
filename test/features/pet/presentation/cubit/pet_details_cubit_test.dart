import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/data/models/referential/pet_race_model.dart';
import 'package:nanimo/data/models/referential/pet_species_model.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/health/data/health_repository.dart';
import 'package:nanimo/features/health/data/models/health_diary_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_weight_log_model.dart';
import 'package:nanimo/features/health/data/models/recommended_vaccines_model.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_details_cubit.dart';

class _MockPetRepository extends Mock implements PetRepository {}

class _MockHealthRepository extends Mock implements HealthRepository {}

class _MockReferentialRepository extends Mock
    implements ReferentialRepository {}

final _pet1 = PetModel(
  petId: 'p1',
  petName: 'Yummy',
  birthdate: DateTime(2024, 1, 1),
  gender: Gender.male,
  createdAt: DateTime(2024, 1, 1),
  petRaceId: 'r1',
  petSpeciesId: 's1',
);

final _pet2 = PetModel(
  petId: 'p2',
  petName: 'Rex',
  birthdate: DateTime(2022, 6, 1),
  gender: Gender.female,
  createdAt: DateTime(2022, 6, 1),
  petRaceId: 'r1',
  petSpeciesId: 's1',
);

const _species = PetSpeciesModel(
  petSpeciesId: 's1',
  speciesName: 'Chat',
  weightUnit: WeightUnit.kg,
  iconKey: 'cat',
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
    registerFallbackValue(
      HealthDiaryModel(healthDiaryId: 'fallback', petId: 'p'),
    );
    registerFallbackValue(
      HealthDiaryVaccineModel(
        healthDiaryVaccineId: 'fallback',
        vaccineName: 'x',
        lastDate: DateTime(2026, 1, 1),
        nextDate: DateTime(2026, 6, 1),
        recurrence: 0,
        doseNumber: 1,
        totalDoseNumber: 1,
        healthDiaryId: 'd1',
      ),
    );
    registerFallbackValue(
      VetVisitModel(
        vetVisitId: 'fallback',
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

    when(() => petRepo.watchPets())
        .thenAnswer((_) => Stream.value([_pet1, _pet2]));
    when(() => healthRepo.watchDiaryForPet(any()))
        .thenAnswer((_) => Stream.value(_diary));
    when(() => healthRepo.getVaccinesForDiary(any()))
        .thenAnswer((_) => Stream.value(const <HealthDiaryVaccineModel>[]));
    when(() => healthRepo.getWeightLogsForPet(any()))
        .thenAnswer((_) => Stream.value(_weightLogs));
    when(() => healthRepo.getVetVisitsForPet(any()))
        .thenAnswer((_) => Stream.value(const <VetVisitModel>[]));
    when(() => healthRepo.addWeightLog(any())).thenAnswer((_) async {});
    when(() => healthRepo.upsertDiary(any())).thenAnswer((_) async {});
    when(() => healthRepo.addVaccine(any())).thenAnswer((_) async {});
    when(() => healthRepo.updateVaccine(any())).thenAnswer((_) async {});
    when(() => healthRepo.addVetVisit(any())).thenAnswer((_) async {});
    when(() => refRepo.fetchSpecies()).thenAnswer((_) async => [_species]);
    when(() => refRepo.fetchRacesBySpecies(any()))
        .thenAnswer((_) async => _races);
  });

  PetDetailsCubit createCubit() => PetDetailsCubit(
        petRepository: petRepo,
        healthRepository: healthRepo,
        referentialRepository: refRepo,
      );

  Future<void> settle() =>
      Future<void>.delayed(const Duration(milliseconds: 20));

  test('selects the first pet by default and loads its details', () async {
    final cubit = createCubit();
    await settle();

    expect(cubit.state.status, PetDetailsStatus.loaded);
    expect(cubit.state.selectedPetId, 'p1');
    expect(cubit.state.speciesNameById['s1'], 'Chat');
    expect(cubit.state.iconsKey['s1'], 'cat');
    expect(cubit.state.raceName, 'Européen');
    expect(cubit.state.latestWeight, 3.2);
    expect(cubit.state.diary, _diary);

    await cubit.close();
  });

  test('selectPet switches the selected pet', () async {
    final cubit = createCubit();
    await settle();

    cubit.selectPet('p2');
    expect(cubit.state.selectedPetId, 'p2');

    await cubit.close();
  });

  test('addWeightLog forwards a new log to the repository', () async {
    final cubit = createCubit();
    await settle();

    final loggedAt = DateTime(2026, 6, 21);
    await cubit.addWeightLog(4.5, loggedAt);

    final captured = verify(() => healthRepo.addWeightLog(captureAny()))
        .captured
        .single as HealthDiaryWeightLogModel;
    expect(captured.weight, 4.5);
    expect(captured.loggedAt, loggedAt);
    expect(captured.petId, 'p1');

    await cubit.close();
  });

  test('addWeightLog targets petId without moving the selection', () async {
    final cubit = createCubit();
    await settle();
    expect(cubit.state.selectedPetId, 'p1');

    await cubit.addWeightLog(6.2, DateTime(2026, 6, 21), petId: 'p2');

    final captured = verify(() => healthRepo.addWeightLog(captureAny()))
        .captured
        .single as HealthDiaryWeightLogModel;
    expect(captured.petId, 'p2');
    expect(cubit.state.selectedPetId, 'p1');

    await cubit.close();
  });

  test('addWeightLog emits an error when the repository throws', () async {
    when(() => healthRepo.addWeightLog(any())).thenThrow(Exception('boom'));
    final cubit = createCubit();
    await settle();

    await cubit.addWeightLog(4.5, DateTime(2026, 6, 21));
    expect(cubit.state.error, isNotNull);

    cubit.clearError();
    expect(cubit.state.error, isNull);

    await cubit.close();
  });

  test('exposes the full weight log list and vet visits', () async {
    final cubit = createCubit();
    await settle();

    expect(cubit.state.weightLogs, _weightLogs);
    expect(cubit.state.vetVisits, isEmpty);

    await cubit.close();
  });

  test('updateDiary reuses the existing diary id', () async {
    final cubit = createCubit();
    await settle();

    await cubit.updateDiary(isSterilized: false, isChipped: true);

    final captured = verify(() => healthRepo.upsertDiary(captureAny()))
        .captured
        .single as HealthDiaryModel;
    expect(captured.healthDiaryId, 'd1');
    expect(captured.isSterilized, false);
    expect(captured.petId, 'p1');

    await cubit.close();
  });

  test('addVaccine forwards a new vaccine to the repository', () async {
    final cubit = createCubit();
    await settle();

    await cubit.addVaccine(
      vaccineName: 'Rage',
      lastDate: DateTime(2026, 1, 1),
      nextDate: DateTime(2027, 1, 1),
    );

    final captured = verify(() => healthRepo.addVaccine(captureAny()))
        .captured
        .single as HealthDiaryVaccineModel;
    expect(captured.vaccineName, 'Rage');
    expect(captured.healthDiaryId, 'd1');

    await cubit.close();
  });

  test('addVetVisit forwards a new visit to the repository', () async {
    final cubit = createCubit();
    await settle();

    await cubit.addVetVisit(
      title: 'Bilan annuel',
      visitedAt: DateTime(2026, 1, 14),
      vetName: 'Dr.Martin',
    );

    final captured = verify(() => healthRepo.addVetVisit(captureAny()))
        .captured
        .single as VetVisitModel;
    expect(captured.title, 'Bilan annuel');
    expect(captured.vetName, 'Dr.Martin');
    expect(captured.petId, 'p1');

    await cubit.close();
  });

  test('createHealthDiary persists diary, weight, vaccine and visit',
      () async {
    final cubit = createCubit();
    await settle();

    await cubit.createHealthDiary(
      birthWeight: 0.3,
      birthWeightDate: DateTime(2024, 1, 1),
      isSterilized: false,
      isChipped: true,
      chipNumber: '250269',
      lastDeworming: DateTime(2026, 3, 1),
      vaccines: [
        (
          name: 'Typhus félin',
          lastDate: DateTime(2025, 1, 1),
          nextDate: DateTime(2026, 1, 1),
          recurrence: 365,
        ),
      ],
      vetVisits: [
        (
          title: 'Première visite',
          visitedAt: DateTime(2024, 2, 1),
          vetName: 'Dr. Martin',
          clinicName: null,
        ),
      ],
    );

    final diary = verify(() => healthRepo.upsertDiary(captureAny()))
        .captured
        .single as HealthDiaryModel;
    expect(diary.healthDiaryId, 'd1');
    expect(diary.isChipped, true);
    expect(diary.chipNumber, '250269');
    expect(diary.lastDeworming, DateTime(2026, 3, 1));

    final weight = verify(() => healthRepo.addWeightLog(captureAny()))
        .captured
        .single as HealthDiaryWeightLogModel;
    expect(weight.weight, 0.3);
    expect(weight.loggedAt, DateTime(2024, 1, 1));

    final vaccine = verify(() => healthRepo.addVaccine(captureAny()))
        .captured
        .single as HealthDiaryVaccineModel;
    expect(vaccine.vaccineName, 'Typhus félin');
    expect(vaccine.healthDiaryId, 'd1');

    final visit = verify(() => healthRepo.addVetVisit(captureAny()))
        .captured
        .single as VetVisitModel;
    expect(visit.title, 'Première visite');
    expect(visit.petId, 'p1');

    await cubit.close();
  });

  test('createHealthDiary skips the weight log when no weight given',
      () async {
    final cubit = createCubit();
    await settle();

    await cubit.createHealthDiary(isSterilized: true);

    verify(() => healthRepo.upsertDiary(any())).called(1);
    verifyNever(() => healthRepo.addWeightLog(any()));

    await cubit.close();
  });

  group('recommendedVaccines follow the selected pet species', () {
    final rabbit = PetModel(
      petId: 'p3',
      petName: 'Pompon',
      birthdate: DateTime(2025, 3, 1),
      gender: Gender.male,
      createdAt: DateTime(2025, 3, 1),
      petRaceId: 'r2',
      petSpeciesId: 's2',
    );

    const catVaccines = [
      RecommendedVaccineModel(
        name: 'Typhus félin',
        category: 'core',
        recurrenceDays: 365,
      ),
    ];
    const rabbitVaccines = [
      RecommendedVaccineModel(
        name: 'Myxomatose',
        category: 'core',
        recurrenceDays: 180,
      ),
    ];

    setUp(() {
      when(() => petRepo.watchPets())
          .thenAnswer((_) => Stream.value([_pet1, rabbit]));
      when(() => refRepo.fetchRecommendedVaccinesBySpecies('s1'))
          .thenAnswer((_) async => catVaccines);
      when(() => refRepo.fetchRecommendedVaccinesBySpecies('s2'))
          .thenAnswer((_) async => rabbitVaccines);
    });

    test('loads the vaccines of the initially selected pet', () async {
      final cubit = createCubit();
      await settle();

      expect(cubit.state.recommendedVaccines, catVaccines);

      await cubit.close();
    });

    test('drops the previous species vaccines as soon as the pet switches',
        () async {
      final cubit = createCubit();
      await settle();
      expect(cubit.state.recommendedVaccines, catVaccines);

      /// No await: this is the window where the health diary sheet could be
      /// opened, and it must never be offered the cat's vaccines for a rabbit.
      cubit.selectPet('p3');
      expect(cubit.state.recommendedVaccines, isEmpty);

      await settle();
      expect(cubit.state.recommendedVaccines, rabbitVaccines);

      await cubit.close();
    });

    test('ignores a response that lands after the pet was switched away',
        () async {
      when(() => refRepo.fetchRecommendedVaccinesBySpecies('s1')).thenAnswer(
        (_) => Future.delayed(
          const Duration(milliseconds: 60),
          () => catVaccines,
        ),
      );

      final cubit = createCubit();

      /// Switch away while the cat request is still in flight.
      await settle();
      cubit.selectPet('p3');
      await Future<void>.delayed(const Duration(milliseconds: 120));

      expect(cubit.state.selectedPetId, 'p3');
      expect(cubit.state.recommendedVaccines, rabbitVaccines);

      await cubit.close();
    });
  });

  group('hasHealthData', () {
    test('is false on an empty state', () {
      expect(const PetDetailsState().hasHealthData, isFalse);
    });

    test('is true when the diary holds information', () {
      final state = PetDetailsState(
        diary: HealthDiaryModel(
          healthDiaryId: 'd1',
          petId: 'p1',
          isSterilized: true,
        ),
      );
      expect(state.hasHealthData, isTrue);
    });

    test('is true when weight logs exist', () {
      final state = PetDetailsState(weightLogs: _weightLogs);
      expect(state.hasHealthData, isTrue);
    });
  });
}
