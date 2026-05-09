import 'package:isar/isar.dart';
import 'package:nanimo/features/event/data/models/event_model.dart';

part 'event_cache.g.dart';

@Collection()
class EventCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String eventId;

  late String title;
  String? description;
  DateTime? createdAt;

  @Index()
  DateTime? entryDate;

  late String eventTypeId;

  /// Owner of the event — used for local filtering when sync runs while
  /// multiple sessions share the same Isar file.
  late String userId;

  EventCache();

  /// Maps a Supabase [json] row to an [EventCache] instance
  factory EventCache.fromJson(Map<String, dynamic> json) {
    return EventCache()
      ..eventId = json['id_event'] as String
      ..title = json['title'] as String
      ..description = json['description'] as String?
      ..createdAt = json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null
      ..entryDate = json['entry_date'] != null
          ? DateTime.parse(json['entry_date'] as String)
          : null
      ..eventTypeId = (json['id_event_type'] ?? '') as String
      ..userId = json['user_id'] as String;
  }

  /// Builds an [EventCache] from an [EventModel]
  factory EventCache.fromModel(EventModel model, {required String userId}) {
    return EventCache()
      ..eventId = model.eventId
      ..title = model.title
      ..description = model.description
      ..createdAt = model.createdAt
      ..entryDate = model.entryDate
      ..eventTypeId = model.eventTypeId
      ..userId = userId;
  }

  /// Converts this cache row into the domain [EventModel]
  EventModel toModel() {
    return EventModel(
      eventId: eventId,
      title: title,
      description: description,
      createdAt: createdAt,
      entryDate: entryDate,
      eventTypeId: eventTypeId,
    );
  }
}
