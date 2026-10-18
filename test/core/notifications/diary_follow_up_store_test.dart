import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nanimo/core/notifications/diary_follow_up_store.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('keeps a follow-up across instances, one per pet and topic', () async {
    final store = DiaryFollowUpStore();
    await store.add(DiaryFollowUp(petId: 'p1', topic: DiaryFollowUpTopic.vaccines, at: DateTime(2026, 10, 20, 18)));
    await store.add(DiaryFollowUp(petId: 'p1', topic: DiaryFollowUpTopic.vaccines, at: DateTime(2026, 10, 21, 9)));
    await store.add(DiaryFollowUp(petId: 'p1', topic: DiaryFollowUpTopic.vetVisits, at: DateTime(2026, 10, 22, 9)));

    final reloaded = await DiaryFollowUpStore().all();

    expect(reloaded.map((f) => (f.topic, f.at)), [
      (DiaryFollowUpTopic.vaccines, DateTime(2026, 10, 21, 9)),
      (DiaryFollowUpTopic.vetVisits, DateTime(2026, 10, 22, 9)),
    ]);
  });

  test('announces every change to its watchers', () async {
    final store = DiaryFollowUpStore();
    final seen = <int>[];
    final subscription = store.watch().listen((list) => seen.add(list.length));
    await pumpEventQueue();

    await store.add(DiaryFollowUp(petId: 'p1', topic: DiaryFollowUpTopic.vaccines, at: DateTime(2026, 10, 20)));
    await pumpEventQueue();

    expect(seen, [0, 1]);
    await subscription.cancel();
  });
}
