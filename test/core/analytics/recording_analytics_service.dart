import 'package:nanimo/core/analytics/analytics_service.dart';

class CapturedEvent {
  final String name;
  final Map<String, Object> properties;

  const CapturedEvent(this.name, this.properties);

  @override
  String toString() => '$name $properties';
}

/// Swapped into the global `analytics` so a cubit can be tested without
/// threading the service through its constructor.
class RecordingAnalyticsService implements AnalyticsService {
  final List<CapturedEvent> events = [];
  final List<String> screens = [];
  final List<String> identified = [];
  int forgetCount = 0;
  bool? lastEnabled;

  List<String> get names => events.map((e) => e.name).toList();

  CapturedEvent? lastOf(String name) {
    for (final event in events.reversed) {
      if (event.name == name) return event;
    }
    return null;
  }

  @override
  Future<void> capture(String event, {Map<String, Object>? properties}) async {
    events.add(CapturedEvent(event, properties ?? const {}));
  }

  @override
  Future<void> screen(String name) async => screens.add(name);

  @override
  Future<void> identifyUser(
    String userId, {
    Map<String, Object>? properties,
  }) async =>
      identified.add(userId);

  @override
  Future<void> forgetUser() async => forgetCount++;

  @override
  Future<void> setEnabled(bool enabled) async => lastEnabled = enabled;
}
