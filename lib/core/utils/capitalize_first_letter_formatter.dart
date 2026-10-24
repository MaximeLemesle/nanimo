import 'package:flutter/services.dart';

/// Upper-cases the first letter typed, so a name starts with a capital even
/// when the keyboard's own capitalisation is off.
class CapitalizeFirstLetterFormatter extends TextInputFormatter {
  const CapitalizeFirstLetterFormatter();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    final index = text.indexOf(RegExp(r'\S'));
    if (index == -1) return newValue;
    final first = text[index].toUpperCase();
    if (first == text[index]) return newValue;
    return newValue.copyWith(text: text.replaceRange(index, index + 1, first));
  }
}
