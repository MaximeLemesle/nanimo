import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/auth/data/sso_first_name.dart';

String _idToken(Map<String, dynamic> claims) {
  String part(Map<String, dynamic> json) => base64Url.encode(utf8.encode(jsonEncode(json))).replaceAll('=', '');
  return '${part({'alg': 'RS256'})}.${part(claims)}.signature';
}

void main() {
  group('googleGivenName', () {
    test('reads the given_name claim', () {
      expect(googleGivenName(_idToken({'name': 'Maxime LEMESLE', 'given_name': 'Maxime'})), 'Maxime');
    });

    test('is null without the claim or on a malformed token', () {
      expect(googleGivenName(_idToken({'name': 'Maxime LEMESLE'})), isNull);
      expect(googleGivenName('not-a-jwt'), isNull);
    });
  });

  /// NAN-129: the signup trigger stores Google's full name, and for Apple
  /// the part of the email before the @, since Apple's token has no name.
  group('ssoFirstNameToStore', () {
    test('replaces the full name Google gave the trigger', () {
      expect(
        ssoFirstNameToStore(
          storedName: 'Maxime LEMESLE',
          givenName: 'Maxime',
          metadata: {'full_name': 'Maxime LEMESLE', 'name': 'Maxime LEMESLE'},
          email: 'maxime@gmail.com',
        ),
        'Maxime',
      );
    });

    test('replaces the email fallback with the name Apple gives once', () {
      expect(
        ssoFirstNameToStore(
          storedName: 'x7kq9p2m4z',
          givenName: 'Maxime',
          metadata: const {},
          email: 'x7kq9p2m4z@privaterelay.appleid.com',
        ),
        'Maxime',
      );
    });

    test('keeps a name the user typed in the settings', () {
      expect(
        ssoFirstNameToStore(
          storedName: 'Max',
          givenName: 'Maxime',
          metadata: {'full_name': 'Maxime LEMESLE'},
          email: 'maxime@gmail.com',
        ),
        isNull,
      );
    });

    test('does nothing without a given name or when already stored', () {
      final metadata = {'full_name': 'Maxime LEMESLE'};
      expect(
        ssoFirstNameToStore(storedName: 'Maxime LEMESLE', givenName: null, metadata: metadata, email: null),
        isNull,
      );
      expect(
        ssoFirstNameToStore(storedName: 'Maxime LEMESLE', givenName: '  ', metadata: metadata, email: null),
        isNull,
      );
      expect(
        ssoFirstNameToStore(storedName: 'Maxime', givenName: 'Maxime', metadata: metadata, email: null),
        isNull,
      );
    });
  });
}
