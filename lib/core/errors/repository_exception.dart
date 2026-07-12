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

class RepositoryNetworkException extends RepositoryException {
  const RepositoryNetworkException(super.message);
}

const String _defaultServerMessage =
    'Le serveur n’a pas pu traiter votre demande. Réessayez dans un instant.';

/// Maps raw error
/// - [operation]: technical identifier, only used for logging.
/// - [networkMessage]: shown when the request never reached the server.
/// - [serverMessage]: shown when the server rejects
RepositoryException mapRepositoryError(
  Object error,
  StackTrace stackTrace, {
  required String operation,
  required String networkMessage,
  String? serverMessage,
}) {
  developer.log(
    '$operation failed',
    name: 'repository',
    error: error,
    stackTrace: stackTrace,
  );

  if (error is RepositoryException) return error;

  if (error is PostgrestException) {
    return RepositoryServerException(_postgrestMessage(error, serverMessage));
  }

  if (error is StorageException) {
    return RepositoryServerException(_storageMessage(error, serverMessage));
  }

  return RepositoryNetworkException(networkMessage);
}

String _postgrestMessage(PostgrestException error, String? serverMessage) {
  switch (error.code) {
    case '23505': // unique_violation
      return 'Cet élément existe déjà.';
    case '23503': // foreign_key_violation
      return 'Action impossible : cet élément est lié à d’autres données.';
    case '23502': // not_null_violation
      return 'Il manque une information obligatoire.';
    case '23514': // check_violation
      return 'Certaines informations saisies ne sont pas valides.';
    case '42501': // insufficient_privilege (RLS)
      return 'Vous n’avez pas les droits nécessaires pour cette action.';
    case 'PGRST116': // no rows where exactly one was expected
      return 'Cet élément est introuvable.';
    case 'PGRST301': // JWT expired
    case '401':
      return 'Votre session a expiré. Reconnectez-vous.';
  }
  return serverMessage ?? _defaultServerMessage;
}

String _storageMessage(StorageException error, String? serverMessage) {
  switch (error.statusCode) {
    case '413': // payload too large
      return 'Ce fichier est trop volumineux.';
    case '403': // forbidden
      return 'Vous n’avez pas les droits pour accéder à ce fichier.';
    case '404': // not found
      return 'Ce fichier est introuvable.';
    case '401': // unauthorized
      return 'Votre session a expiré. Reconnectez-vous.';
  }
  return serverMessage ?? _defaultServerMessage;
}
