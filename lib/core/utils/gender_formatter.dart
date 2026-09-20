import 'package:nanimo/features/pet/data/models/pet_model.dart';

class GenderFormatter {
  static String label(Gender gender) {
    switch (gender) {
      case Gender.male:
        return 'Mâle';
      case Gender.female:
        return 'Femelle';
      case Gender.unknown:
        return 'Inconnu';
    }
  }

  /// Vets say « castration » for a male, « stérilisation » for a female.
  /// No species of the catalogue calls for a third word.
  static String neuteringLabel(Gender gender) {
    switch (gender) {
      case Gender.male:
        return 'Castré';
      case Gender.female:
        return 'Stérilisée';
      case Gender.unknown:
        return 'Stérilisé';
    }
  }
}
