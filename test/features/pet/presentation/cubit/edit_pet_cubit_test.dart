import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:nanimo/data/models/referential/pet_icon_model.dart';
import 'package:nanimo/data/models/referential/pet_race_model.dart';
import 'package:nanimo/data/models/referential/pet_species_model.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/event/data/event_repository.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';
import 'package:nanimo/features/pet/presentation/cubit/edit_pet_cubit.dart';

class _MockPetRepository extends Mock implements PetRepository {}

class _MockReferentialRepository extends Mock implements ReferentialRepository {}

class _MockEventRepository extends Mock implements EventRepository {}

const _catSpecies = PetSpeciesModel(
  petSpeciesId: 'sp-cat',
  speciesName: 'Chat',
  weightUnit: WeightUnit.kg,
  iconKey: 'cat-europeen',
);

const _europeen = PetRaceModel(
  petRaceId: 'race-europeen',
  raceName: 'Européen',
  petSpeciesId: 'sp-cat',
);

const _siamois = PetRaceModel(
  petRaceId: 'race-siamois',
  raceName: 'Siamois',
  petSpeciesId: 'sp-cat',
);

const _europeenIcon = PetIconModel(
  petIconId: 'icon-europeen',
  petIconName: 'Européen',
  assetPath: 'assets/icons/species/cat-europeen.png',
  isPremium: false,
  petSpeciesId: 'sp-cat',
  petRaceId: 'race-europeen',
);

const _siamoisIcon = PetIconModel(
  petIconId: 'icon-siamois',
  petIconName: 'Siamois',
  assetPath: 'assets/icons/cats/siamois.png',
  isPremium: false,
  petSpeciesId: 'sp-cat',
  petRaceId: 'race-siamois',
);

PetModel buildMilo() => PetModel(
      petId: 'pet-milo',
      petName: 'Milo',
      birthdate: DateTime.utc(2022, 5, 1),
      gender: Gender.male,
      createdAt: DateTime.utc(2022, 5, 1),
      petRaceId: 'race-europeen',
      petSpeciesId: 'sp-cat',
      petIconId: 'icon-europeen',
    );

