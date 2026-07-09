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

    test('translates a known Postgres code into a clear message', () {
      final mapped = mapRepositoryError(
        const PostgrestException(message: 'permission denied', code: '42501'),
        StackTrace.current,
        operation: 'updateEvent',
        networkMessage: 'hors-ligne',
        serverMessage: 'Impossible de modifier le souvenir.',
      );

      expect(
        mapped.message,
        'Vous n’avez pas les droits nécessaires pour cette action.',
      );
    });

    test('translates a unique violation into a clear message', () {
      final mapped = mapRepositoryError(
        const PostgrestException(message: 'duplicate key', code: '23505'),
        StackTrace.current,
        operation: 'createEvent',
        networkMessage: 'hors-ligne',
      );

      expect(mapped.message, 'Cet élément existe déjà.');
    });

    test('falls back to the operation serverMessage for an unknown code', () {
      final mapped = mapRepositoryError(
        const PostgrestException(message: 'boom', code: 'P0001'),
        StackTrace.current,
        operation: 'createEvent',
        networkMessage: 'hors-ligne',
        serverMessage: 'Impossible de créer le souvenir pour le moment.',
      );

      expect(mapped.message, 'Impossible de créer le souvenir pour le moment.');
    });

    test('never surfaces the old generic server message', () {
      final mapped = mapRepositoryError(
        const PostgrestException(message: 'boom'),
        StackTrace.current,
        operation: 'createEvent',
        networkMessage: 'hors-ligne',
      );

      expect(
        mapped.message,
        isNot('Une erreur est survenue côté serveur. Réessayez plus tard.'),
      );
    });

    test('translates a storage payload-too-large error', () {
      final mapped = mapRepositoryError(
        const StorageException('too large', statusCode: '413'),
        StackTrace.current,
        operation: 'uploadEventImage',
        networkMessage: 'hors-ligne',
      );

      expect(mapped.message, 'Ce fichier est trop volumineux.');
    });
  });
}
