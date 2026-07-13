import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nanimo/core/isar/cache/schemas/event_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/event_image_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/event_type_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/pet_species_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/pet_event_cache.dart';
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
      await _syncPetEvents();
      await _syncHealthDiaries();
      await _syncHealthDiaryVaccines();
      await _syncWeightLogs();
      await _syncVetVisits();
      await _syncReferential();
    });
  }

  Future<void> clearAllCaches() async {
    await _isar.writeTxn(() async {
      await _isar.clear();
    });
  }

  Future<void> _syncUser() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      debugPrint('[log] currentUser=$userId');
      if (userId == null) return;

      final data = await _supabase.from('users').select().eq('id_user', userId).single();

      final user = UserCache.fromJson(data);
      await _isar.writeTxn(() async {
        await _isar.userCaches.putByUserId(user);
      });
    } catch (e, st) {
      developer.log('syncUser failed', name: 'sync', error: e, stackTrace: st);
    }
  }

  Future<void> _syncSubscriptionConfig() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final data = await _supabase.from('users').select('id_subscription_config, subscription_config(*)').eq('id_user', userId).single();

      final configJson = data['subscription_config'];
      if (configJson is! Map<String, dynamic>) return;

      final cache = SubscriptionConfigCache.fromJson(configJson);
      await _isar.writeTxn(() async {
        await _isar.subscriptionConfigCaches.putByConfigId(cache);
      });
    } catch (e, st) {
      developer.log('syncSubscriptionConfig failed', name: 'sync', error: e, stackTrace: st);
    }
  }

  Future<void> _syncPets() async {
    try {
      final data = await _supabase.from('pets').select();
      final pets = data.map((e) => PetCache.fromJson(e)).toList();
      await _isar.writeTxn(() async {
        await _isar.petCaches.clear();
        await _isar.petCaches.putAllByPetId(pets);
      });
    } catch (e, st) {
      developer.log('syncPets failed', name: 'sync', error: e, stackTrace: st);
    }
  }

  Future<void> _syncEvents() async {
    try {
      final data = await _supabase.from('events').select();
      final events = data.map((e) => EventCache.fromJson(e)).toList();
      await _isar.writeTxn(() async {
        await _isar.eventCaches.clear();
        await _isar.eventCaches.putAllByEventId(events);
      });
    } catch (e, st) {
      developer.log('syncEvents failed', name: 'sync', error: e, stackTrace: st);
    }
  }

  Future<void> _syncEventImages() async {
    try {
      final data = await _supabase.from('event_image').select();
      final images = (data as List).map((e) => EventImageCache.fromJson(e as Map<String, dynamic>)).toList();
      await _isar.writeTxn(() async {
        await _isar.eventImageCaches.clear();
        await _isar.eventImageCaches.putAllByEventImageId(images);
      });
    } catch (e, st) {
      developer.log('syncEventImages failed', name: 'sync', error: e, stackTrace: st);
    }
  }

  Future<void> _syncPetEvents() async {
    try {
      final data = await _supabase.from('pets_events').select();
      final links = (data as List).map((e) => PetEventCache.fromJson(e as Map<String, dynamic>)).toList();
      await _isar.writeTxn(() async {
        await _isar.petEventCaches.clear();
        await _isar.petEventCaches.putAllByPetEventId(links);
      });
    } catch (e, st) {
      developer.log('syncPetEvents failed', name: 'sync', error: e, stackTrace: st);
    }
  }

  Future<void> _syncHealthDiaries() async {
    try {
      final data = await _supabase.from('health_diary').select();
      final diaries = (data as List).map((e) => HealthDiaryCache.fromJson(e as Map<String, dynamic>)).toList();
      await _isar.writeTxn(() async {
        await _isar.healthDiaryCaches.clear();
        await _isar.healthDiaryCaches.putAllByHealthDiaryId(diaries);
      });
    } catch (e, st) {
      developer.log('syncHealthDiaries failed', name: 'sync', error: e, stackTrace: st);
    }
  }

  Future<void> _syncHealthDiaryVaccines() async {
    try {
      final data = await _supabase.from('health_diary_vaccines').select();
      final vaccines = (data as List).map((e) => HealthDiaryVaccineCache.fromJson(e as Map<String, dynamic>)).toList();
      await _isar.writeTxn(() async {
        await _isar.healthDiaryVaccineCaches.clear();
        await _isar.healthDiaryVaccineCaches.putAllByHealthDiaryVaccineId(vaccines);
      });
    } catch (e, st) {
      developer.log('syncHealthDiaryVaccines failed', name: 'sync', error: e, stackTrace: st);
    }
  }

  Future<void> _syncWeightLogs() async {
    try {
      final data = await _supabase.from('health_diary_weight_log').select();
      final logs = (data as List).map((e) => WeightLogCache.fromJson(e as Map<String, dynamic>)).toList();
      await _isar.writeTxn(() async {
        await _isar.weightLogCaches.clear();
        await _isar.weightLogCaches.putAllByHealthDiaryWeightLogId(logs);
      });
    } catch (e, st) {
      developer.log('syncWeightLogs failed', name: 'sync', error: e, stackTrace: st);
    }
  }

  Future<void> _syncVetVisits() async {
    try {
      final data = await _supabase.from('vet_visits').select();
      final visits = (data as List).map((e) => VetVisitCache.fromJson(e as Map<String, dynamic>)).toList();
      await _isar.writeTxn(() async {
        await _isar.vetVisitCaches.clear();
        await _isar.vetVisitCaches.putAllByVetVisitId(visits);
      });
    } catch (e, st) {
      developer.log('syncVetVisits failed', name: 'sync', error: e, stackTrace: st);
    }
  }

  Future<void> _syncReferential() async {
    try {
      final speciesData = await _supabase.from('pet_species').select();
      final species = (speciesData as List).map((e) => PetSpeciesCache.fromJson(e as Map<String, dynamic>)).toList();
      final typesData = await _supabase.from('event_type').select();
      final types = (typesData as List).map((e) => EventTypeCache.fromJson(e as Map<String, dynamic>)).toList();
      await _isar.writeTxn(() async {
        await _isar.petSpeciesCaches.clear();
        await _isar.petSpeciesCaches.putAll(species);
        await _isar.eventTypeCaches.clear();
        await _isar.eventTypeCaches.putAll(types);
      });
    } catch (e, st) {
      developer.log('syncReferential failed', name: 'sync', error: e, stackTrace: st);
    }
  }
}
