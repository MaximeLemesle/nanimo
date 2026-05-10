import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nanimo/core/errors/repository_network_exception.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_vaccine_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/weight_log_cache.dart';
import 'package:nanimo/features/health/data/models/health_diary_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_weight_log_model.dart';

/// Wraps the three health collections (`health_diary`, `health_diary_vaccines`,
/// `weight_logs`) behind a single repository.
class HealthRepository {
  final SupabaseClient _supabase;
  final Isar _isar;

  HealthRepository(this._supabase, this._isar);

  // ---------------------------------------------------------------------------
  // Diary
  // ---------------------------------------------------------------------------

  /// Live diary for [petId], or null if none exists yet.
  Stream<HealthDiaryModel?> watchDiaryForPet(String petId) {
    return _isar.healthDiaryCaches
        .filter()
        .petIdEqualTo(petId)
        .watch(fireImmediately: true)
        .map((rows) => rows.isEmpty ? null : rows.first.toModel());
  }

  /// One-shot read of the diary for [petId].
  Future<HealthDiaryModel?> getDiaryForPet(String petId) async {
    final row = await _isar.healthDiaryCaches.getByPetId(petId);
    return row?.toModel();
  }

  /// Inserts or updates the diary for a pet.
  Future<void> upsertDiary(HealthDiaryModel diary) async {
    try {
      await _supabase
          .from('health_diary')
          .upsert(diary.toJson(), onConflict: 'pet_id');
    } catch (_) {
      throw const RepositoryNetworkException(
        'Une connexion internet est requise pour mettre à jour le carnet de santé.',
      );
    }

    await _isar.writeTxn(() async {
      await _isar.healthDiaryCaches
          .putByHealthDiaryId(HealthDiaryCache.fromModel(diary));
    });
  }

  // ---------------------------------------------------------------------------
  // Vaccines
  // ---------------------------------------------------------------------------

  /// Live vaccines for a diary, ordered by next due date.
  Stream<List<HealthDiaryVaccineModel>> watchVaccinesForDiary(
    String healthDiaryId,
  ) {
    return _isar.healthDiaryVaccineCaches
        .filter()
        .healthDiaryIdEqualTo(healthDiaryId)
        .sortByNextDate()
        .watch(fireImmediately: true)
        .map((rows) => rows.map((c) => c.toModel()).toList());
  }

  /// Returns vaccines whose [HealthDiaryVaccineModel.nextDate] is in the future
  /// for [petId]. Used by the home alerts widget.
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

  /// Inserts a new vaccine entry.
  Future<void> addVaccine(HealthDiaryVaccineModel vaccine) async {
    try {
      await _supabase.from('health_diary_vaccines').insert(vaccine.toJson());
    } catch (_) {
      throw const RepositoryNetworkException(
        'Une connexion internet est requise pour ajouter un vaccin.',
      );
    }

    await _isar.writeTxn(() async {
      await _isar.healthDiaryVaccineCaches.putByHealthDiaryVaccineId(
        HealthDiaryVaccineCache.fromModel(vaccine),
      );
    });
  }

  /// Updates an existing vaccine entry.
  Future<void> updateVaccine(HealthDiaryVaccineModel vaccine) async {
    try {
      await _supabase
          .from('health_diary_vaccines')
          .update(vaccine.toJson())
          .eq('id_health_diary_vaccine', vaccine.healthDiaryVaccineId);
    } catch (_) {
      throw const RepositoryNetworkException(
        'Une connexion internet est requise pour modifier un vaccin.',
      );
    }

    await _isar.writeTxn(() async {
      await _isar.healthDiaryVaccineCaches.putByHealthDiaryVaccineId(
        HealthDiaryVaccineCache.fromModel(vaccine),
      );
    });
  }

  /// Removes a vaccine entry.
  Future<void> deleteVaccine(String healthDiaryVaccineId) async {
    try {
      await _supabase
          .from('health_diary_vaccines')
          .delete()
          .eq('id_health_diary_vaccine', healthDiaryVaccineId);
    } catch (_) {
      throw const RepositoryNetworkException(
        'Une connexion internet est requise pour supprimer un vaccin.',
      );
    }

    await _isar.writeTxn(() async {
      await _isar.healthDiaryVaccineCaches
          .deleteByHealthDiaryVaccineId(healthDiaryVaccineId);
    });
  }

  // ---------------------------------------------------------------------------
  // Weight logs
  // ---------------------------------------------------------------------------

  /// Live weight history for [petId] within [window] (default 6 months),
  /// oldest first — ready for a chart.
  Stream<List<HealthDiaryWeightLogModel>> watchWeightLogsForPet(
    String petId, {
    Duration window = const Duration(days: 180),
  }) {
    final since = DateTime.now().subtract(window);
    return _isar.weightLogCaches
        .filter()
        .petIdEqualTo(petId)
        .and()
        .loggedAtGreaterThan(since)
        .sortByLoggedAt()
        .watch(fireImmediately: true)
        .map((rows) => rows.map((c) => c.toModel()).toList());
  }

  /// Inserts a new weight measurement.
  Future<void> addWeightLog(HealthDiaryWeightLogModel log) async {
    try {
      await _supabase.from('weight_logs').insert(log.toJson());
    } catch (_) {
      throw const RepositoryNetworkException(
        'Une connexion internet est requise pour ajouter un poids.',
      );
    }

    await _isar.writeTxn(() async {
      await _isar.weightLogCaches.putByHealthDiaryWeightLogId(
        WeightLogCache.fromModel(log),
      );
    });
  }

  /// Removes a weight measurement.
  Future<void> deleteWeightLog(String healthDiaryWeightLogId) async {
    try {
      await _supabase
          .from('weight_logs')
          .delete()
          .eq('id_health_diary_weight_log', healthDiaryWeightLogId);
    } catch (_) {
      throw const RepositoryNetworkException(
        'Une connexion internet est requise pour supprimer un poids.',
      );
    }

    await _isar.writeTxn(() async {
      await _isar.weightLogCaches
          .deleteByHealthDiaryWeightLogId(healthDiaryWeightLogId);
    });
  }
}
