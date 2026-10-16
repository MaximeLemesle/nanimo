import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/analytics/analytics.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';
import 'package:nanimo/core/analytics/analytics_service.dart';
import 'package:nanimo/core/isar/database/sync_service.dart';
import 'package:nanimo/features/auth/data/auth_repository.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../../core/analytics/recording_analytics_service.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockSyncService extends Mock implements SyncService {}

void main() {
  late _MockAuthRepository repository;
  late _MockSyncService syncService;
  late StreamController<supabase.AuthState> authEvents;
  late RecordingAnalyticsService recorder;

  setUp(() {
    repository = _MockAuthRepository();
    syncService = _MockSyncService();
    authEvents = StreamController<supabase.AuthState>();
    recorder = RecordingAnalyticsService();
    analytics = recorder;
    when(() => repository.authStateChanges).thenAnswer((_) => authEvents.stream);
  });

  tearDown(() {
    analytics = const NoopAnalyticsService();
    return authEvents.close();
  });

  AuthCubit createCubit() => AuthCubit(repository: repository, syncService: syncService);

  test('a first Google sign-in counts as an account creation', () async {
    when(() => repository.signInWithGoogle()).thenAnswer((_) async => true);
    final cubit = createCubit();

    await cubit.loginWithGoogle();

    expect(recorder.names, [AnalyticsEvents.accountCreated, AnalyticsEvents.authCompleted]);
    expect(recorder.lastOf(AnalyticsEvents.accountCreated)!.properties[AnalyticsProperties.method], AuthMethod.google);
    await cubit.close();
  });

  test('a returning Apple sign-in is not an account creation', () async {
    when(() => repository.signInWithApple()).thenAnswer((_) async => false);
    final cubit = createCubit();

    await cubit.loginWithApple();

    expect(recorder.names, [AnalyticsEvents.authCompleted]);
    await cubit.close();
  });

  test('a first Apple sign-in counts as an account creation', () async {
    when(() => repository.signInWithApple()).thenAnswer((_) async => true);
    final cubit = createCubit();

    await cubit.loginWithApple();

    expect(recorder.lastOf(AnalyticsEvents.accountCreated)!.properties[AnalyticsProperties.method], AuthMethod.apple);
    await cubit.close();
  });
}
