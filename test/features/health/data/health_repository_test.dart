import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_vaccine_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/vet_visit_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/weight_log_cache.dart';
import 'package:nanimo/features/health/data/health_repository.dart';
import 'package:nanimo/features/health/data/models/health_diary_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_weight_log_model.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';

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

VetVisitModel buildVisit(
  String id, {
  String petId = 'pet-1',
  DateTime? visitedAt,
}) {
  return VetVisitModel(
    vetVisitId: id,
    title: 'Bilan annuel',
    visitedAt: visitedAt ?? DateTime.utc(2026, 1, 14),
    vetName: 'Dr.Martin',
    clinicName: 'Clinique des Pins',
    petId: petId,
  );
}

void main() {
  setUpAll(registerSupabaseFallbacks);

  final harness = IsarTestHarness();
  late HealthRepository repo;
  late MockSupabaseClient supabase;

  setUp(() async {
    await harness.setUp();
    supabase = MockSupabaseClient();
    repo = HealthRepository(supabase, harness.isar);
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

  Future<void> seedVisit(VetVisitModel m) async {
    await harness.isar.writeTxn(() async {
      await harness.isar.vetVisitCaches
          .putByVetVisitId(VetVisitCache.fromModel(m));
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
      final emission = await repo.getVaccinesForDiary('d1').first;
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

      final emission = await repo.getVaccinesForDiary('d1').first;
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

  group('getWeightLogsForPet', () {
    test('emits empty when no log exists for the pet', () async {
      final emission = await repo.getWeightLogsForPet('pet-1').first;
      expect(emission, isEmpty);
    });

    test('emits logs sorted oldest first', () async {
      await seedWeight(buildWeightLog(
        'w-2',
        loggedAt: DateTime.now().subtract(const Duration(days: 30)),
      ));
      await seedWeight(buildWeightLog(
        'w-3',
        loggedAt: DateTime.now().subtract(const Duration(days: 5)),
      ));
      await seedWeight(buildWeightLog(
        'w-1',
        loggedAt: DateTime.now().subtract(const Duration(days: 365)),
      ));
      await seedWeight(buildWeightLog('w-other', petId: 'pet-2'));

      final emission = await repo.getWeightLogsForPet('pet-1').first;
      expect(
        emission.map((l) => l.healthDiaryWeightLogId).toList(),
        ['w-1', 'w-2', 'w-3'],
      );
    });
  });

  group('getVetVisitsForPet', () {
    test('emits empty when no visit exists for the pet', () async {
      final emission = await repo.getVetVisitsForPet('pet-1').first;
      expect(emission, isEmpty);
    });

    test('emits the pet visits, most recent first', () async {
      await seedVisit(buildVisit('old', visitedAt: DateTime.utc(2025, 1, 1)));
      await seedVisit(buildVisit('new', visitedAt: DateTime.utc(2026, 1, 1)));
      await seedVisit(buildVisit('other', petId: 'pet-2'));

      final emission = await repo.getVetVisitsForPet('pet-1').first;
      expect(emission.map((v) => v.vetVisitId).toList(), ['new', 'old']);
    });
  });

  group('addVetVisit', () {
    test('inserts in Supabase and caches the visit', () async {
      stubInsert(supabase, 'vet_visits', resolver: () => null);

      await repo.addVetVisit(buildVisit('v1'));

      final cached = await harness.isar.vetVisitCaches.getByVetVisitId('v1');
      expect(cached, isNotNull);
      expect(cached!.title, 'Bilan annuel');
    });

    test('throws and does not cache when Supabase fails', () async {
      stubInsert(supabase, 'vet_visits',
          resolver: () => throw Exception('offline'));

      await expectLater(repo.addVetVisit(buildVisit('v1')), throwsException);
      expect(await harness.isar.vetVisitCaches.getByVetVisitId('v1'), isNull);
    });
  });

  group('deleteVetVisit', () {
    test('removes the visit from cache', () async {
      await seedVisit(buildVisit('v1'));
      stubDelete(supabase, 'vet_visits', resolver: () => null);

      await repo.deleteVetVisit('v1');

      expect(await harness.isar.vetVisitCaches.getByVetVisitId('v1'), isNull);
    });
  });
}
