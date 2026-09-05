import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:nanimo/data/models/referential/pet_species_model.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/event/data/event_repository.dart';
import 'package:nanimo/features/event/data/models/event_image_model.dart';
import 'package:nanimo/features/event/data/models/event_model.dart';
import 'package:nanimo/features/event/data/models/event_type_model.dart';
import 'package:nanimo/features/event/presentation/cubit/edit_event_cubit.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';

class _MockEventRepository extends Mock implements EventRepository {}

class _MockReferentialRepository extends Mock implements ReferentialRepository {}

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
  iconKey: 'cat-europeen',
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

final _event = EventModel(
  eventId: 'e1',
  title: 'Promenade au parc',
  description: 'Une belle journée.',
  entryDate: DateTime(2026, 3, 5),
  createdAt: DateTime(2026, 3, 5),
  eventTypeId: 't-souvenir',
);

const _image = EventImageModel(
  eventImageId: 'img-1',
  assetPath: 'assets/img-1.png',
  eventId: 'e1',
);

void main() {
  late _MockEventRepository eventRepo;
  late _MockReferentialRepository referentialRepo;
  late _MockPetRepository petRepo;

  EditEventCubit buildCubit() => EditEventCubit(
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
    registerFallbackValue(File('fallback.jpg'));
  });

  setUp(() {
    eventRepo = _MockEventRepository();
    referentialRepo = _MockReferentialRepository();
    petRepo = _MockPetRepository();

    when(() => eventRepo.getEventById('e1')).thenAnswer((_) async => _event);
    when(() => eventRepo.getPetIdsForEvent('e1')).thenAnswer((_) async => ['pet-milo']);
    when(() => eventRepo.watchImagesForEvent('e1')).thenAnswer((_) => Stream.value([_image]));
    when(() => petRepo.getPets()).thenAnswer((_) async => [_milo]);
    when(() => referentialRepo.fetchEventTypes()).thenAnswer((_) async => [_souvenir, _anniversaire]);
    when(() => referentialRepo.fetchSpecies()).thenAnswer((_) async => [_catSpecies]);
  });

  group('load', () {
    test('loads the event, its pets, images, types and pets', () async {
      final cubit = buildCubit();
      await cubit.load('e1');

      expect(cubit.state.event, _event);
      expect(cubit.state.existingImages, [_image]);
      expect(cubit.state.selectedPetIds, ['pet-milo']);
      expect(cubit.state.pets, [_milo]);
      expect(cubit.state.types, [_souvenir, _anniversaire]);
      expect(cubit.state.selectedTypeId, 't-souvenir');
      expect(cubit.state.iconsKey, {'s': 'cat-europeen'});
      expect(cubit.state.isLoaded, isTrue);
    });

    test('emits an error when the event cannot be found', () async {
      when(() => eventRepo.getEventById('missing')).thenAnswer((_) async => null);

      final cubit = buildCubit();
      await cubit.load('missing');

      expect(cubit.state.status, EditEventStatus.error);
      expect(cubit.state.event, isNull);
    });

    test('emits an error status when types loading fails', () async {
      when(() => referentialRepo.fetchEventTypes()).thenThrow(Exception('boom'));

      final cubit = buildCubit();
      await cubit.load('e1');

      expect(cubit.state.status, EditEventStatus.error);
      expect(cubit.state.error, isNotNull);
    });
  });

  test('selectType / setSelectedPets update the selection', () async {
    final cubit = buildCubit();
    await cubit.load('e1');

    cubit.selectType(_anniversaire.eventTypeId);
    cubit.setSelectedPets(['pet-milo']);

    expect(cubit.state.selectedTypeId, _anniversaire.eventTypeId);
    expect(cubit.state.selectedPetIds, ['pet-milo']);
  });

  group('submit', () {
    test('updates the event, syncs pets and applies photo changes', () async {
      when(() => eventRepo.updateEvent(any())).thenAnswer((_) async {});
      when(() => eventRepo.updateEventPets(any(), any())).thenAnswer((_) async {});
      when(() => eventRepo.deleteImage(any(), any())).thenAnswer((_) async {});
      when(() => eventRepo.uploadEventImage(any(), any())).thenAnswer((_) async => 'new/path.jpg');
      when(() => eventRepo.addImage(any())).thenAnswer((_) async {});

      final cubit = buildCubit();
      await cubit.load('e1');

      await cubit.submit(
        title: 'Nouveau titre',
        description: '  ',
        entryDate: DateTime(2026, 4, 1),
        newImages: const [],
        removedImages: [_image],
      );

      final captured = verify(() => eventRepo.updateEvent(captureAny())).captured;
      final updated = captured.single as EventModel;
      expect(updated.title, 'Nouveau titre');
      expect(updated.description, isNull);
      expect(updated.eventId, 'e1');

      verify(() => eventRepo.updateEventPets('e1', ['pet-milo'])).called(1);
      verify(() => eventRepo.deleteImage('img-1', 'assets/img-1.png')).called(1);
      expect(cubit.state.status, EditEventStatus.success);
    });

    test('emits error when no pet is selected', () async {
      final cubit = buildCubit();
      await cubit.load('e1');
      cubit.setSelectedPets(const []);

      await cubit.submit(
        title: 'Sans animal',
        entryDate: DateTime(2026),
        newImages: const [],
        removedImages: const [],
      );

      expect(cubit.state.status, EditEventStatus.error);
      verifyNever(() => eventRepo.updateEvent(any()));
    });

    test('surfaces the repository message on network failure', () async {
      when(() => eventRepo.updateEvent(any())).thenThrow(
        const RepositoryNetworkException('offline'),
      );

      final cubit = buildCubit();
      await cubit.load('e1');

      await cubit.submit(
        title: 'Hors ligne',
        entryDate: DateTime(2026),
        newImages: const [],
        removedImages: const [],
      );

      expect(cubit.state.status, EditEventStatus.error);
      expect(cubit.state.error, 'offline');
    });
  });
}
