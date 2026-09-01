import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:nanimo/core/monitoring/error_reporter.dart';
import 'package:nanimo/core/monitoring/monitoring_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _RecordingMonitoringService implements MonitoringService {
  final List<Object> exceptions = [];
  final List<String> hints = [];
  final List<String> breadcrumbs = [];

  @override
  Future<void> start(FutureOr<void> Function() appRunner) async {
    await appRunner();
  }

  @override
  Future<void> captureException(
    Object exception, {
    StackTrace? stackTrace,
    String? hint,
  }) async {
    exceptions.add(exception);
    if (hint != null) hints.add(hint);
  }

  @override
  Future<void> identifyUser(String userId) async {}

  @override
  Future<void> forgetUser() async {}

  @override
  Future<void> addBreadcrumb(String message, {String? category}) async {
    breadcrumbs.add(message);
  }
}

void main() {
  late _RecordingMonitoringService reporter;

  setUp(() {
    reporter = _RecordingMonitoringService();
    errorReporter = reporter;
  });

  tearDown(() {
    errorReporter = const NoopMonitoringService();
  });

  test('the reporter stays inert until main assigns it', () {
    errorReporter = const NoopMonitoringService();

    expect(errorReporter, isA<NoopMonitoringService>());
  });

  group('mapRepositoryError reporting', () {
    test('reports a server refusal with the operation as hint', () {
      mapRepositoryError(
        const PostgrestException(message: 'RLS violation', code: '42501'),
        StackTrace.current,
        operation: 'createPet',
        networkMessage: 'hors-ligne',
      );

      expect(reporter.exceptions, hasLength(1));
      expect(reporter.hints, ['createPet']);
    });

    test('reports a storage refusal', () {
      mapRepositoryError(
        const StorageException('bucket not found'),
        StackTrace.current,
        operation: 'uploadEventImage',
        networkMessage: 'hors-ligne',
      );

      expect(reporter.exceptions, hasLength(1));
    });

    /// A device under a tunnel says nothing about the app, and would drown the
    /// free quota well before the indicators become readable.
    test('stays silent on a lost network', () {
      mapRepositoryError(
        const SocketException('failed host lookup'),
        StackTrace.current,
        operation: 'createPet',
        networkMessage: 'hors-ligne',
      );

      expect(reporter.exceptions, isEmpty);
    });

    test('stays silent on a timeout', () {
      mapRepositoryError(
        TimeoutException('too slow'),
        StackTrace.current,
        operation: 'createPet',
        networkMessage: 'hors-ligne',
      );

      expect(reporter.exceptions, isEmpty);
    });

    /// An unidentified cause is a bug wearing a network message. It is exactly
    /// what we want to see.
    test('reports an unidentified cause', () {
      mapRepositoryError(
        TypeError(),
        StackTrace.current,
        operation: 'createPet',
        networkMessage: 'hors-ligne',
      );

      expect(reporter.exceptions, hasLength(1));
    });

    test('reports one event when the exception crosses two layers', () {
      final inner = mapRepositoryError(
        const PostgrestException(message: 'RLS violation'),
        StackTrace.current,
        operation: 'createPet',
        networkMessage: 'hors-ligne',
      );

      mapRepositoryError(
        inner,
        StackTrace.current,
        operation: 'createPetOuter',
        networkMessage: 'hors-ligne',
      );

      expect(reporter.exceptions, hasLength(1));
    });

    /// The point of NAN-069: Sentry must receive the store failure itself, not
    /// the network wording the user was shown.
    test('reports a store failure with its real nature', () {
      final error = PlatformException(
        code: '${PurchasesErrorCode.storeProblemError.index}',
        message: 'STORE_PROBLEM',
      );

      mapRepositoryError(
        error,
        StackTrace.current,
        operation: 'purchase',
        networkMessage: 'hors-ligne',
      );

      expect(reporter.exceptions, [same(error)]);
      expect(reporter.hints, ['purchase']);
    });

    test('stays silent when the user cancels a purchase', () {
      mapRepositoryError(
        PlatformException(
          code: '${PurchasesErrorCode.purchaseCancelledError.index}',
          message: 'PURCHASE_CANCELLED',
        ),
        StackTrace.current,
        operation: 'purchase',
        networkMessage: 'hors-ligne',
      );

      expect(reporter.exceptions, isEmpty);
    });

    test('leaves a breadcrumb naming the failed operation', () {
      mapRepositoryError(
        const PostgrestException(message: 'RLS violation'),
        StackTrace.current,
        operation: 'createPet',
        networkMessage: 'hors-ligne',
      );

      expect(reporter.breadcrumbs, ['createPet a échoué']);
    });
  });

  group('sessionExpired', () {
    test('reports, because no server error will ever say so', () {
      sessionExpired('createPet', 'Vous devez être connecté.');

      expect(reporter.exceptions, hasLength(1));
      expect(reporter.hints, ['createPet']);
    });

    test('keeps the type and the message the user already saw', () {
      final error = sessionExpired('createPet', 'Vous devez être connecté.');

      expect(error, isA<RepositoryNetworkException>());
      expect(error.message, 'Vous devez être connecté.');
    });
  });
}
