import 'dart:convert';

/// The `given_name` claim of a Google id token.
String? googleGivenName(String idToken) {
  final parts = idToken.split('.');
  if (parts.length != 3) return null;
  try {
    final payload = jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
    final given = payload is Map ? payload['given_name'] : null;
    return given is String ? given : null;
  } on FormatException {
    return null;
  }
}

/// The first name to store after an SSO sign-in, or null to keep [storedName].
/// Only a name the signup trigger filled in is replaced, never one the user typed.
String? ssoFirstNameToStore({
  required String storedName,
  required String? givenName,
  required Map<String, dynamic> metadata,
  required String? email,
}) {
  final given = givenName?.trim();
  final stored = storedName.trim();
  if (given == null || given.isEmpty || given == stored) return null;
  final automatic = {
    metadata['full_name'],
    metadata['name'],
    if (email != null) email.split('@').first,
  }.whereType<String>().map((name) => name.trim());
  return automatic.contains(stored) ? given : null;
}
