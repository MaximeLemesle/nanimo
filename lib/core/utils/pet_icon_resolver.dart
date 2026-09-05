import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:nanimo/data/models/referential/pet_icon_model.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';

/// Resolves which image represents a pet: the icon it was created with when it
/// still exists, the icon of its breed otherwise, and the generic species icon
/// as a last resort. A pet with no breed, or a breed nobody drew yet, always
/// falls back instead of failing.
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
      final icon = findById(icons, pet.petIconId) ??
          findByRace(icons, pet.petRaceId);
      portraits[pet.petId] = PetPortrait(
        iconKey: iconKey,
        assetPath: icon?.assetPath,
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

  static PetIconModel? findById(List<PetIconModel> icons, String? petIconId) {
    if (petIconId == null || petIconId.isEmpty) return null;
    for (final icon in icons) {
      if (icon.petIconId == petIconId) return icon;
    }
    return null;
  }

  /// Icon a pet is stamped with when it is created: the one drawn for its
  /// breed, else the catalogue row its species falls back on. Written to the
  /// pet so its portrait survives the breed losing or changing its drawing.
  static PetIconModel? defaultIcon({
    required List<PetIconModel> icons,
    required String? petRaceId,
    required String? speciesIconKey,
  }) {
    final byRace = findByRace(icons, petRaceId);
    if (byRace != null) return byRace;
    if (speciesIconKey == null) return null;
    final asset = speciesAsset(speciesIconKey);
    for (final icon in icons) {
      if (icon.assetPath == asset) return icon;
    }
    return null;
  }
}
