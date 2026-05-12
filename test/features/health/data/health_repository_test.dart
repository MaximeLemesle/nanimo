import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_vaccine_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/weight_log_cache.dart';
import 'package:nanimo/features/health/data/health_repository.dart';
import 'package:nanimo/features/health/data/models/health_diary_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_weight_log_model.dart';

import '../../../helpers/isar_test_helper.dart';
import '../../../helpers/supabase_mocks.dart';

HealthDiaryModel buildDiary(String id, String petId) {
  return HealthDiaryModel(
    healthDiaryId: id,
    petId: petId,
    isSterilized: true,
    isChipped: true,
    chipNumber: '12345',
  );
}

HealthDiaryVaccineModel buildVaccine(
  String id, {
  required String diaryId,
  DateTime? nextDate,
}) {
  return HealthDiaryVaccineModel(
    healthDiaryVaccineId: id,
    vaccineName: 'Rage',
    lastDate: DateTime.utc(2024, 1, 1),
    nextDate: nextDate ?? DateTime.utc(2026, 1, 1),
    recurrence: 365,
    doseNumber: 1,
    totalDoseNumber: 1,
    healthDiaryId: diaryId,
  );
}

HealthDiaryWeightLogModel buildWeightLog(
  String id, {
  String petId = 'pet-1',
  double weight = 5.5,
  DateTime? loggedAt,
}) {
  return HealthDiaryWeightLogModel(
    healthDiaryWeightLogId: id,
    weight: weight,
    loggedAt: loggedAt ?? DateTime.now().subtract(const Duration(days: 1)),
    petId: petId,
  );
}

void main() {
  final harness = IsarTestHarness();
  late HealthRepository repo;

  setUp(() async {
    await harness.setUp();
    repo = HealthRepository(MockSupabaseClient(), harness.isar);
  });

  tearDown(() async {
    await harness.tearDown();
  });

  Future<void> seedDiary(HealthDiaryModel m) async {
    await harness.isar.writeTxn(() async {
      await harness.isar.healthDiaryCaches
          .putByHealthDiaryId(HealthDiaryCache.fromModel(m));
    });
  }

  Future<void> seedVaccine(HealthDiaryVaccineModel m) async {
    await harness.isar.writeTxn(() async {
      await harness.isar.healthDiaryVaccineCaches
          .putByHealthDiaryVaccineId(HealthDiaryVaccineCache.fromModel(m));
    });
  }

  Future<void> seedWeight(HealthDiaryWeightLogModel m) async {
    await harness.isar.writeTxn(() async {
      await harness.isar.weightLogCaches
          .putByHealthDiaryWeightLogId(WeightLogCache.fromModel(m));
    });
  }

  group('watchDiaryForPet', () {
    test('emits null when no diary exists', () async {
      final emission = await repo.watchDiaryForPet('pet-1').first;
      expect(emission, isNull);
    });

    test('emits the cached diary when present', () async {
      await seedDiary(buildDiary('d1', 'pet-1'));

      final emission = await repo.watchDiaryForPet('pet-1').first;
      expect(emission, isNotNull);
      expect(emission!.healthDiaryId, 'd1');
    });
  });

  group('getDiaryForPet', () {
    test('returns null when missing', () async {
      expect(await repo.getDiaryForPet('pet-1'), isNull);
    });

    test('returns the cached diary when present', () async {
      await seedDiary(buildDiary('d1', 'pet-1'));

      final result = await repo.getDiaryForPet('pet-1');
      expect(result, isNotNull);
      expect(result!.healthDiaryId, 'd1');
    });
  });

  group('watchVaccinesForDiary', () {
    test('emits empty when nothing is cached', () async {
      final emission = await repo.watchVaccinesForDiary('d1').first;
      expect(emission, isEmpty);
    });

    test('emits vaccines sorted by next due date ascending', () async {
      await seedVaccine(buildVaccine(
        'v2',
        diaryId: 'd1',
        nextDate: DateTime.utc(2027, 1, 1),
      ));
      await seedVaccine(buildVaccine(
        'v1',
        diaryId: 'd1',
        nextDate: DateTime.utc(2026, 1, 1),
      ));

      final emission = await repo.watchVaccinesForDiary('d1').first;
      expect(
        emission.map((v) => v.healthDiaryVaccineId).toList(),
        ['v1', 'v2'],
      );
    });
  });

  group('getUpcomingVaccinesForPet', () {
    test('returns empty when no diary is cached for the pet', () async {
      expect(await repo.getUpcomingVaccinesForPet('pet-1'), isEmpty);
    });

    test('returns only vaccines whose nextDate is in the future, sorted',
        () async {
      await seedDiary(buildDiary('d1', 'pet-1'));
      await seedVaccine(buildVaccine(
        'past',
        diaryId: 'd1',
        nextDate: DateTime.now().subtract(const Duration(days: 5)),
      ));
      await seedVaccine(buildVaccine(
        'soon',
        diaryId: 'd1',
        nextDate: DateTime.now().add(const Duration(days: 10)),
      ));
      await seedVaccine(buildVaccine(
        'later',
        diaryId: 'd1',
        nextDate: DateTime.now().add(const Duration(days: 60)),
      ));

      final result = await repo.getUpcomingVaccinesForPet('pet-1');
      expect(
        result.map((v) => v.healthDiaryVaccineId).toList(),
        ['soon', 'later'],
      );
    });
  });

  group('watchWeightLogsForPet', () {
    test('emits empty when no log exists for the pet', () async {
      final emission = await repo.watchWeightLogsForPet('pet-1').first;
      expect(emission, isEmpty);
    });

    test('emits logs within the window, sorted oldest first', () async {
      await seedWeight(buildWeightLog(
        'w-old',
        loggedAt: DateTime.now().subtract(const Duration(days: 30)),
      ));
      await seedWeight(buildWeightLog(
        'w-new',
        loggedAt: DateTime.now().subtract(const Duration(days: 5)),
      ));
      await seedWeight(buildWeightLog(
        'w-out',
        loggedAt: DateTime.now().subtract(const Duration(days: 365)),
      ));
      await seedWeight(buildWeightLog('w-other', petId: 'pet-2'));

      final emission = await repo.watchWeightLogsForPet('pet-1').first;
      expect(
        emission.map((l) => l.healthDiaryWeightLogId).toList(),
        ['w-old', 'w-new'],
      );
    });
  });
}
