import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/utils/chip_number.dart';

void main() {
  group('ChipNumber.isComplete', () {
    test('accepts the ISO length of fifteen digits', () {
      expect(ChipNumber.isComplete('250268500000001'), isTrue);
    });

    test('accepts the ten digits of an older chip', () {
      expect(ChipNumber.isComplete('0123456789'), isTrue);
    });

    test('rejects anything in between or beyond', () {
      expect(ChipNumber.isComplete('25026850000000'), isFalse);
      expect(ChipNumber.isComplete('012345678'), isFalse);
      expect(ChipNumber.isComplete(''), isFalse);
    });

    test('ignores surrounding whitespace', () {
      expect(ChipNumber.isComplete('  0123456789  '), isTrue);
    });
  });

  group('ChipNumber.warningFor', () {
    test('says nothing on an empty field', () {
      expect(ChipNumber.warningFor(''), isNull);
      expect(ChipNumber.warningFor('   '), isNull);
    });

    test('says nothing on a plausible length', () {
      expect(ChipNumber.warningFor('250268500000001'), isNull);
      expect(ChipNumber.warningFor('0123456789'), isNull);
    });

    test('warns on an incomplete number', () {
      expect(ChipNumber.warningFor('25026850000000'),
          ChipNumber.incompleteMessage);
    });
  });
}