void main() {
  late _MockPetRepository petRepo;
  late _MockReferentialRepository referentialRepo;
  late _MockEventRepository eventRepo;

  EditPetCubit buildCubit() => EditPetCubit(
        petRepository: petRepo,
        referentialRepository: referentialRepo,
        eventRepository: eventRepo,
      );

  setUpAll(() {
    registerFallbackValue(buildMilo());
  });

  setUp(() {
    petRepo = _MockPetRepository();
    referentialRepo = _MockReferentialRepository();
    eventRepo = _MockEventRepository();

    when(() => petRepo.getPetById('pet-milo'))
        .thenAnswer((_) async => buildMilo());
    when(() => eventRepo.countEventsForPet('pet-milo'))
        .thenAnswer((_) async => 0);
    when(() => referentialRepo.fetchRacesBySpecies('sp-cat'))
        .thenAnswer((_) async => [_europeen, _siamois]);
    when(() => referentialRepo.fetchSpecies())
        .thenAnswer((_) async => [_catSpecies]);
    when(() => referentialRepo.fetchIcons())
        .thenAnswer((_) async => [_europeenIcon, _siamoisIcon]);
  });

  group('load', () {
    test('fills the form with the pet, its races, species and icons', () async {
      when(() => eventRepo.countEventsForPet('pet-milo'))
          .thenAnswer((_) async => 3);
      final cubit = buildCubit();

      await cubit.load('pet-milo');

      expect(cubit.state.isLoaded, isTrue);
      expect(cubit.state.pet!.petName, 'Milo');
      expect(cubit.state.races, [_europeen, _siamois]);
      expect(cubit.state.speciesName, 'Chat');
      expect(cubit.state.speciesIconKey, 'cat-europeen');
      expect(cubit.state.icons, [_europeenIcon, _siamoisIcon]);
      expect(cubit.state.eventCount, 3);
    });

    test('reports a missing pet instead of showing an empty form', () async {
      when(() => petRepo.getPetById('nope')).thenAnswer((_) async => null);
      final cubit = buildCubit();

      await cubit.load('nope');

      expect(cubit.state.status, EditPetStatus.error);
      expect(cubit.state.error, 'Cet animal est introuvable.');
      expect(cubit.state.isLoaded, isFalse);
    });

    test('reports a race loading failure', () async {
      when(() => referentialRepo.fetchRacesBySpecies('sp-cat'))
          .thenThrow(Exception('offline'));
      final cubit = buildCubit();

      await cubit.load('pet-milo');

      expect(cubit.state.status, EditPetStatus.error);
      expect(cubit.state.error, 'Impossible de charger les races.');
    });

    /// Icons are cosmetic: losing the catalogue must not block the form.
    test('stays usable when the icon catalogue fails to load', () async {
      when(() => referentialRepo.fetchIcons()).thenThrow(Exception('offline'));
      final cubit = buildCubit();

      await cubit.load('pet-milo');

      expect(cubit.state.isLoaded, isTrue);
      expect(cubit.state.status, isNot(EditPetStatus.error));
      expect(cubit.state.icons, isEmpty);
    });
  });

  group('submit', () {
    test('saves the edited fields and keeps the identity ones', () async {
      when(() => petRepo.updatePet(any())).thenAnswer((_) async {});
      final cubit = buildCubit();
      await cubit.load('pet-milo');

      await cubit.submit(
        petName: '  Miloute  ',
        petRaceId: 'race-europeen',
        gender: Gender.female,
        birthdate: DateTime.utc(2021, 3, 2),
      );

      final saved =
          verify(() => petRepo.updatePet(captureAny())).captured.single
              as PetModel;
      expect(saved.petName, 'Miloute');
      expect(saved.gender, Gender.female);
      expect(saved.birthdate, DateTime.utc(2021, 3, 2));
      expect(saved.petId, 'pet-milo');
      expect(saved.petSpeciesId, 'sp-cat');
      expect(saved.createdAt, DateTime.utc(2022, 5, 1));
      expect(cubit.state.status, EditPetStatus.success);
    });

    /// The icon is never picked by hand, it follows the breed.
    test('restamps the icon when the breed changes', () async {
      when(() => petRepo.updatePet(any())).thenAnswer((_) async {});
      final cubit = buildCubit();
      await cubit.load('pet-milo');

      await cubit.submit(
        petName: 'Milo',
        petRaceId: 'race-siamois',
        gender: Gender.male,
        birthdate: DateTime.utc(2022, 5, 1),
      );

      final saved =
          verify(() => petRepo.updatePet(captureAny())).captured.single
              as PetModel;
      expect(saved.petRaceId, 'race-siamois');
      expect(saved.petIconId, 'icon-siamois');
    });

    test('keeps the current icon when the catalogue is empty', () async {
      when(() => referentialRepo.fetchIcons()).thenAnswer((_) async => []);
      when(() => petRepo.updatePet(any())).thenAnswer((_) async {});
      final cubit = buildCubit();
      await cubit.load('pet-milo');

      await cubit.submit(
        petName: 'Milo',
        petRaceId: 'race-siamois',
        gender: Gender.male,
        birthdate: DateTime.utc(2022, 5, 1),
      );

      final saved =
          verify(() => petRepo.updatePet(captureAny())).captured.single
              as PetModel;
      expect(saved.petIconId, 'icon-europeen');
    });

    test('surfaces the repository message on a repository failure', () async {
      when(() => petRepo.updatePet(any())).thenThrow(
        const RepositoryNetworkException('Pas de connexion.'),
      );
      final cubit = buildCubit();
      await cubit.load('pet-milo');

      await cubit.submit(
        petName: 'Milo',
        petRaceId: 'race-europeen',
        gender: Gender.male,
        birthdate: DateTime.utc(2022, 5, 1),
      );

      expect(cubit.state.status, EditPetStatus.error);
      expect(cubit.state.error, 'Pas de connexion.');
    });

    test('falls back to a generic message on an unknown failure', () async {
      when(() => petRepo.updatePet(any())).thenThrow(Exception('boom'));
      final cubit = buildCubit();
      await cubit.load('pet-milo');

      await cubit.submit(
        petName: 'Milo',
        petRaceId: 'race-europeen',
        gender: Gender.male,
        birthdate: DateTime.utc(2022, 5, 1),
      );

      expect(cubit.state.status, EditPetStatus.error);
      expect(
        cubit.state.error,
        'Une erreur est survenue lors de la modification de l\'animal.',
      );
    });

    test('does nothing before the pet is loaded', () async {
      final cubit = buildCubit();

      await cubit.submit(
        petName: 'Milo',
        petRaceId: 'race-europeen',
        gender: Gender.male,
        birthdate: DateTime.utc(2022, 5, 1),
      );

      verifyNever(() => petRepo.updatePet(any()));
      expect(cubit.state.status, EditPetStatus.initial);
    });
  });

  group('delete', () {
    test('deletes the pet then purges its souvenirs from the cache', () async {
      when(() => petRepo.deletePet('pet-milo')).thenAnswer((_) async {});
      when(() => eventRepo.purgeLocalEventsForPet('pet-milo'))
          .thenAnswer((_) async {});
      final cubit = buildCubit();
      await cubit.load('pet-milo');

      await cubit.delete();

      verify(() => petRepo.deletePet('pet-milo')).called(1);
      verify(() => eventRepo.purgeLocalEventsForPet('pet-milo')).called(1);
      expect(cubit.state.status, EditPetStatus.deleted);
    });

    /// A failed server delete must not wipe the local souvenirs.
    test('leaves the cache alone when the deletion fails', () async {
      when(() => petRepo.deletePet('pet-milo')).thenThrow(
        const RepositoryNetworkException('Pas de connexion.'),
      );
      final cubit = buildCubit();
      await cubit.load('pet-milo');

      await cubit.delete();

      verifyNever(() => eventRepo.purgeLocalEventsForPet(any()));
      expect(cubit.state.status, EditPetStatus.error);
      expect(cubit.state.error, 'Pas de connexion.');
    });

    test('falls back to a generic message on an unknown failure', () async {
      when(() => petRepo.deletePet('pet-milo')).thenThrow(Exception('boom'));
      final cubit = buildCubit();
      await cubit.load('pet-milo');

      await cubit.delete();

      expect(cubit.state.status, EditPetStatus.error);
      expect(
        cubit.state.error,
        'Une erreur est survenue lors de la suppression de l\'animal.',
      );
    });

    test('does nothing before the pet is loaded', () async {
      final cubit = buildCubit();

      await cubit.delete();

      verifyNever(() => petRepo.deletePet(any()));
      expect(cubit.state.status, EditPetStatus.initial);
    });
  });
}
