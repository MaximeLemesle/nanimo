import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/errors/repository_network_exception.dart';
import 'package:nanimo/data/models/referential/pet_species_model.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/event/data/event_repository.dart';
import 'package:nanimo/features/event/data/models/event_model.dart';
import 'package:nanimo/features/event/data/models/event_type_model.dart';
import 'package:nanimo/features/journal/presentation/cubit/journal_cubit.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';

class _MockEventRepository extends Mock implements EventRepository {}

class _MockPetRepository extends Mock implements PetRepository {}

class _MockReferentialRepository extends Mock
    implements ReferentialRepository {}

final _pet1 = PetModel(
  petId: 'p1',
  petName: 'Yumeko',
  birthdate: DateTime(2024, 1, 1),
  gender: Gender.female,
  createdAt: DateTime(2024, 1, 1),
  petRaceId: 'r1',
  petSpeciesId: 's1',
);

final _pet2 = PetModel(
  petId: 'p2',
  petName: 'Rex',
  birthdate: DateTime(2022, 6, 1),
  gender: Gender.male,
  createdAt: DateTime(2022, 6, 1),
  petRaceId: 'r2',
  petSpeciesId: 's2',
);

const _walkType = EventTypeModel(
  eventTypeId: 't1',
  name: 'Balade',
  code: 'balade',
  isPremium: false,
);

const _hugType = EventTypeModel(
  eventTypeId: 't2',
  name: 'Câlin',
  code: 'calin',
  isPremium: false,
);

const _species = [
  PetSpeciesModel(
    petSpeciesId: 's1',
    speciesName: 'Chat',
    weightUnit: WeightUnit.kg,
    iconKey: 'cat',
  ),
  PetSpeciesModel(
    petSpeciesId: 's2',
    speciesName: 'Chien',
    weightUnit: WeightUnit.kg,
    iconKey: 'dog',
  ),
];

final _eventWalk = EventModel(
  eventId: 'e1',
  title: 'Promenade au parc',
  entryDate: DateTime(2026, 3, 5, 11, 43),
  eventTypeId: 't1',
);

final _eventHug = EventModel(
  eventId: 'e2',
  title: 'Gros câlin',
  entryDate: DateTime(2026, 3, 4, 9, 0),
  eventTypeId: 't2',
);

