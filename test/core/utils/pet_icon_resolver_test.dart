import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/utils/pet_icon_resolver.dart';
import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:nanimo/data/models/referential/pet_icon_model.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';

PetIconModel buildIcon(
  String id, {
  String name = 'Icône',
  String? speciesId = 'sp-dog',
  String? raceId = 'race-collie',
  bool isPremium = false,
}) {
  return PetIconModel(
    petIconId: id,
    petIconName: name,
    assetPath: 'assets/icons/species/$id.png',
    isPremium: isPremium,
    petSpeciesId: speciesId,
    petRaceId: raceId,
  );
}

PetModel buildPet(
  String id, {
  String? raceId = 'race-collie',
  String speciesId = 'sp-dog',
  String? iconId,
}) {
  return PetModel(
    petId: id,
    petName: id,
    birthdate: DateTime.utc(2020, 1, 1),
    gender: Gender.male,
    createdAt: DateTime.utc(2024, 1, 1),
    petRaceId: raceId ?? '',
    petSpeciesId: speciesId,
    petIconId: iconId,
  );
}

void main() {
  const speciesIconKeys = {
    'sp-dog': 'dog-jack_russell_terrier',
    'sp-cat': 'cat-europeen',
  };

  group('speciesAsset', () {
    test('builds the shipped path from the species icon key', () {
      expect(
        PetIconResolver.speciesAsset('cat-europeen'),
        'assets/icons/species/cat-europeen.png',
      );
    });
  });

  group('findByRace', () {
    test('finds the icon drawn for that breed', () {
      final icons = [
        buildIcon('collie', raceId: 'race-collie'),
        buildIcon('chihuahua', raceId: 'race-chihuahua'),
      ];

      expect(PetIconResolver.findByRace(icons, 'race-chihuahua')?.petIconId,
          'chihuahua');
    });

    test('returns null for a breed nobody drew', () {
      expect(PetIconResolver.findByRace([buildIcon('collie')], 'race-labrador'),
          isNull);
    });

    /// A pet created without a breed carries an empty string, not null.
    test('returns null for a missing or empty breed', () {
      final icons = [buildIcon('collie')];

      expect(PetIconResolver.findByRace(icons, null), isNull);
      expect(PetIconResolver.findByRace(icons, ''), isNull);
    });
  });

  group('findById', () {
    test('finds the icon stamped on the pet', () {
      final icons = [buildIcon('collie'), buildIcon('chihuahua')];

      expect(PetIconResolver.findById(icons, 'chihuahua')?.petIconId,
          'chihuahua');
    });

    test('returns null for a missing, empty or withdrawn id', () {
      final icons = [buildIcon('collie')];

      expect(PetIconResolver.findById(icons, null), isNull);
      expect(PetIconResolver.findById(icons, ''), isNull);
      expect(PetIconResolver.findById(icons, 'chihuahua'), isNull);
    });
  });

  group('defaultIcon', () {
    test('stamps the icon drawn for the breed', () {
      final icons = [
        buildIcon('collie', raceId: 'race-collie'),
        buildIcon('jack', raceId: 'race-jack'),
      ];

      expect(
        PetIconResolver.defaultIcon(
          icons: icons,
          petRaceId: 'race-jack',
          speciesIconKey: 'dog-jack_russell_terrier',
        )?.petIconId,
        'jack',
      );
    });

    /// The species fallback is itself a catalogue row, so a pet with no drawn
    /// breed still gets a real icon id rather than nothing.
    test('falls back to the catalogue row the species points at', () {
      final icons = [
        buildIcon('collie', raceId: 'race-collie'),
        buildIcon('dog-jack_russell_terrier', raceId: 'race-jack'),
      ];

      expect(
        PetIconResolver.defaultIcon(
          icons: icons,
          petRaceId: 'race-labrador',
          speciesIconKey: 'dog-jack_russell_terrier',
        )?.petIconId,
        'dog-jack_russell_terrier',
      );
    });

    test('gives nothing when the catalogue is empty', () {
      expect(
        PetIconResolver.defaultIcon(
          icons: const [],
          petRaceId: 'race-collie',
          speciesIconKey: 'dog-jack_russell_terrier',
        ),
        isNull,
      );
    });
  });

  group('portraitsByPet', () {
    test('gives each pet the icon of its own breed', () {
      final portraits = PetIconResolver.portraitsByPet(
        pets: [
          buildPet('p1', raceId: 'race-collie'),
          buildPet('p2', raceId: 'race-chihuahua'),
        ],
        icons: [
          buildIcon('collie', raceId: 'race-collie'),
          buildIcon('chihuahua', raceId: 'race-chihuahua'),
        ],
        speciesIconKeys: speciesIconKeys,
      );

      expect(
        portraits['p1'],
        const PetPortrait(
          iconKey: 'dog-jack_russell_terrier',
          assetPath: 'assets/icons/species/collie.png',
        ),
      );
      expect(
        portraits['p2'],
        const PetPortrait(
          iconKey: 'dog-jack_russell_terrier',
          assetPath: 'assets/icons/species/chihuahua.png',
        ),
      );
    });

    /// A pet keeps the icon it was created with, even once its breed is drawn
    /// differently, so a portrait never changes behind the owner's back.
    test('prefers the icon stamped on the pet over the one of its breed', () {
      final portraits = PetIconResolver.portraitsByPet(
        pets: [buildPet('p1', raceId: 'race-collie', iconId: 'chihuahua')],
        icons: [
          buildIcon('collie', raceId: 'race-collie'),
          buildIcon('chihuahua', raceId: 'race-chihuahua'),
        ],
        speciesIconKeys: speciesIconKeys,
      );

      expect(
        portraits['p1'],
        const PetPortrait(
          iconKey: 'dog-jack_russell_terrier',
          assetPath: 'assets/icons/species/chihuahua.png',
        ),
      );
    });

    /// Pets created before the column was filled carry nothing, and the breed
    /// still has to answer for them.
    test('falls back to the breed when the pet carries no icon', () {
      final portraits = PetIconResolver.portraitsByPet(
        pets: [buildPet('p1', raceId: 'race-collie', iconId: null)],
        icons: [buildIcon('collie', raceId: 'race-collie')],
        speciesIconKeys: speciesIconKeys,
      );

      expect(
        portraits['p1'],
        const PetPortrait(
          iconKey: 'dog-jack_russell_terrier',
          assetPath: 'assets/icons/species/collie.png',
        ),
      );
    });

    test('falls back to the species icon for a breed nobody drew', () {
      final portraits = PetIconResolver.portraitsByPet(
        pets: [buildPet('p1', raceId: 'race-labrador')],
        icons: [buildIcon('collie')],
        speciesIconKeys: speciesIconKeys,
      );

      expect(portraits['p1'],
          const PetPortrait.species('dog-jack_russell_terrier'));
    });

    test('falls back for a pet with no breed at all', () {
      final portraits = PetIconResolver.portraitsByPet(
        pets: [buildPet('p1', raceId: null)],
        icons: [buildIcon('collie')],
        speciesIconKeys: speciesIconKeys,
      );

      expect(portraits['p1'],
          const PetPortrait.species('dog-jack_russell_terrier'));
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
  });
}
