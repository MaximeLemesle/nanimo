import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/errors/repository_network_exception.dart';
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
  late MockSupabaseClient supabase;

  setUpAll(registerSupabaseFallbacks);

  setUp(() async {
    await harness.setUp();
    supabase = MockSupabaseClient();
    repo = EventRepository(supabase, harness.isar);
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

  group('watchAllImages', () {
    test('groups asset paths by event id', () async {
      await seedImage(buildImage('img-1', eventId: 'e1'));
      await seedImage(buildImage('img-2', eventId: 'e1'));
      await seedImage(buildImage('img-3', eventId: 'e2'));

      final emission = await repo.watchAllImages().first;
      expect(emission['e1'], hasLength(2));
      expect(emission['e2'], ['assets/img-3.png']);
    });
  });

  group('watchPetEvents', () {
    test('emits empty when no link exists', () async {
      final emission = await repo.watchPetEvents().first;
      expect(emission, isEmpty);
    });

    test('groups pet ids by event id after createEvent', () async {
      stubInsert(supabase, 'events', resolver: () {});
      stubInsert(supabase, 'pets_events', resolver: () {});

      await repo.createEvent(buildEvent('e1'), petIds: ['p1', 'p2']);

      final emission = await repo.watchPetEvents().first;
      expect(emission['e1'], containsAll(['p1', 'p2']));
    });
  });

  group('createEvent', () {
    test('inserts the event and its pet links, then caches it', () async {
      stubInsert(supabase, 'events', resolver: () {});
      stubInsert(supabase, 'pets_events', resolver: () {});

      await repo.createEvent(buildEvent('e1'), petIds: ['p1', 'p2']);

      final cached = await repo.getEventById('e1');
      expect(cached, isNotNull);
      expect(cached!.eventId, 'e1');

      final links = await repo.watchPetEvents().first;
      expect(links['e1'], containsAll(['p1', 'p2']));
    });

    test('skips the pet link insert when no pet is given', () async {
      stubInsert(supabase, 'events', resolver: () {});

      await repo.createEvent(buildEvent('e1'), petIds: const []);

      expect(await repo.getEventById('e1'), isNotNull);
    });

    test('throws a network exception and does not cache on failure', () async {
      stubInsert(supabase, 'events', resolver: () => throw Exception('offline'));

      await expectLater(
        repo.createEvent(buildEvent('e1'), petIds: const []),
        throwsA(isA<RepositoryNetworkException>()),
      );
      expect(await repo.getEventById('e1'), isNull);
    });
  });

  group('updateEvent', () {
    test('updates Supabase then refreshes the cache', () async {
      await seedEvent(buildEvent('e1', title: 'Ancien'));
      stubUpdate(supabase, 'events', resolver: () {});

      await repo.updateEvent(buildEvent('e1', title: 'Nouveau'));

      expect((await repo.getEventById('e1'))!.title, 'Nouveau');
    });

    test('throws a network exception on failure', () async {
      stubUpdate(supabase, 'events', resolver: () => throw Exception('x'));

      await expectLater(
        repo.updateEvent(buildEvent('e1')),
        throwsA(isA<RepositoryNetworkException>()),
      );
    });
  });

  group('deleteEvent', () {
    test('removes the event and its images from the cache', () async {
      await seedEvent(buildEvent('e1'));
      await seedImage(buildImage('img-1', eventId: 'e1'));
      stubDelete(supabase, 'events', resolver: () {});

      await repo.deleteEvent('e1');

      expect(await repo.getEventById('e1'), isNull);
      expect(await repo.watchImagesForEvent('e1').first, isEmpty);
    });

    test('throws a network exception on failure', () async {
      stubDelete(supabase, 'events', resolver: () => throw Exception('x'));

      await expectLater(
        repo.deleteEvent('e1'),
        throwsA(isA<RepositoryNetworkException>()),
      );
    });
  });

  group('addImage', () {
    test('inserts the image then caches it', () async {
      stubInsert(supabase, 'event_image', resolver: () {});

      await repo.addImage(buildImage('img-1', eventId: 'e1'));

      final emission = await repo.watchImagesForEvent('e1').first;
      expect(emission.single.eventImageId, 'img-1');
    });

    test('throws a network exception on failure', () async {
      stubInsert(supabase, 'event_image', resolver: () => throw Exception('x'));

      await expectLater(
        repo.addImage(buildImage('img-1')),
        throwsA(isA<RepositoryNetworkException>()),
      );
    });
  });

  group('deleteImage', () {
    test('removes the image from the cache', () async {
      await seedImage(buildImage('img-1', eventId: 'e1'));
      stubDelete(supabase, 'event_image', resolver: () {});

      await repo.deleteImage('img-1');

      expect(await repo.watchImagesForEvent('e1').first, isEmpty);
    });

    test('throws a network exception on failure', () async {
      stubDelete(supabase, 'event_image', resolver: () => throw Exception('x'));

      await expectLater(
        repo.deleteImage('img-1'),
        throwsA(isA<RepositoryNetworkException>()),
      );
    });
  });

  group('uploadEventImage', () {
    test('throws when there is no authenticated user', () async {
      final auth = MockGoTrueClient();
      when(() => supabase.auth).thenReturn(auth);
      when(() => auth.currentUser).thenReturn(null);

      await expectLater(
        repo.uploadEventImage('e1', File('photo.jpg')),
        throwsA(isA<RepositoryNetworkException>()),
      );
    });
  });
}
