import 'package:isar/isar.dart';
import 'package:nanimo/features/event/data/models/event_image_model.dart';

part 'event_image_cache.g.dart';

@Collection()
class EventImageCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String eventImageId;

  late String assetPath;

  @Index()
  late String eventId;

  EventImageCache();

  /// Maps a Supabase [json] row to an [EventImageCache] instance
  factory EventImageCache.fromJson(Map<String, dynamic> json) {
    return EventImageCache()
      ..eventImageId = json['id_event_image'] as String
      ..assetPath = json['asset_path'] as String
      ..eventId = json['id_event'] as String;
  }

  /// Builds an [EventImageCache] from an [EventImageModel]
  factory EventImageCache.fromModel(EventImageModel model) {
    return EventImageCache()
      ..eventImageId = model.eventImageId
      ..assetPath = model.assetPath
      ..eventId = model.eventId;
  }

  /// Converts this cache row into the domain [EventImageModel]
  EventImageModel toModel() {
    return EventImageModel(
      eventImageId: eventImageId,
      assetPath: assetPath,
      eventId: eventId,
    );
  }
}
