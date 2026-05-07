import 'package:isar/isar.dart';

part 'event_cache.g.dart';

@Collection()
class EventCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String idEvent;

  late String title;
  String? description;
  late DateTime createdAt;

  @Index()
  late DateTime entryDate;

  String? idEventType;
  late String userId;

  EventCache();

  /// Maps a Supabase [json] row to an [EventCache] instance
  factory EventCache.fromJson(Map<String, dynamic> json) {
    return EventCache()
      ..idEvent = json['id_event'] as String
      ..title = json['title'] as String
      ..description = json['description'] as String?
      ..createdAt = DateTime.parse(json['created_at'] as String)
      ..entryDate = DateTime.parse(json['entry_date'] as String)
      ..idEventType = json['id_event_type'] as String?
      ..userId = json['user_id'] as String;
  }
}
