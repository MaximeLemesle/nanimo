import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nanimo/core/errors/repository_network_exception.dart';
import 'package:nanimo/core/isar/cache/schemas/event_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/event_image_cache.dart';
import 'package:nanimo/features/event/data/models/event_image_model.dart';
import 'package:nanimo/features/event/data/models/event_model.dart';

/// Reads come from Isar so the journal works offline. Writes go to Supabase first;
/// on success the cache is updated, on failure a [RepositoryNetworkException] surfaces a message.
class EventRepository {
  final SupabaseClient _supabase;
  final Isar _isar;

  EventRepository(this._supabase, this._isar);

  /// Live timeline of events, newest first.
  Stream<List<EventModel>> watchEvents({String? eventTypeId}) {
    final query = eventTypeId == null
        ? _isar.eventCaches.filter().titleIsNotEmpty()
        : _isar.eventCaches.filter().eventTypeIdEqualTo(eventTypeId);

    return query
        .sortByEntryDateDesc()
        .watch(fireImmediately: true)
        .map((rows) => rows.map((c) => c.toModel()).toList());
  }

  /// Returns events whose [EventModel.entryDate] falls within [day] (00:00 → 24:00).
  Future<List<EventModel>> getEventsForDay(DateTime day) async {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    final rows = await _isar.eventCaches
        .filter()
        .entryDateBetween(start, end, includeUpper: false)
        .sortByEntryDateDesc()
        .findAll();
    return rows.map((c) => c.toModel()).toList();
  }

  /// One-shot read of a single event.
  Future<EventModel?> getEventById(String eventId) async {
    final row = await _isar.eventCaches.getByEventId(eventId);
    return row?.toModel();
  }

  /// Inserts a new event for the current authenticated user.
  Future<void> createEvent(EventModel event) async {
    final userId = _requireUserId();
    final payload = {...event.toJson(), 'user_id': userId};

    try {
      await _supabase.from('events').insert(payload);
    } catch (_) {
      throw const RepositoryNetworkException(
        'Une connexion internet est requise pour créer un événement.',
      );
    }

    await _isar.writeTxn(() async {
      await _isar.eventCaches
          .putByEventId(EventCache.fromModel(event, userId: userId));
    });
  }

  /// Updates an existing event.
  Future<void> updateEvent(EventModel event) async {
    final userId = _requireUserId();

    try {
      await _supabase
          .from('events')
          .update(event.toJson())
          .eq('id_event', event.eventId);
    } catch (_) {
      throw const RepositoryNetworkException(
        'Une connexion internet est requise pour modifier un événement.',
      );
    }

    await _isar.writeTxn(() async {
      await _isar.eventCaches
          .putByEventId(EventCache.fromModel(event, userId: userId));
    });
  }

  /// Deletes an event. Related `event_image` rows are removed by Supabase
  /// CASCADE; the next sync wave clears them locally.
  Future<void> deleteEvent(String eventId) async {
    try {
      await _supabase.from('events').delete().eq('id_event', eventId);
    } catch (_) {
      throw const RepositoryNetworkException(
        'Une connexion internet est requise pour supprimer un événement.',
      );
    }

    await _isar.writeTxn(() async {
      await _isar.eventCaches.deleteByEventId(eventId);
      await _isar.eventImageCaches
          .filter()
          .eventIdEqualTo(eventId)
          .deleteAll();
    });
  }

  /// Live list of images attached to [eventId].
  Stream<List<EventImageModel>> watchImagesForEvent(String eventId) {
    return _isar.eventImageCaches
        .filter()
        .eventIdEqualTo(eventId)
        .watch(fireImmediately: true)
        .map((rows) => rows.map((c) => c.toModel()).toList());
  }

  /// Inserts a new event_image row. The asset must already be uploaded to
  /// Supabase Storage by the caller — this only persists the metadata.
  Future<void> addImage(EventImageModel image) async {
    try {
      await _supabase.from('event_image').insert(image.toJson());
    } catch (_) {
      throw const RepositoryNetworkException(
        'Une connexion internet est requise pour ajouter une photo.',
      );
    }

    await _isar.writeTxn(() async {
      await _isar.eventImageCaches
          .putByEventImageId(EventImageCache.fromModel(image));
    });
  }

  /// Removes an event_image row. Storage cleanup is the caller's job.
  Future<void> deleteImage(String eventImageId) async {
    try {
      await _supabase
          .from('event_image')
          .delete()
          .eq('id_event_image', eventImageId);
    } catch (_) {
      throw const RepositoryNetworkException(
        'Une connexion internet est requise pour supprimer une photo.',
      );
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
}
