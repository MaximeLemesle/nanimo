import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/utils/capitalize_first_letter_formatter.dart';

void main() {
  String format(String text) => const CapitalizeFirstLetterFormatter()
      .formatEditUpdate(TextEditingValue.empty, TextEditingValue(text: text))
      .text;

  test('capitalises the first letter only', () {
    expect(format('max'), 'Max');
    expect(format('mistigri-patapouf'), 'Mistigri-patapouf');
  });

  test('skips leading spaces and leaves the rest as typed', () {
    expect(format('  éclair'), '  Éclair');
    expect(format('MAX'), 'MAX');
    expect(format(''), '');
    expect(format('   '), '   ');
  });
}
