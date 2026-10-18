import 'dart:async';

/// The running trial's end as RevenueCat sees it, re-read on demand: after a
/// purchase, and when the app comes back, which is where a cancellation shows.
class TrialEndWatcher {
  final Future<DateTime?> Function() _read;
  final StreamController<DateTime?> _changes = StreamController<DateTime?>.broadcast();
  DateTime? _value;
  bool _loaded = false;

  TrialEndWatcher(this._read);

  DateTime? get value => _value;

  Stream<DateTime?> watch() async* {
    if (!_loaded) await refresh();
    yield _value;
    yield* _changes.stream;
  }

  Future<void> refresh() async {
    final next = await _read();
    final changed = !_loaded || next != _value;
    _value = next;
    _loaded = true;
    if (changed) _changes.add(next);
  }
}

/// Assigned in main; inert in tests, where no store is reachable.
TrialEndWatcher trialEndWatcher = TrialEndWatcher(() async => null);
