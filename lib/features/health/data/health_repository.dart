import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_vaccine_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/vet_visit_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/weight_log_cache.dart';
import 'package:nanimo/features/health/data/models/health_diary_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_weight_log_model.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';

class HealthRepository {
  final SupabaseClient _supabase;
  final Isar _isar;

  HealthRepository(this._supabase, this._isar);

  /// Diary
  Stream<HealthDiaryModel?> watchDiaryForPet(String petId) {
    return _isar.healthDiaryCaches
        .filter()
        .petIdEqualTo(petId)
        .watch(fireImmediately: true)
        .map((rows) => rows.isEmpty ? null : rows.first.toModel());
  }

  Future<HealthDiaryModel?> getDiaryForPet(String petId) async {
    final row = await _isar.healthDiaryCaches.getByPetId(petId);
    return row?.toModel();
  }

  /// Watches every cached diary, used to map vaccines back to their pet.
  Stream<List<HealthDiaryModel>> watchAllDiaries() {
    return _isar.healthDiaryCaches
        .where()
        .watch(fireImmediately: true)
        .map((rows) => rows.map((c) => c.toModel()).toList());
  }

  Future<void> upsertDiary(HealthDiaryModel diary) async {
    try {
      await _supabase
          .from('health_diary')
          .upsert(diary.toJson(), onConflict: 'pet_id');
    } catch (e, st) {
      throw mapRepositoryError(e, st,
          operation: 'upsertDiary',
          networkMessage: 'Une connexion internet est requise pour mettre à jour le carnet de santé.',
          serverMessage: 'Impossible de mettre à jour le carnet de santé pour le moment.');
    }

    await _isar.writeTxn(() async {
      await _isar.healthDiaryCaches
          .putByHealthDiaryId(HealthDiaryCache.fromModel(diary));
    });
  }

  /// Vaccines
  Stream<List<HealthDiaryVaccineModel>> getVaccinesForDiary(
    String healthDiaryId,
  ) {
    return _isar.healthDiaryVaccineCaches
        .filter()
        .healthDiaryIdEqualTo(healthDiaryId)
        .sortByNextDate()
        .watch(fireImmediately: true)
        .map((rows) => rows.map((c) => c.toModel()).toList());
  }

  /// Watches every cached vaccine, across all diaries.
  Stream<List<HealthDiaryVaccineModel>> watchAllVaccines() {
    return _isar.healthDiaryVaccineCaches
        .where()
        .sortByNextDate()
        .watch(fireImmediately: true)
        .map((rows) => rows.map((c) => c.toModel()).toList());
  }

  /// Returns vaccines whose [HealthDiaryVaccineModel.nextDate] is in the future
  Future<List<HealthDiaryVaccineModel>> getUpcomingVaccinesForPet(
    String petId,
  ) async {
    final diary = await _isar.healthDiaryCaches.getByPetId(petId);
    if (diary == null) return [];

    final rows = await _isar.healthDiaryVaccineCaches
        .filter()
        .healthDiaryIdEqualTo(diary.healthDiaryId)
        .and()
        .nextDateGreaterThan(DateTime.now())
        .sortByNextDate()
        .findAll();
    return rows.map((c) => c.toModel()).toList();
  }

  Future<void> addVaccine(HealthDiaryVaccineModel vaccine) async {
    try {
      await _supabase.from('health_diary_vaccines').insert(vaccine.toJson());
    } catch (e, st) {
      throw mapRepositoryError(e, st,
          operation: 'addVaccine',
          networkMessage: 'Une connexion internet est requise pour ajouter un vaccin.',
          serverMessage: 'Impossible d’ajouter le vaccin pour le moment.');
    }

    await _isar.writeTxn(() async {
      await _isar.healthDiaryVaccineCaches.putByHealthDiaryVaccineId(
        HealthDiaryVaccineCache.fromModel(vaccine),
      );
    });
  }

  Future<void> updateVaccine(HealthDiaryVaccineModel vaccine) async {
    try {
      await _supabase
          .from('health_diary_vaccines')
          .update(vaccine.toJson())
          .eq('id_health_diary_vaccine', vaccine.healthDiaryVaccineId);
    } catch (e, st) {
      throw mapRepositoryError(e, st,
          operation: 'updateVaccine',
          networkMessage: 'Une connexion internet est requise pour modifier un vaccin.',
          serverMessage: 'Impossible de modifier le vaccin pour le moment.');
    }

    await _isar.writeTxn(() async {
      await _isar.healthDiaryVaccineCaches.putByHealthDiaryVaccineId(
        HealthDiaryVaccineCache.fromModel(vaccine),
      );
    });
  }

