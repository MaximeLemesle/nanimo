import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// NAN-119: the App Store reads the language from the iOS bundle, not from
/// Flutter. The app only speaks French, so the bundle must say so.
void main() {
  test('Info.plist declares French as the only localization', () {
    final plist = File('ios/Runner/Info.plist').readAsStringSync();
    final localizations = RegExp(r'<key>CFBundleLocalizations</key>\s*<array>(.*?)</array>', dotAll: true)
        .firstMatch(plist)
        ?.group(1);

    expect(localizations, isNotNull, reason: 'CFBundleLocalizations missing');
    expect(RegExp(r'<string>(\w+)</string>').allMatches(localizations!).map((m) => m.group(1)), ['fr']);
  });

  test('Xcode project develops in French', () {
    final project = File('ios/Runner.xcodeproj/project.pbxproj').readAsStringSync();

    expect(project, contains('developmentRegion = fr;'));
    expect(project, isNot(matches(RegExp(r'knownRegions = \([^)]*\ben,'))));
  });
}
