import 'dart:io';

import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:nanimo/core/isar/cache/schemas/event_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/event_image_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/pet_event_cache.dart';
import 'package:nanimo/features/event/data/models/event_image_model.dart';
import 'package:nanimo/features/event/data/models/event_model.dart';

class EventRepository {
  final SupabaseClient _supabase;
  final Isar _isar;

  EventRepository(this._supabase, this._isar);

  Stream<List<EventModel>> watchEvents({String? eventTypeId}) {
    final query = eventTypeId == null
        ? _isar.eventCaches.where().sortByEntryDateDesc()
        : _isar.eventCaches.filter().eventTypeIdEqualTo(eventTypeId).sortByEntryDateDesc();

    return query.watch(fireImmediately: true).map((rows) => rows.map((c) => c.toModel()).toList());
  }

  /// One-shot read of a single event.
  Future<EventModel?> getEventById(String eventId) async {
    final row = await _isar.eventCaches.getByEventId(eventId);
    return row?.toModel();
  }

  Future<void> createEvent(EventModel event, {required List<String> petIds}) async {
    try {
      await _insertIgnoringDuplicate('events', event.toJson());
      if (petIds.isNotEmpty) {
        await _insertIgnoringDuplicate('pets_events', [
          for (final petId in petIds) {'event_id': event.eventId, 'pet_id': petId},
        ]);
      }
    } catch (e, st) {
      throw mapRepositoryError(e, st,
          operation: 'createEvent', networkMessage: 'Une connexion internet est requise pour créer un événement.');
    }

    await _isar.writeTxn(() async {
      await _isar.eventCaches.putByEventId(EventCache.fromModel(event));
      await _isar.petEventCaches.putAllByPetEventId([
        for (final petId in petIds) PetEventCache.fromIds(petId: petId, eventId: event.eventId),
      ]);
    });
  }

  /// Updates an existing event.
  Future<void> updateEvent(EventModel event) async {
    try {
      await _supabase.from('events').update(event.toJson()).eq('id_event', event.eventId);
    } catch (e, st) {
      throw mapRepositoryError(e, st,
          operation: 'updateEvent', networkMessage: 'Une connexion internet est requise pour modifier un événement.');
    }

    await _isar.writeTxn(() async {
      await _isar.eventCaches.putByEventId(EventCache.fromModel(event));
    });
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await _supabase.from('events').delete().eq('id_event', eventId);
    } catch (e, st) {
      throw mapRepositoryError(e, st,
          operation: 'deleteEvent', networkMessage: 'Une connexion internet est requise pour supprimer un événement.');
    }

    await _isar.writeTxn(() async {
      await _isar.eventCaches.deleteByEventId(eventId);
      await _isar.eventImageCaches.filter().eventIdEqualTo(eventId).deleteAll();
      await _isar.petEventCaches.filter().eventIdEqualTo(eventId).deleteAll();
    });
  }

  Stream<Map<String, List<String>>> watchPetEvents() {
    return _isar.petEventCaches.where().watch(fireImmediately: true).map((rows) {
      final map = <String, List<String>>{};
      for (final row in rows) {
        map.putIfAbsent(row.eventId, () => []).add(row.petId);
      }
      return map;
    });
  }

  Future<String> signedImageUrl(String assetPath) {
    return _supabase.storage.from('journal-media').createSignedUrl(
          assetPath,
          3600,
        );
  }

  Stream<Map<String, List<String>>> watchAllImages() {
    return _isar.eventImageCaches.where().watch(fireImmediately: true).map((rows) {
      final map = <String, List<String>>{};
      for (final row in rows) {
        map.putIfAbsent(row.eventId, () => []).add(row.assetPath);
      }
      return map;
    });
  }

  Stream<List<EventImageModel>> watchImagesForEvent(String eventId) {
    return _isar.eventImageCaches
        .filter()
        .eventIdEqualTo(eventId)
        .watch(fireImmediately: true)
        .map((rows) => rows.map((c) => c.toModel()).toList());
  }

  Future<void> addImage(EventImageModel image) async {
    try {
      await _insertIgnoringDuplicate('event_image', image.toJson());
    } catch (e, st) {
      throw mapRepositoryError(e, st, operation: 'addImage', networkMessage: 'Une connexion internet est requise pour ajouter une photo.');
    }

    await _isar.writeTxn(() async {
      await _isar.eventImageCaches.putByEventImageId(EventImageCache.fromModel(image));
    });
  }

  /// Uploads an image to the `journal-media` bucket and returns its storage path
  Future<String> uploadEventImage(String eventId, File file) async {
    final userId = _requireUserId();
    final dotIndex = file.path.lastIndexOf('.');
    final extension = dotIndex == -1 ? 'jpg' : file.path.substring(dotIndex + 1).toLowerCase();
    final storagePath = '$userId/$eventId/${const Uuid().v4()}.$extension';

    try {
      await _supabase.storage.from('journal-media').upload(storagePath, file);
    } catch (e, st) {
      throw mapRepositoryError(e, st,
          operation: 'uploadEventImage', networkMessage: 'Une connexion internet est requise pour envoyer une photo.');
    }

    return storagePath;
  }

  Future<void> deleteImage(String eventImageId) async {
    try {
      await _supabase.from('event_image').delete().eq('id_event_image', eventImageId);
    } catch (e, st) {
      throw mapRepositoryError(e, st,
          operation: 'deleteImage', networkMessage: 'Une connexion internet est requise pour supprimer une photo.');
    }

    await _isar.writeTxn(() async {
      await _isar.eventImageCaches.deleteByEventImageId(eventImageId);
    });
  }

  String _requireUserId() {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw const RepositoryNetworkException(
        'Vous devez être connecté pour effectuer cette action.',
      );
    }
    return userId;
  }

  /// Ignore duplicate keys so a retry after a partial failure is idempotent
  Future<void> _insertIgnoringDuplicate(String table, Object values) async {
    try {
      await _supabase.from(table).insert(values);
    } on PostgrestException catch (err) {
      if (err.code == '23505') return;
      rethrow;
    }
  }
}