  Future<void> deleteVaccine(String healthDiaryVaccineId) async {
    try {
      await _supabase
          .from('health_diary_vaccines')
          .delete()
          .eq('id_health_diary_vaccine', healthDiaryVaccineId);
    } catch (e, st) {
      throw mapRepositoryError(e, st,
          operation: 'deleteVaccine',
          networkMessage: 'Une connexion internet est requise pour supprimer un vaccin.',
          serverMessage: 'Impossible de supprimer le vaccin pour le moment.');
    }

    await _isar.writeTxn(() async {
      await _isar.healthDiaryVaccineCaches
          .deleteByHealthDiaryVaccineId(healthDiaryVaccineId);
    });
  }

  /// Weight logs
  Stream<List<HealthDiaryWeightLogModel>> getWeightLogsForPet(String petId) {
    return _isar.weightLogCaches
        .filter()
        .petIdEqualTo(petId)
        .sortByLoggedAt()
        .watch(fireImmediately: true)
        .map((rows) => rows.map((c) => c.toModel()).toList());
  }

  Future<void> addWeightLog(HealthDiaryWeightLogModel log) async {
    try {
      await _supabase.from('health_diary_weight_log').insert(log.toJson());
    } catch (e, st) {
      throw mapRepositoryError(e, st,
          operation: 'addWeightLog',
          networkMessage: 'Une connexion internet est requise pour ajouter un poids.',
          serverMessage: 'Impossible d’ajouter le poids pour le moment.');
    }

    await _isar.writeTxn(() async {
      await _isar.weightLogCaches.putByHealthDiaryWeightLogId(
        WeightLogCache.fromModel(log),
      );
    });
  }

  Future<void> deleteWeightLog(String healthDiaryWeightLogId) async {
    try {
      await _supabase
          .from('health_diary_weight_log')
          .delete()
          .eq('id_health_diary_weight_log', healthDiaryWeightLogId);
    } catch (e, st) {
      throw mapRepositoryError(e, st,
          operation: 'deleteWeightLog',
          networkMessage: 'Une connexion internet est requise pour supprimer un poids.',
          serverMessage: 'Impossible de supprimer le poids pour le moment.');
    }

    await _isar.writeTxn(() async {
      await _isar.weightLogCaches
          .deleteByHealthDiaryWeightLogId(healthDiaryWeightLogId);
    });
  }

  /// Vet visits
  Stream<List<VetVisitModel>> getVetVisitsForPet(String petId) {
    return _isar.vetVisitCaches
        .filter()
        .petIdEqualTo(petId)
        .sortByVisitedAtDesc()
        .watch(fireImmediately: true)
        .map((rows) => rows.map((c) => c.toModel()).toList());
  }

  Future<void> addVetVisit(VetVisitModel visit) async {
    try {
      await _supabase.from('vet_visits').insert(visit.toJson());
    } catch (e, st) {
      throw mapRepositoryError(e, st,
          operation: 'addVetVisit',
          networkMessage: 'Une connexion internet est requise pour ajouter une visite vétérinaire.',
          serverMessage: 'Impossible d’ajouter la visite vétérinaire pour le moment.');
    }

    await _isar.writeTxn(() async {
      await _isar.vetVisitCaches
          .putByVetVisitId(VetVisitCache.fromModel(visit));
    });
  }

  Future<void> updateVetVisit(VetVisitModel visit) async {
    try {
      await _supabase
          .from('vet_visits')
          .update(visit.toJson())
          .eq('id_vet_visit', visit.vetVisitId);
    } catch (e, st) {
      throw mapRepositoryError(e, st,
          operation: 'updateVetVisit',
          networkMessage: 'Une connexion internet est requise pour modifier une visite vétérinaire.',
          serverMessage: 'Impossible de modifier la visite vétérinaire pour le moment.');
    }

    await _isar.writeTxn(() async {
      await _isar.vetVisitCaches
          .putByVetVisitId(VetVisitCache.fromModel(visit));
    });
  }

  Future<void> deleteVetVisit(String vetVisitId) async {
    try {
      await _supabase
          .from('vet_visits')
          .delete()
          .eq('id_vet_visit', vetVisitId);
    } catch (e, st) {
      throw mapRepositoryError(e, st,
          operation: 'deleteVetVisit',
          networkMessage: 'Une connexion internet est requise pour supprimer une visite vétérinaire.',
          serverMessage: 'Impossible de supprimer la visite vétérinaire pour le moment.');
    }

    await _isar.writeTxn(() async {
      await _isar.vetVisitCaches.deleteByVetVisitId(vetVisitId);
    });
  }
}
