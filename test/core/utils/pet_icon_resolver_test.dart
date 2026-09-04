import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/utils/pet_icon_resolver.dart';
import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:nanimo/data/models/referential/pet_icon_model.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';

PetIconModel buildIcon(
  String id, {
  String name = 'Icône',
  String? speciesId = 'sp-dog',
  bool isPremium = false,
}) {
  return PetIconModel(
    petIconId: id,
    petIconName: name,
    assetPath: 'assets/icons/species/$id.png',
    isPremium: isPremium,
    petSpeciesId: speciesId,
  );
}

void main() {
  const speciesIconKeys = {'sp-dog': 'dog', 'sp-cat': 'cat'};

  group('speciesAsset', () {
    test('builds the shipped path from the species icon key', () {
      expect(PetIconResolver.speciesAsset('dog'),
          'assets/icons/species/dog.png');
    });
  });

  group('resolve', () {
    test('returns the chosen icon asset when the pet has one', () {
      final icons = [buildIcon('border-collie')];

      final path = PetIconResolver.resolve(
        petIconId: 'border-collie',
        petSpeciesId: 'sp-dog',
        icons: icons,
        speciesIconKeys: speciesIconKeys,
      );

      expect(path, 'assets/icons/species/border-collie.png');
    });

    test('falls back to the species asset when the pet picked nothing', () {
      final path = PetIconResolver.resolve(
        petIconId: null,
        petSpeciesId: 'sp-dog',
        icons: [buildIcon('border-collie')],
        speciesIconKeys: speciesIconKeys,
      );

      expect(path, 'assets/icons/species/dog.png');
    });

    /// A pet pointing at a deleted catalogue row must not lose its avatar.
    test('falls back to the species asset when the icon no longer exists', () {
      final path = PetIconResolver.resolve(
        petIconId: 'removed',
        petSpeciesId: 'sp-dog',
        icons: [buildIcon('border-collie')],
        speciesIconKeys: speciesIconKeys,
      );

      expect(path, 'assets/icons/species/dog.png');
    });

    test('returns null when the species itself is unknown', () {
      final path = PetIconResolver.resolve(
        petIconId: null,
        petSpeciesId: 'sp-ferret',
        icons: const [],
        speciesIconKeys: speciesIconKeys,
      );

      expect(path, isNull);
    });
  });

  group('portraitsByPet', () {
    PetModel buildPet(String id, {String? iconId, String speciesId = 'sp-dog'}) {
      return PetModel(
        petId: id,
        petName: id,
        birthdate: DateTime.utc(2020, 1, 1),
        gender: Gender.male,
        createdAt: DateTime.utc(2024, 1, 1),
        petRaceId: 'race-1',
        petSpeciesId: speciesId,
        petIconId: iconId,
      );
    }

    test('gives the chosen icon to the pet that picked it, species to others',
        () {
      final portraits = PetIconResolver.portraitsByPet(
        pets: [buildPet('p1', iconId: 'collie'), buildPet('p2')],
        icons: [buildIcon('collie')],
        speciesIconKeys: speciesIconKeys,
      );

      expect(portraits['p1'],
          const PetPortrait(iconKey: 'dog', assetPath: 'assets/icons/species/collie.png'));
      expect(portraits['p2'], const PetPortrait.species('dog'));
    });

    /// A broken species would give a path pointing nowhere, so the pet is
    /// dropped and the caller falls back to its own placeholder.
    test('leaves out a pet whose species is unknown', () {
      final portraits = PetIconResolver.portraitsByPet(
        pets: [buildPet('p1', speciesId: 'sp-ferret')],
        icons: const [],
        speciesIconKeys: speciesIconKeys,
      );

      expect(portraits, isEmpty);
    });

    test('falls back when the chosen icon no longer exists', () {
      final portraits = PetIconResolver.portraitsByPet(
        pets: [buildPet('p1', iconId: 'removed')],
        icons: [buildIcon('collie')],
        speciesIconKeys: speciesIconKeys,
      );

      expect(portraits['p1'], const PetPortrait.species('dog'));
    });
  });

  group('forSpecies', () {
    test('keeps only the icons of the requested species', () {
      final icons = [
        buildIcon('collie', speciesId: 'sp-dog'),
        buildIcon('persan', speciesId: 'sp-cat'),
        buildIcon('siamois', speciesId: 'sp-cat'),
      ];

      final result = PetIconResolver.forSpecies(icons, 'sp-cat');

      expect(result.map((i) => i.petIconId), ['persan', 'siamois']);
    });

    test('sorts free icons before premium ones', () {
      final icons = [
        buildIcon('a-premium', name: 'A', isPremium: true),
        buildIcon('z-free', name: 'Z'),
      ];

      final result = PetIconResolver.forSpecies(icons, 'sp-dog');

      expect(result.map((i) => i.petIconId), ['z-free', 'a-premium']);
    });

    test('returns nothing when the species is unknown', () {
      expect(PetIconResolver.forSpecies([buildIcon('collie')], null), isEmpty);
    });
  });
}
