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
}
