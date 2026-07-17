import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('all app fonts are bundled as Flutter assets', () async {
    const fontAssetsByFamily = <String, List<String>>{
      'Comfortaa': ['assets/fonts/Comfortaa-Bold.ttf'],
      'Geologica': [
        'assets/fonts/Geologica-Light.ttf',
        'assets/fonts/Geologica-Medium.ttf',
        'assets/fonts/Geologica-Regular.ttf',
      ],
      'Gluten': [
        'assets/fonts/Gluten-Black.ttf',
        'assets/fonts/Gluten-ExtraBold.ttf',
      ],
      'Roboto': ['assets/fonts/Roboto-Medium.ttf'],
    };

    for (final fontAsset
        in fontAssetsByFamily.values.expand((fonts) => fonts)) {
      final fontData = await rootBundle.load(fontAsset);

      expect(fontData.lengthInBytes, greaterThan(0), reason: fontAsset);
    }

    final fontManifest = jsonDecode(
      await rootBundle.loadString('FontManifest.json'),
    ) as List<dynamic>;

    for (final MapEntry(key: family, value: expectedAssets)
        in fontAssetsByFamily.entries) {
      final familyEntry = fontManifest.cast<Map<String, dynamic>>().singleWhere(
            (entry) => entry['family'] == family,
          );
      final bundledAssets = (familyEntry['fonts'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map((font) => font['asset'])
          .toSet();

      expect(bundledAssets, containsAll(expectedAssets), reason: family);
    }
  });
}
