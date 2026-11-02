import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/monitoring/monitoring_service.dart';
import 'package:nanimo/features/auth/presentation/auth_identity_sync.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';

import '../../../core/analytics/recording_analytics_service.dart';

class _RecordingMonitoringService extends NoopMonitoringService {
  final List<String> identified = [];
  int forgetCount = 0;

  @override
  Future<void> identifyUser(String userId) async => identified.add(userId);

  @override
  Future<void> forgetUser() async => forgetCount++;
}

void main() {
  late RecordingAnalyticsService analytics;
  late _RecordingMonitoringService monitoring;
  String? userId;

  setUp(() {
    analytics = RecordingAnalyticsService();
    monitoring = _RecordingMonitoringService();
    userId = null;
  });

  AuthIdentitySync createSync() => AuthIdentitySync(
        analytics: analytics,
        monitoring: monitoring,
        currentUserId: () => userId,
      );

  /// NAN-132: a reset here gave the install and the onboarding two persons.
  test('a first launch without an account keeps the anonymous identity', () {
    final sync = createSync();

    sync.onAuthChanged(const AuthState.unknown());
    sync.onAuthChanged(const AuthState.unauthenticated());

    expect(analytics.forgetCount, 0);
    expect(monitoring.forgetCount, 0);
  });

  test('a failed sign-in attempt keeps the anonymous identity', () {
    final sync = createSync();

    sync.onAuthChanged(const AuthState.unauthenticated());
    sync.onAuthChanged(const AuthState.unauthenticated().copyWith(isSubmitting: true));
    sync.onAuthChanged(const AuthState.unauthenticated().copyWith(errorMessage: 'Identifiants invalides'));

    expect(analytics.forgetCount, 0);
    expect(monitoring.forgetCount, 0);
  });

  test('signing in identifies the account', () {
    final sync = createSync();
    sync.onAuthChanged(const AuthState.unauthenticated());

    userId = 'user-1';
    sync.onAuthChanged(const AuthState.authenticated());

    expect(analytics.identified, ['user-1']);
    expect(monitoring.identified, ['user-1']);
  });

  test('signing out resets once, so the next person starts fresh', () {
    final sync = createSync();
    userId = 'user-1';
    sync.onAuthChanged(const AuthState.authenticated());

    userId = null;
    sync.onAuthChanged(const AuthState.unauthenticated());
    sync.onAuthChanged(const AuthState.unauthenticated().copyWith(isSubmitting: true));

    expect(analytics.forgetCount, 1);
    expect(monitoring.forgetCount, 1);
  });

  test('a session restored at launch resets on sign-out', () {
    final sync = createSync();
    userId = 'user-1';
    sync.onAuthChanged(const AuthState.unknown());
    sync.onAuthChanged(const AuthState.authenticated());

    userId = null;
    sync.onAuthChanged(const AuthState.unauthenticated());

    expect(analytics.forgetCount, 1);
  });
}
