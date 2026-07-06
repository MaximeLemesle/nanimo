import 'package:isar/isar.dart';
import 'package:nanimo/features/event/data/models/event_type_model.dart';

part 'event_type_cache.g.dart';

@Collection()
class EventTypeCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String eventTypeId;

  late String name;
  String? code;
  late bool isPremium;

  EventTypeCache();

  /// Maps a Supabase [json] row to an [EventTypeCache] instance
  factory EventTypeCache.fromJson(Map<String, dynamic> json) {
    return EventTypeCache()
      ..eventTypeId = json['id_event_type'] as String
      ..name = json['name'] as String
      ..code = json['code'] as String?
      ..isPremium = json['is_premium'] as bool;
  }

  /// Builds an [EventTypeCache] from an [EventTypeModel]
  factory EventTypeCache.fromModel(EventTypeModel model) {
    return EventTypeCache()
      ..eventTypeId = model.eventTypeId
      ..name = model.name
      ..code = model.code
      ..isPremium = model.isPremium;
  }

  /// Converts this cache row into the domain [EventTypeModel]
  EventTypeModel toModel() {
    return EventTypeModel(
      eventTypeId: eventTypeId,
      name: name,
      code: code,
      isPremium: isPremium,
    );
  }
}
