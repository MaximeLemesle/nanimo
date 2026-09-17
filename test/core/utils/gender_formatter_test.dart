import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/utils/gender_formatter.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';

void main() {
  group('GenderFormatter.label', () {
    test('names each gender', () {
      expect(GenderFormatter.label(Gender.male), 'Mâle');
      expect(GenderFormatter.label(Gender.female), 'Femelle');
      expect(GenderFormatter.label(Gender.unknown), 'Inconnu');
    });
  });

  // NAN-091: vets say castration for a male, stérilisation for a female.
  group('GenderFormatter.neuteringLabel', () {
    test('says castré for a male', () {
      expect(GenderFormatter.neuteringLabel(Gender.male), 'Castré');
    });

    test('says stérilisée for a female', () {
      expect(GenderFormatter.neuteringLabel(Gender.female), 'Stérilisée');
    });

    test('falls back on the generic term when the gender is unknown', () {
      expect(GenderFormatter.neuteringLabel(Gender.unknown), 'Stérilisé');
    });

    test('never returns the same word for a male and a female', () {
      expect(
        GenderFormatter.neuteringLabel(Gender.male),
        isNot(GenderFormatter.neuteringLabel(Gender.female)),
      );
    });
  });
}
