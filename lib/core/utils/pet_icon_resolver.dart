import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:nanimo/data/models/referential/pet_icon_model.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';

/// Resolves which image represents a pet: the icon of its breed when the
/// catalogue has one, the generic species icon otherwise. A pet with no breed,
/// or a breed nobody drew yet, always falls back instead of failing.
class PetIconResolver {
  const PetIconResolver._();

  static const String speciesIconDirectory = 'assets/icons/species';

  /// Asset shipped with the app for a species, keyed by `pet_species.icon_key`.
  static String speciesAsset(String iconKey) =>
      '$speciesIconDirectory/$iconKey.png';

  /// Portrait of every pet in [pets], keyed by pet id. Pets whose species is
  /// unknown are left out rather than given a broken asset.
  static Map<String, PetPortrait> portraitsByPet({
    required List<PetModel> pets,
    required List<PetIconModel> icons,
    required Map<String, String> speciesIconKeys,
  }) {
    final portraits = <String, PetPortrait>{};
    for (final pet in pets) {
      final iconKey = speciesIconKeys[pet.petSpeciesId];
      if (iconKey == null) continue;
      portraits[pet.petId] = PetPortrait(
        iconKey: iconKey,
        assetPath: findByRace(icons, pet.petRaceId)?.assetPath,
      );
    }
    return portraits;
  }

  static PetIconModel? findByRace(List<PetIconModel> icons, String? petRaceId) {
    if (petRaceId == null || petRaceId.isEmpty) return null;
    for (final icon in icons) {
      if (icon.petRaceId == petRaceId) return icon;
    }
    return null;
  }
}
