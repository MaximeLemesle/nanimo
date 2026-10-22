import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/analytics/analytics.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';
import 'package:nanimo/core/analytics/analytics_service.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/event/data/event_repository.dart';
import 'package:nanimo/features/event/data/models/event_model.dart';
import 'package:nanimo/features/event/data/models/event_type_model.dart';
import 'package:nanimo/features/event/presentation/cubit/event_creation_cubit.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';

import '../../../../core/analytics/recording_analytics_service.dart';

class _MockEventRepository extends Mock implements EventRepository {}

class _MockReferentialRepository extends Mock implements ReferentialRepository {}

class _MockPetRepository extends Mock implements PetRepository {}

const _walk = EventTypeModel(
  eventTypeId: 't-balade',
  name: 'Balade',
  code: 'balade',
  isPremium: false,
);

final _milo = PetModel(
  petId: 'pet-milo',
  petName: 'Milo',
  birthdate: DateTime(2022, 5, 1),
  gender: Gender.male,
  createdAt: DateTime(2022, 5, 1),
  petRaceId: 'r',
  petSpeciesId: 's',
);

void main() {
  late _MockEventRepository eventRepo;
  late _MockReferentialRepository referentialRepo;
  late _MockPetRepository petRepo;
  late RecordingAnalyticsService recorder;

  setUpAll(() {
    registerFallbackValue(
      const EventModel(eventId: 'e', title: 't', eventTypeId: 't-balade'),
    );
  });

  setUp(() {
    eventRepo = _MockEventRepository();
    referentialRepo = _MockReferentialRepository();
    petRepo = _MockPetRepository();
    recorder = RecordingAnalyticsService();
    analytics = recorder;
    when(() => petRepo.getPets()).thenAnswer((_) async => [_milo]);
    when(() => referentialRepo.fetchSpecies()).thenAnswer((_) async => []);
    when(() => referentialRepo.fetchEventTypes()).thenAnswer((_) async => [_walk]);
    when(() => eventRepo.createEvent(any(), petIds: any(named: 'petIds')))
        .thenAnswer((_) async {});
  });

  tearDown(() => analytics = const NoopAnalyticsService());

  Future<EventCreationCubit> loadedCubit() async {
    final cubit = EventCreationCubit(
      eventRepository: eventRepo,
      referentialRepository: referentialRepo,
      petRepository: petRepo,
    );
    await cubit.load();
    return cubit;
  }

  test('memory_created carries the type code and never the typed text', () async {
    when(() => eventRepo.countEvents()).thenAnswer((_) async => 3);
    final cubit = await loadedCubit();

    await cubit.submit(
      title: 'Balade au parc',
      description: 'Il a couru partout',
      entryDate: DateTime(2026, 10, 1),
      images: const [],
    );

    final event = recorder.lastOf(AnalyticsEvents.memoryCreated)!;
    expect(event.properties, {
      AnalyticsProperties.photoCount: 0,
      AnalyticsProperties.petCount: 1,
      AnalyticsProperties.hasDescription: true,
      AnalyticsProperties.eventType: 'balade',
    });
    expect(recorder.names, isNot(contains(AnalyticsEvents.firstMemoryCreated)));
    await cubit.close();
  });

  test('the first memory of an account is flagged as the activation', () async {
    when(() => eventRepo.countEvents()).thenAnswer((_) async => 0);
    final cubit = await loadedCubit();

    await cubit.submit(
      title: 'Premier jour',
      entryDate: DateTime(2026, 10, 1),
      images: const [],
    );

    expect(recorder.names, [
      AnalyticsEvents.memoryCreated,
      AnalyticsEvents.firstMemoryCreated,
    ]);
    expect(
      recorder.lastOf(AnalyticsEvents.firstMemoryCreated)!
          .properties[AnalyticsProperties.hasDescription],
      isFalse,
    );
    await cubit.close();
  });

  test('an unreadable cache never claims a first memory', () async {
    when(() => eventRepo.countEvents()).thenThrow(Exception('isar closed'));
    final cubit = await loadedCubit();

    await cubit.submit(
      title: 'Souvenir',
      entryDate: DateTime(2026, 10, 1),
      images: const [],
    );

    expect(recorder.names, [AnalyticsEvents.memoryCreated]);
    await cubit.close();
  });
}
