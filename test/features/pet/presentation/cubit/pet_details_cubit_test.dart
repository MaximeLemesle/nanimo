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

  Future<void> settle() => Future<void>.delayed(const Duration(milliseconds: 20));

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

    await cubit.addWeightLog(4.5);

    final captured = verify(() => healthRepo.addWeightLog(captureAny()))
        .captured
        .single as HealthDiaryWeightLogModel;
    expect(captured.weight, 4.5);
    expect(captured.petId, 'p1');

    await cubit.close();
  });

  test('addWeightLog emits an error when the repository throws', () async {
    when(() => healthRepo.addWeightLog(any())).thenThrow(Exception('boom'));
    final cubit = createCubit();
    await settle();

    await cubit.addWeightLog(4.5);
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
}
