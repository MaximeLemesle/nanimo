import 'package:isar/isar.dart';

part 'event_image_cache.g.dart';

@Collection()
class EventImageCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String idEventImage;

  late String assetPath;

  @Index()
  late String idEvent;

  EventImageCache();

  /// Maps a Supabase [json] row to an [EventImageCache] instance
  factory EventImageCache.fromJson(Map<String, dynamic> json) {
    return EventImageCache()
      ..idEventImage = json['id_event_image'] as String
      ..assetPath = json['asset_path'] as String
      ..idEvent = json['id_event'] as String;
  }
}
