import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/isar/cache/schemas/event_image_cache.dart';

void main() {
  group('EventImageCache.fromJson', () {
    test('maps all fields correctly', () {
      final json = {
        'id_event_image': 'img-uuid',
        'asset_path': 'journal-media/image.jpg',
        'event_id': 'event-uuid',
      };

      final cache = EventImageCache.fromJson(json);

      expect(cache.eventImageId, 'img-uuid');
      expect(cache.assetPath, 'journal-media/image.jpg');
      expect(cache.eventId, 'event-uuid');
    });
  });
}
