import 'package:nanimo/data/models/referential/pet_species_model.dart';

class WeightFormatter {
  /// Replace . by ,
  static String label(double weight) {
    return '${weight.toStringAsFixed(1).replaceAll('.', ',')} kg';
  }

  /// [label] without the unit, to type back into an edit field.
  static String input(double weight) {
    return weight.toStringAsFixed(1).replaceAll('.', ',');
  }

  static double? parseWeight(String raw) {
    final value = double.tryParse(raw.trim().replaceAll(',', '.'));
    if (value == null || value <= 0) return null;
    return value;
  }

  static WeightUnit parseWeightUnit(String value) {
    switch (value) {
      case 'g':
        return WeightUnit.g;
      case 'kg':
      default:
        return WeightUnit.kg;
    }
  }
}
