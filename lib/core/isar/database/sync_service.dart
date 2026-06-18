import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nanimo/core/isar/cache/schemas/event_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/event_image_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_vaccine_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/pet_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/subscription_config_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/user_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/vet_visit_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/weight_log_cache.dart';

class SyncService {
  final SupabaseClient _supabase;
  final Isar _isar;

  SyncService(this._supabase, this._isar);

  /// Wave 1 — awaited before Home renders. Syncs user, pets and subscription config.
  Future<void> syncCritical() async {
    await Future.wait([_syncUser(), _syncPets(), _syncSubscriptionConfig()]);
  }

  /// Wave 2 — fire and forget after Home renders.
  void syncSecondary() {
    Future(() async {
      await _syncEvents();
      await _syncEventImages();
      await _syncHealthDiaries();
      await _syncHealthDiaryVaccines();
      await _syncWeightLogs();
      await _syncVetVisits();
    });
  }

  Future<void> _syncUser() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final data =
          await _supabase.from('users').select().eq('id_user', userId).single();

      final user = UserCache.fromJson(data);
      await _isar.writeTxn(() async {
        await _isar.userCaches.putByUserId(user);
      });
    } catch (_) {}
  }

  Future<void> _syncSubscriptionConfig() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final data = await _supabase
          .from('users')
          .select('id_subscription_config, subscription_config(*)')
          .eq('id_user', userId)
          .single();

      final configJson = data['subscription_config'];
      if (configJson is! Map<String, dynamic>) return;

      final cache = SubscriptionConfigCache.fromJson(configJson);
      await _isar.writeTxn(() async {
        await _isar.subscriptionConfigCaches.putByConfigId(cache);
      });
    } catch (_) {}
  }

  Future<void> _syncPets() async {
    try {
      final data = await _supabase.from('pets').select();
      final pets = (data as List)
          .map((e) => PetCache.fromJson(e as Map<String, dynamic>))
          .toList();
      await _isar.writeTxn(() async {
        await _isar.petCaches.putAllByPetId(pets);
      });
    } catch (_) {}
  }

  Future<void> _syncEvents() async {
    try {
      final data = await _supabase.from('events').select();
      final events = (data as List)
          .map((e) => EventCache.fromJson(e as Map<String, dynamic>))
          .toList();
      await _isar.writeTxn(() async {
        await _isar.eventCaches.putAllByEventId(events);
      });
    } catch (_) {}
  }

  Future<void> _syncEventImages() async {
    try {
      final data = await _supabase.from('event_image').select();
      final images = (data as List)
          .map((e) => EventImageCache.fromJson(e as Map<String, dynamic>))
          .toList();
      await _isar.writeTxn(() async {
        await _isar.eventImageCaches.putAllByEventImageId(images);
      });
    } catch (_) {}
  }

  Future<void> _syncHealthDiaries() async {
    try {
      final data = await _supabase.from('health_diary').select();
      final diaries = (data as List)
          .map((e) => HealthDiaryCache.fromJson(e as Map<String, dynamic>))
          .toList();
      await _isar.writeTxn(() async {
        await _isar.healthDiaryCaches.putAllByHealthDiaryId(diaries);
      });
    } catch (_) {}
  }

  Future<void> _syncHealthDiaryVaccines() async {
    try {
      final data = await _supabase.from('health_diary_vaccines').select();
      final vaccines = (data as List)
          .map((e) =>
              HealthDiaryVaccineCache.fromJson(e as Map<String, dynamic>))
          .toList();
      await _isar.writeTxn(() async {
        await _isar.healthDiaryVaccineCaches
            .putAllByHealthDiaryVaccineId(vaccines);
      });
    } catch (_) {}
  }

  Future<void> _syncWeightLogs() async {
    try {
      final data = await _supabase.from('health_diary_weight_log').select();
      final logs = (data as List)
          .map((e) => WeightLogCache.fromJson(e as Map<String, dynamic>))
          .toList();
      await _isar.writeTxn(() async {
        await _isar.weightLogCaches.putAllByHealthDiaryWeightLogId(logs);
      });
    } catch (_) {}
  }

  Future<void> _syncVetVisits() async {
    try {
      final data = await _supabase.from('vet_visits').select();
      final visits = (data as List)
          .map((e) => VetVisitCache.fromJson(e as Map<String, dynamic>))
          .toList();
      await _isar.writeTxn(() async {
        await _isar.vetVisitCaches.putAllByVetVisitId(visits);
      });
    } catch (_) {}
  }
}
