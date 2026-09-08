import 'package:nanimo/core/analytics/analytics_service.dart';

/// Assigned once in main, mirroring `errorReporter`. Stays inert in tests and
/// debug builds, which keeps cubits free of an extra constructor argument.
AnalyticsService analytics = const NoopAnalyticsService();
