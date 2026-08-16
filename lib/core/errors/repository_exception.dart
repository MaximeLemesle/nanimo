import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:nanimo/core/monitoring/error_reporter.dart';

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

  /// Already typed means an inner layer has reported it. Returning here is what
  /// keeps one failure from producing two events.
  if (error is RepositoryException) return error;

  errorReporter.addBreadcrumb('$operation a échoué', category: 'repository');

  /// A device that lost the network says nothing about the app, and reporting
  /// it would drown the quota. Everything else is either a server refusal or a
  /// cause we have not identified, and both are worth an alert.
  if (!_isOffline(error)) {
    errorReporter.captureException(
      error,
      stackTrace: stackTrace,
      hint: operation,
    );
  }

  if (error is PostgrestException) {
    return RepositoryServerException(_postgrestMessage(error, serverMessage));
  }

  if (error is StorageException) {
    return RepositoryServerException(_storageMessage(error, serverMessage));
  }

  return RepositoryNetworkException(networkMessage);
}

bool _isOffline(Object error) =>
    error is SocketException ||
    error is TimeoutException ||
    error is HandshakeException;

/// Raised before any request when the session is gone. Always reported, because
/// the user is blocked and no server error will ever say so. The returned type
/// and message are unchanged, so nothing moves for the user.
RepositoryException sessionExpired(String operation, String message) {
  errorReporter.captureException(
    StateError('$operation called without a session'),
    stackTrace: StackTrace.current,
    hint: operation,
  );
  return RepositoryNetworkException(message);
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
