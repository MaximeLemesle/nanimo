import 'package:nanimo/data/models/referential/pet_icon_model.dart';

/// Resolves which image represents a pet: its chosen catalogue icon when it has
/// one, the generic species icon otherwise. A pet created before the catalogue
/// existed, or pointing at a deleted icon, always falls back instead of failing.
class PetIconResolver {
  const PetIconResolver._();

  static const String speciesIconDirectory = 'assets/icons/species';

  /// Asset shipped with the app for a species, keyed by `pet_species.icon_key`.
  static String speciesAsset(String iconKey) =>
      '$speciesIconDirectory/$iconKey.png';

  /// [icons] is the whole catalogue, [speciesIconKeys] maps a species id to its
  /// generic icon key. Returns null only when the species itself is unknown.
  static String? resolve({
    required String? petIconId,
    required String? petSpeciesId,
    required List<PetIconModel> icons,
    required Map<String, String> speciesIconKeys,
  }) {
    final chosen = findById(icons, petIconId);
    if (chosen != null) return chosen.assetPath;

    final iconKey = petSpeciesId == null ? null : speciesIconKeys[petSpeciesId];
    return iconKey == null ? null : speciesAsset(iconKey);
  }

  static PetIconModel? findById(List<PetIconModel> icons, String? petIconId) {
    if (petIconId == null) return null;
    for (final icon in icons) {
      if (icon.petIconId == petIconId) return icon;
    }
    return null;
  }

  /// Catalogue entries offered for [petSpeciesId], free ones first so the
  /// gallery never opens on a row the user cannot pick.
  static List<PetIconModel> forSpecies(
    List<PetIconModel> icons,
    String? petSpeciesId,
  ) {
    if (petSpeciesId == null) return const [];
    final matching =
        icons.where((icon) => icon.petSpeciesId == petSpeciesId).toList()
          ..sort((a, b) {
            if (a.isPremium != b.isPremium) return a.isPremium ? 1 : -1;
            return a.petIconName.compareTo(b.petIconName);
          });
    return matching;
  }
}