void main() {
  late _MockEventRepository eventRepo;
  late _MockPetRepository petRepo;
  late _MockReferentialRepository refRepo;

  setUp(() {
    eventRepo = _MockEventRepository();
    petRepo = _MockPetRepository();
    refRepo = _MockReferentialRepository();

    when(() => eventRepo.watchEvents())
        .thenAnswer((_) => Stream.value([_eventWalk, _eventHug]));
    when(() => eventRepo.watchPetEvents()).thenAnswer(
      (_) => Stream.value({
        'e1': ['p1'],
        'e2': ['p2'],
      }),
    );
    when(() => eventRepo.watchAllImages()).thenAnswer(
      (_) => Stream.value({
        'e1': ['path/a.jpg'],
      }),
    );
    when(() => petRepo.getPets()).thenAnswer((_) async => [_pet1, _pet2]);
    when(() => refRepo.fetchEventTypes())
        .thenAnswer((_) async => [_walkType, _hugType]);
    when(() => refRepo.fetchSpecies()).thenAnswer((_) async => _species);
  });

  JournalCubit createCubit() => JournalCubit(
        eventRepository: eventRepo,
        petRepository: petRepo,
        referentialRepository: refRepo,
      );

  Future<void> settle() =>
      Future<void>.delayed(const Duration(milliseconds: 20));

  test('loads events, links, images, pets and icons', () async {
    final cubit = createCubit();
    await settle();

    expect(cubit.state.status, JournalStatus.loaded);
    expect(cubit.state.events, [_eventWalk, _eventHug]);
    expect(cubit.state.pets, [_pet1, _pet2]);
    expect(cubit.state.types, [_walkType, _hugType]);
    expect(cubit.state.petIdsByEvent['e1'], ['p1']);
    expect(cubit.state.imagePathsByEvent['e1'], ['path/a.jpg']);
    expect(cubit.state.iconsKey['s1'], 'cat');
    expect(cubit.state.filteredEvents, [_eventWalk, _eventHug]);

    await cubit.close();
  });

  test('pet filter keeps only events linked to that pet', () async {
    final cubit = createCubit();
    await settle();

    cubit.togglePetFilter('p1');
    expect(cubit.state.selectedPetIds, {'p1'});
    expect(cubit.state.filteredEvents, [_eventWalk]);

    await cubit.close();
  });

  test('type filter keeps only events of that type', () async {
    final cubit = createCubit();
    await settle();

    cubit.toggleTypeFilter('t2');
    expect(cubit.state.filteredEvents, [_eventHug]);

    await cubit.close();
  });

  test('multiple selected pets keep events linked to any of them', () async {
    final cubit = createCubit();
    await settle();

    cubit.togglePetFilter('p1');
    cubit.togglePetFilter('p2');
    expect(cubit.state.selectedPetIds, {'p1', 'p2'});
    expect(cubit.state.filteredEvents, [_eventWalk, _eventHug]);

    await cubit.close();
  });

  test('multiple selected types keep events of any of them', () async {
    final cubit = createCubit();
    await settle();

    cubit.toggleTypeFilter('t1');
    cubit.toggleTypeFilter('t2');
    expect(cubit.state.filteredEvents, [_eventWalk, _eventHug]);

    await cubit.close();
  });

  test('pet and type filters combine', () async {
    final cubit = createCubit();
    await settle();

    cubit.togglePetFilter('p1');
    cubit.toggleTypeFilter('t2');
    // p1 is only on the walk (t1), so the combination is empty.
    expect(cubit.state.filteredEvents, isEmpty);

    await cubit.close();
  });

  test('toggling the active pet again clears it', () async {
    final cubit = createCubit();
    await settle();

    cubit.togglePetFilter('p1');
    cubit.togglePetFilter('p1');
    expect(cubit.state.selectedPetIds, isEmpty);
    expect(cubit.state.filteredEvents, [_eventWalk, _eventHug]);

    await cubit.close();
  });

  test('clearFilters resets pet and type selections', () async {
    final cubit = createCubit();
    await settle();

    cubit.togglePetFilter('p1');
    cubit.toggleTypeFilter('t1');
    expect(cubit.state.hasActiveFilters, isTrue);
    expect(cubit.state.activeFilterCount, 2);

    cubit.clearFilters();
    expect(cubit.state.hasActiveFilters, isFalse);
    expect(cubit.state.filteredEvents, [_eventWalk, _eventHug]);

    await cubit.close();
  });

  test('emits an error when referential loading throws', () async {
    when(() => refRepo.fetchEventTypes()).thenThrow(Exception('boom'));
    final cubit = createCubit();
    await settle();

    expect(cubit.state.status, JournalStatus.error);
    expect(cubit.state.error, isNotNull);

    await cubit.close();
  });

  test('deleteEvent returns null when the repository succeeds', () async {
    when(() => eventRepo.deleteEvent('e1')).thenAnswer((_) async {});
    final cubit = createCubit();
    await settle();

    final error = await cubit.deleteEvent('e1');
    expect(error, isNull);
    verify(() => eventRepo.deleteEvent('e1')).called(1);

    await cubit.close();
  });

  test('deleteEvent surfaces the network exception message', () async {
    when(() => eventRepo.deleteEvent('e1'))
        .thenThrow(const RepositoryNetworkException('Pas de réseau'));
    final cubit = createCubit();
    await settle();

    final error = await cubit.deleteEvent('e1');
    expect(error, 'Pas de réseau');

    await cubit.close();
  });

  test('deleteEvent returns a generic message on unknown failure', () async {
    when(() => eventRepo.deleteEvent('e1')).thenThrow(Exception('boom'));
    final cubit = createCubit();
    await settle();

    final error = await cubit.deleteEvent('e1');
    expect(error, 'Impossible de supprimer le souvenir.');

    await cubit.close();
  });

  test('imageUrl delegates to the repository signed url', () async {
    when(() => eventRepo.signedImageUrl('path/a.jpg'))
        .thenAnswer((_) async => 'https://signed/a.jpg');
    final cubit = createCubit();
    await settle();

    final url = await cubit.imageUrl('path/a.jpg');
    expect(url, 'https://signed/a.jpg');

    await cubit.close();
  });

  test('imageUrl memoizes the signed url per asset path', () async {
    when(() => eventRepo.signedImageUrl('path/a.jpg'))
        .thenAnswer((_) async => 'https://signed/a.jpg');
    when(() => eventRepo.signedImageUrl('path/b.jpg'))
        .thenAnswer((_) async => 'https://signed/b.jpg');
    final cubit = createCubit();
    await settle();

    expect(await cubit.imageUrl('path/a.jpg'), 'https://signed/a.jpg');
    expect(await cubit.imageUrl('path/a.jpg'), 'https://signed/a.jpg');
    expect(await cubit.imageUrl('path/b.jpg'), 'https://signed/b.jpg');

    verify(() => eventRepo.signedImageUrl('path/a.jpg')).called(1);
    verify(() => eventRepo.signedImageUrl('path/b.jpg')).called(1);

    await cubit.close();
  });
}
