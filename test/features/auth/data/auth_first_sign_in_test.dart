import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/auth/data/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

User _user({required String createdAt, String? lastSignInAt}) => User(
      id: 'u1',
      appMetadata: const {},
      userMetadata: const {},
      aud: 'authenticated',
      createdAt: createdAt,
      lastSignInAt: lastSignInAt,
    );

void main() {
  test('an account signed in seconds after its creation is new', () {
    final user = _user(createdAt: '2026-10-16T10:00:00Z', lastSignInAt: '2026-10-16T10:00:02Z');
    expect(AuthRepository.isFirstSignIn(user), isTrue);
  });

  test('an account created days before is a returning one', () {
    final user = _user(createdAt: '2026-10-01T10:00:00Z', lastSignInAt: '2026-10-16T10:00:00Z');
    expect(AuthRepository.isFirstSignIn(user), isFalse);
  });

  test('missing data is never counted as a creation', () {
    expect(AuthRepository.isFirstSignIn(null), isFalse);
    expect(AuthRepository.isFirstSignIn(_user(createdAt: '2026-10-16T10:00:00Z')), isFalse);
  });
}
