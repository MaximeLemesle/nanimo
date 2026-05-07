import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nanimo/core/isar/cache/schemas/event_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/event_image_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_vaccine_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/pet_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/user_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/weight_log_cache.dart';
import 'package:nanimo/core/isar/database/isar_service.dart';

class SyncService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final Isar _isar = IsarService.instance;

  /// Wave 1 — awaited before Home renders. Syncs user and pets.
  Future<void> syncCritical() async {
    await Future.wait([_syncUser(), _syncPets()]);
  }

  /// Wave 2 — fire and forget after Home renders.
  void syncSecondary() {
    Future(() async {
      await _syncEvents();
      await _syncEventImages();
      await _syncHealthDiaries();
      await _syncHealthDiaryVaccines();
      await _syncWeightLogs();
    });
  }

  Future<void> _syncUser() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final data = await _supabase
          .from('users')
          .select()
          .eq('id_user', userId)
          .single();

      final user = UserCache.fromJson(data);
      await _isar.writeTxn(() async {
        await _isar.userCaches.putByIdUser(user);
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
        await _isar.petCaches.putAllByIdPet(pets);
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
        await _isar.eventCaches.putAllByIdEvent(events);
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
        await _isar.eventImageCaches.putAllByIdEventImage(images);
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
        await _isar.healthDiaryCaches.putAllByIdHealthDiary(diaries);
      });
    } catch (_) {}
  }

  Future<void> _syncHealthDiaryVaccines() async {
    try {
      final data = await _supabase.from('health_diary_vaccines').select();
      final vaccines = (data as List)
          .map((e) => HealthDiaryVaccineCache.fromJson(e as Map<String, dynamic>))
          .toList();
      await _isar.writeTxn(() async {
        await _isar.healthDiaryVaccineCaches.putAllByIdHealthDiaryVaccine(vaccines);
      });
    } catch (_) {}
  }

  Future<void> _syncWeightLogs() async {
    try {
      final data = await _supabase.from('weight_logs').select();
      final logs = (data as List)
          .map((e) => WeightLogCache.fromJson(e as Map<String, dynamic>))
          .toList();
      await _isar.writeTxn(() async {
        await _isar.weightLogCaches.putAllByIdWeightLog(logs);
      });
    } catch (_) {}
  }
}
