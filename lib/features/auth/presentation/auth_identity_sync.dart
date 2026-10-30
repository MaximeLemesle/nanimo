import 'package:nanimo/core/analytics/analytics_service.dart';
import 'package:nanimo/core/monitoring/monitoring_service.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';

/// Keeps the PostHog and Sentry identities in step with the auth state.
/// Account id only, never the e-mail.
class AuthIdentitySync {
  final AnalyticsService analytics;
  final MonitoringService monitoring;
  final String? Function() currentUserId;

  AuthIdentitySync({
    required this.analytics,
    required this.monitoring,
    required this.currentUserId,
  });

  bool _identified = false;

  void onAuthChanged(AuthState auth) {
    final userId = currentUserId();
    if (auth.isAuthenticated && userId != null) {
      _identified = true;
      monitoring.identifyUser(userId);
      analytics.identifyUser(userId);
    } else if (auth.isUnauthenticated && _identified) {
      /// Only a real sign-out: a reset before any sign-in splits the
      /// install and the onboarding across two PostHog persons (NAN-132).
      _identified = false;
      monitoring.forgetUser();
      analytics.forgetUser();
    }
  }
}
