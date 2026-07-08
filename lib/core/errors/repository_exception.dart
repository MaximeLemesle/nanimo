import 'dart:developer' as developer;

import 'package:supabase_flutter/supabase_flutter.dart';

abstract class RepositoryException implements Exception {
  final String message;
  const RepositoryException(this.message);

  @override
  String toString() => message;
}

class RepositoryServerException extends RepositoryException {
  const RepositoryServerException(super.message);
}

RepositoryException mapRepositoryError(
  Object error,
  StackTrace stackTrace, {
  required String operation,
  required String networkMessage,
}) {
  developer.log(
    '$operation failed',
    name: 'repository',
    error: error,
    stackTrace: stackTrace,
  );
  if (error is RepositoryException) return error;
  if (error is PostgrestException || error is StorageException) {
    return const RepositoryServerException(
      'Une erreur est survenue côté serveur. Réessayez plus tard.',
    );
  }
  return RepositoryNetworkException(networkMessage);
}

class RepositoryNetworkException extends RepositoryException {
  const RepositoryNetworkException(super.message);
}
