/// Fifteen digits for an ISO 11784 chip, ten for an older one.
/// Any other length is signalled, never refused.
abstract final class ChipNumber {
  static const int maxLength = 15;
  static const Set<int> validLengths = {10, maxLength};

  static const String incompleteMessage =
      'Un numéro de puce compte 15 chiffres, ou 10 pour les puces anciennes.';

  static bool isComplete(String value) =>
      validLengths.contains(value.trim().length);

  /// Null when there is nothing to say: empty field, or plausible length.
  static String? warningFor(String value) {
    final digits = value.trim();
    if (digits.isEmpty || isComplete(digits)) return null;
    return incompleteMessage;
  }
}
