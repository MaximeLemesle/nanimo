import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
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

  /// A device that lost the network says nothing about the app, and a user
  /// closing the store sheet is not a failure at all. Everything else is worth
  /// an alert, and is reported raw so its real cause survives the mapping.
  if (!_isOffline(error) && !isPurchaseCancelled(error)) {
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

  if (error is PlatformException) {
    final message = _platformMessage(error, serverMessage);
    return _isOffline(error)
        ? RepositoryNetworkException(message)
        : RepositoryServerException(message);
  }

  return RepositoryNetworkException(networkMessage);
}

/// RevenueCat reports store failures as a [PlatformException] whose code is the
/// stringified index of a [PurchasesErrorCode]. Other plugins use their own
/// string codes, which have no meaning here.
PurchasesErrorCode? purchasesErrorCode(Object error) {
  if (error is! PlatformException) return null;
  if (int.tryParse(error.code) == null) return null;
  return PurchasesErrorHelper.getErrorCode(error);
}

/// The user closed the store sheet. Callers turn this into their own outcome
/// rather than showing an error, and it is never reported.
bool isPurchaseCancelled(Object error) =>
    purchasesErrorCode(error) == PurchasesErrorCode.purchaseCancelledError;

bool _isOffline(Object error) =>
    error is SocketException ||
    error is TimeoutException ||
    error is HandshakeException ||
    _offlinePurchasesCodes.contains(purchasesErrorCode(error));

/// RevenueCat surfaces a dead connection as a [PlatformException], which no
/// [SocketException] check would ever catch.
const Set<PurchasesErrorCode> _offlinePurchasesCodes = {
  PurchasesErrorCode.networkError,
  PurchasesErrorCode.offlineConnectionError,
};

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

String _platformMessage(PlatformException error, String? serverMessage) {
  switch (purchasesErrorCode(error)) {
    case PurchasesErrorCode.purchaseCancelledError:
      return 'Achat annulé.';
    case PurchasesErrorCode.purchaseNotAllowedError:
    case PurchasesErrorCode.insufficientPermissionsError:
      return 'Les achats sont désactivés sur cet appareil.';
    case PurchasesErrorCode.paymentPendingError:
      return 'Votre paiement est en attente de validation. Votre abonnement s’activera dès qu’il sera confirmé.';
    case PurchasesErrorCode.productAlreadyPurchasedError:
      return 'Vous possédez déjà cet abonnement. Utilisez « Restaurer mes achats ».';
    case PurchasesErrorCode.productNotAvailableForPurchaseError:
      return 'Cette formule n’est plus proposée par le store.';
    case PurchasesErrorCode.configurationError:
    case PurchasesErrorCode.invalidCredentialsError:
    case PurchasesErrorCode.invalidAppleSubscriptionKeyError:
      return 'Les abonnements sont momentanément indisponibles. Réessayez plus tard.';
    case PurchasesErrorCode.networkError:
    case PurchasesErrorCode.offlineConnectionError:
      return 'Le store est injoignable. Vérifiez votre connexion et réessayez.';
    case PurchasesErrorCode.storeProblemError:
      return 'Le store est indisponible pour le moment. Réessayez dans un instant.';
    default:
      return serverMessage ?? _defaultServerMessage;
  }
}
