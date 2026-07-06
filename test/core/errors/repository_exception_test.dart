import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('mapRepositoryError', () {
    test('maps a PostgrestException to a server exception', () {
      final mapped = mapRepositoryError(
        const PostgrestException(message: 'RLS violation'),
        StackTrace.current,
        operation: 'createEvent',
        networkMessage: 'hors-ligne',
      );

      expect(mapped, isA<RepositoryServerException>());
    });

    test('maps a StorageException to a server exception', () {
      final mapped = mapRepositoryError(
        const StorageException('bucket not found'),
        StackTrace.current,
        operation: 'uploadEventImage',
        networkMessage: 'hors-ligne',
      );

      expect(mapped, isA<RepositoryServerException>());
    });

    test('falls back to a network exception with the given message', () {
      final mapped = mapRepositoryError(
        Exception('socket closed'),
        StackTrace.current,
        operation: 'createEvent',
        networkMessage: 'hors-ligne',
      );

      expect(mapped, isA<RepositoryNetworkException>());
      expect(mapped.message, 'hors-ligne');
    });

    test('passes an existing RepositoryException through unchanged', () {
      const original = RepositoryNetworkException('déjà typée');

      final mapped = mapRepositoryError(
        original,
        StackTrace.current,
        operation: 'createPet',
        networkMessage: 'autre',
      );

      expect(mapped, same(original));
    });
  });
}
