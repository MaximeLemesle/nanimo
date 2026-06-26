import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/errors/repository_network_exception.dart';
import 'package:nanimo/data/models/referential/pet_species_model.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/event/data/event_repository.dart';
import 'package:nanimo/features/event/data/models/event_image_model.dart';
import 'package:nanimo/features/event/data/models/event_model.dart';
import 'package:nanimo/features/event/data/models/event_type_model.dart';
import 'package:nanimo/features/event/presentation/cubit/event_creation_cubit.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';

class _MockEventRepository extends Mock implements EventRepository {}

class _MockReferentialRepository extends Mock
    implements ReferentialRepository {}

class _MockPetRepository extends Mock implements PetRepository {}

const _souvenir = EventTypeModel(
  eventTypeId: 't-souvenir',
  name: 'Souvenir',
  isPremium: false,
);
const _anniversaire = EventTypeModel(
  eventTypeId: 't-anniversaire',
  name: 'Anniversaire',
  isPremium: false,
);
const _catSpecies = PetSpeciesModel(
  petSpeciesId: 's',
  speciesName: 'Chat',
  weightUnit: WeightUnit.kg,
  iconKey: 'cat',
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

  EventCreationCubit buildCubit() => EventCreationCubit(
        eventRepository: eventRepo,
        referentialRepository: referentialRepo,
        petRepository: petRepo,
      );

  setUpAll(() {
    registerFallbackValue(
      const EventModel(eventId: 'e', title: 't', eventTypeId: 't-souvenir'),
    );
    registerFallbackValue(
      const EventImageModel(eventImageId: 'i', assetPath: 'p', eventId: 'e'),
    );
  });

  setUp(() {
    eventRepo = _MockEventRepository();
    referentialRepo = _MockReferentialRepository();
    petRepo = _MockPetRepository();
    // Default: one pet available.
    when(() => petRepo.getPets()).thenAnswer((_) async => [_milo]);
    when(() => referentialRepo.fetchSpecies())
        .thenAnswer((_) async => [_catSpecies]);
  });

  group('load', () {
    test('loads types and pets, pre-selecting the first of each', () async {
      when(() => referentialRepo.fetchEventTypes())
          .thenAnswer((_) async => [_souvenir, _anniversaire]);

      final cubit = buildCubit();
      await cubit.load();

      expect(cubit.state.types, [_souvenir, _anniversaire]);
      expect(cubit.state.selectedTypeId, _souvenir.eventTypeId);
      expect(cubit.state.pets, [_milo]);
      expect(cubit.state.selectedPetIds, [_milo.petId]);
      expect(cubit.state.iconsKey, {'s': 'cat'});
      expect(cubit.state.status, EventCreationStatus.initial);
    });

    test('honours initialPetId when it matches an owned pet', () async {
      when(() => referentialRepo.fetchEventTypes())
          .thenAnswer((_) async => [_souvenir]);
      when(() => petRepo.getPets()).thenAnswer((_) async => [_milo]);

      final cubit = buildCubit();
      await cubit.load(initialPetId: _milo.petId);

      expect(cubit.state.selectedPetIds, [_milo.petId]);
    });

    test('emits error status when types loading fails', () async {
      when(() => referentialRepo.fetchEventTypes())
          .thenThrow(Exception('boom'));

      final cubit = buildCubit();
      await cubit.load();

      expect(cubit.state.status, EventCreationStatus.error);
      expect(cubit.state.error, isNotNull);
    });
  });

  test('selectType / setSelectedPets update the selection', () async {
    when(() => referentialRepo.fetchEventTypes())
        .thenAnswer((_) async => [_souvenir, _anniversaire]);

    final cubit = buildCubit();
    await cubit.load();
    cubit.selectType(_anniversaire.eventTypeId);
    cubit.setSelectedPets([_milo.petId]);

    expect(cubit.state.selectedTypeId, _anniversaire.eventTypeId);
    expect(cubit.state.selectedPetIds, [_milo.petId]);
  });

  group('submit', () {
    test('creates the event linked to the selected pets and succeeds',
        () async {
      when(() => referentialRepo.fetchEventTypes())
          .thenAnswer((_) async => [_souvenir]);
      when(() => eventRepo.createEvent(any(), petIds: any(named: 'petIds')))
          .thenAnswer((_) async {});

      final cubit = buildCubit();
      await cubit.load();

      await cubit.submit(
        title: 'Premier bain',
        description: '  ',
        entryDate: DateTime(2026, 3, 5, 11, 43),
        images: const [],
      );

      final captured = verify(() => eventRepo.createEvent(
            captureAny(),
            petIds: captureAny(named: 'petIds'),
          )).captured;
      final event = captured[0] as EventModel;
      final petIds = captured[1] as List<String>;
      expect(event.title, 'Premier bain');
      expect(event.description, isNull); // blank description dropped
      expect(event.eventTypeId, _souvenir.eventTypeId);
      expect(petIds, [_milo.petId]);
      expect(cubit.state.status, EventCreationStatus.success);
    });

    test('emits error when no type is selected', () async {
      when(() => referentialRepo.fetchEventTypes()).thenAnswer((_) async => []);

      final cubit = buildCubit();
      await cubit.load();

      await cubit.submit(
        title: 'Sans type',
        entryDate: DateTime(2026),
        images: const [],
      );

      expect(cubit.state.status, EventCreationStatus.error);
      verifyNever(
          () => eventRepo.createEvent(any(), petIds: any(named: 'petIds')));
    });

    test('emits error when no pet is selected', () async {
      when(() => referentialRepo.fetchEventTypes())
          .thenAnswer((_) async => [_souvenir]);
      when(() => petRepo.getPets()).thenAnswer((_) async => []);

      final cubit = buildCubit();
      await cubit.load();

      await cubit.submit(
        title: 'Sans animal',
        entryDate: DateTime(2026),
        images: const [],
      );

      expect(cubit.state.status, EventCreationStatus.error);
      verifyNever(
          () => eventRepo.createEvent(any(), petIds: any(named: 'petIds')));
    });

    test('surfaces the repository message on network failure', () async {
      when(() => referentialRepo.fetchEventTypes())
          .thenAnswer((_) async => [_souvenir]);
      when(() => eventRepo.createEvent(any(), petIds: any(named: 'petIds')))
          .thenThrow(
        const RepositoryNetworkException('offline'),
      );

      final cubit = buildCubit();
      await cubit.load();

      await cubit.submit(
        title: 'Hors ligne',
        entryDate: DateTime(2026),
        images: const [],
      );

      expect(cubit.state.status, EventCreationStatus.error);
      expect(cubit.state.error, 'offline');
    });
  });
}
