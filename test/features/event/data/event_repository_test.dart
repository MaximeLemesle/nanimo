import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/isar/cache/schemas/event_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/event_image_cache.dart';
import 'package:nanimo/features/event/data/event_repository.dart';
import 'package:nanimo/features/event/data/models/event_image_model.dart';
import 'package:nanimo/features/event/data/models/event_model.dart';

import '../../../helpers/isar_test_helper.dart';
import '../../../helpers/supabase_mocks.dart';

EventModel buildEvent(
  String id, {
  String title = 'Souvenir',
  DateTime? entryDate,
  String eventTypeId = 'evt-type-1',
}) {
  return EventModel(
    eventId: id,
    title: title,
    description: 'desc',
    createdAt: DateTime.utc(2024, 1, 1),
    entryDate: entryDate ?? DateTime.utc(2024, 6, 1),
    eventTypeId: eventTypeId,
  );
}

EventImageModel buildImage(String id, {String eventId = 'e1'}) {
  return EventImageModel(
    eventImageId: id,
    assetPath: 'assets/$id.png',
    eventId: eventId,
  );
}

void main() {
  final harness = IsarTestHarness();
  late EventRepository repo;

  setUp(() async {
    await harness.setUp();
    repo = EventRepository(MockSupabaseClient(), harness.isar);
  });

  tearDown(() async {
    await harness.tearDown();
  });

  Future<void> seedEvent(EventModel model) async {
    await harness.isar.writeTxn(() async {
      await harness.isar.eventCaches
          .putByEventId(EventCache.fromModel(model));
    });
  }

  Future<void> seedImage(EventImageModel model) async {
    await harness.isar.writeTxn(() async {
      await harness.isar.eventImageCaches
          .putByEventImageId(EventImageCache.fromModel(model));
    });
  }

  group('watchEvents', () {
    test('emits empty when the cache is empty', () async {
      final emission = await repo.watchEvents().first;
      expect(emission, isEmpty);
    });

    test('emits events with a non-empty title, newest entryDate first',
        () async {
      await seedEvent(
        buildEvent('e1', entryDate: DateTime.utc(2024, 1, 1)),
      );
      await seedEvent(
        buildEvent('e2', entryDate: DateTime.utc(2024, 6, 1)),
      );

      final emission = await repo.watchEvents().first;
      expect(emission.map((e) => e.eventId).toList(), ['e2', 'e1']);
    });

    test('filters by eventTypeId when provided', () async {
      await seedEvent(buildEvent('e1', eventTypeId: 'type-a'));
      await seedEvent(buildEvent('e2', eventTypeId: 'type-b'));

      final emission = await repo.watchEvents(eventTypeId: 'type-b').first;
      expect(emission, hasLength(1));
      expect(emission.first.eventId, 'e2');
    });

  });

  group('getEventById', () {
    test('returns null when missing', () async {
      expect(await repo.getEventById('missing'), isNull);
    });

    test('returns the cached event when present', () async {
      await seedEvent(buildEvent('e1', title: 'Anniversaire'));

      final result = await repo.getEventById('e1');
      expect(result, isNotNull);
      expect(result!.title, 'Anniversaire');
    });
  });

  group('watchImagesForEvent', () {
    test('emits empty when no image is attached', () async {
      final emission = await repo.watchImagesForEvent('e1').first;
      expect(emission, isEmpty);
    });

    test('emits images attached to the event only', () async {
      await seedImage(buildImage('img-1', eventId: 'e1'));
      await seedImage(buildImage('img-2', eventId: 'e2'));

      final emission = await repo.watchImagesForEvent('e1').first;
      expect(emission, hasLength(1));
      expect(emission.first.eventImageId, 'img-1');
    });
  });
}
