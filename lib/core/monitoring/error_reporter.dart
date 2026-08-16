import 'package:nanimo/core/monitoring/monitoring_service.dart';

/// Assigned once in main. Stays inert in tests and debug builds, which keeps
/// the reporter reachable from the repository layer without threading it
/// through every constructor.
MonitoringService errorReporter = const NoopMonitoringService();
