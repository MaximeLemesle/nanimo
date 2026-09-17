import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/utils/weight_formatter.dart';

void main() {
  group('WeightFormatter.label', () {
    test('renders one decimal with a comma and the unit', () {
      expect(WeightFormatter.label(3.2), '3,2 kg');
      expect(WeightFormatter.label(12), '12,0 kg');
    });
  });

  // NAN-080: the edit form has to type the stored weight back into the field.
  group('WeightFormatter.input', () {
    test('renders the same value without the unit', () {
      expect(WeightFormatter.input(3.2), '3,2');
      expect(WeightFormatter.input(12), '12,0');
    });

    test('round-trips through parseWeight', () {
      expect(WeightFormatter.parseWeight(WeightFormatter.input(3.2)), 3.2);
      expect(WeightFormatter.parseWeight(WeightFormatter.input(0.3)), 0.3);
    });
  });

  group('WeightFormatter.parseWeight', () {
    test('accepts a comma and rejects a non-positive value', () {
      expect(WeightFormatter.parseWeight('3,2'), 3.2);
      expect(WeightFormatter.parseWeight('0'), isNull);
      expect(WeightFormatter.parseWeight('abc'), isNull);
    });
  });
}
