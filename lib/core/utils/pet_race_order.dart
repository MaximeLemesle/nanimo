import 'package:nanimo/data/models/referential/pet_race_model.dart';

/// Order the breeds are offered in: alphabetical, with the catch-all last.
///
/// The database sorts on its own collation, which puts « Autre » in the A's
/// and leaves the accents to chance. Sorting here keeps the rule in one place
/// and the same on every screen.
abstract final class PetRaceOrder {
  const PetRaceOrder._();

  /// The breed that means "none of the above". It closes the list wherever it
  /// would otherwise fall.
  static const String catchAll = 'autre';

  static const Map<String, String> _foldings = {
    'à': 'a', 'â': 'a', 'ä': 'a',
    'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e',
    'î': 'i', 'ï': 'i',
    'ô': 'o', 'ö': 'o',
    'ù': 'u', 'û': 'u', 'ü': 'u',
    'ç': 'c',
  };

  /// Lowercased and stripped of its accents, so « Épagneul » sits with the E's
  /// and « Berger américain » before « Berger Australien ».
  static String sortKey(String name) {
    final lower = name.toLowerCase();
    final buffer = StringBuffer();
    for (final rune in lower.runes) {
      final char = String.fromCharCode(rune);
      buffer.write(_foldings[char] ?? char);
    }
    return buffer.toString();
  }

  static bool isCatchAll(PetRaceModel race) => sortKey(race.raceName) == catchAll;

  /// A new list: the caller's own may come straight from a cache.
  static List<PetRaceModel> sorted(List<PetRaceModel> races) {
    final ordered = [...races];
    ordered.sort((a, b) {
      final aIsCatchAll = isCatchAll(a);
      final bIsCatchAll = isCatchAll(b);
      if (aIsCatchAll != bIsCatchAll) return aIsCatchAll ? 1 : -1;
      return sortKey(a.raceName).compareTo(sortKey(b.raceName));
    });
    return ordered;
  }
}
