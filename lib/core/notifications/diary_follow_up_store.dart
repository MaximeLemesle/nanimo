import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Which part of the health diary the owner put off (NAN-116).
enum DiaryFollowUpTopic { vaccines, vetVisits }

/// « Me le rappeler plus tard »: a one-off reminder at the time the owner chose.
class DiaryFollowUp {
  final String petId;
  final DiaryFollowUpTopic topic;
  final DateTime at;

  const DiaryFollowUp({required this.petId, required this.topic, required this.at});

  Map<String, dynamic> toJson() => {'pet': petId, 'topic': topic.name, 'at': at.toIso8601String()};

  static DiaryFollowUp? fromJson(Map<String, dynamic> json) {
    final topic = DiaryFollowUpTopic.values.where((t) => t.name == json['topic']).firstOrNull;
    final at = DateTime.tryParse(json['at'] as String? ?? '');
    final petId = json['pet'] as String?;
    if (topic == null || at == null || petId == null) return null;
    return DiaryFollowUp(petId: petId, topic: topic, at: at);
  }
}

/// Kept on the phone: the reminder is local, so is what it remembers.
class DiaryFollowUpStore {
  static const _key = 'diary_follow_ups';

  final Future<SharedPreferences> Function() _prefs;
  final StreamController<List<DiaryFollowUp>> _changes = StreamController.broadcast();

  DiaryFollowUpStore({Future<SharedPreferences> Function()? prefs}) : _prefs = prefs ?? SharedPreferences.getInstance;

  Stream<List<DiaryFollowUp>> watch() async* {
    yield await all();
    yield* _changes.stream;
  }

  Future<List<DiaryFollowUp>> all() async {
    final raw = (await _prefs()).getStringList(_key) ?? const [];
    return [
      for (final entry in raw)
        if (DiaryFollowUp.fromJson(jsonDecode(entry) as Map<String, dynamic>) case final followUp?) followUp,
    ];
  }

  /// Replaces any earlier follow-up on the same topic of the same pet.
  Future<void> add(DiaryFollowUp followUp) async {
    final kept = (await all()).where((f) => f.petId != followUp.petId || f.topic != followUp.topic);
    await _save([...kept, followUp]);
  }

  Future<void> _save(List<DiaryFollowUp> followUps) async {
    await (await _prefs()).setStringList(_key, [for (final f in followUps) jsonEncode(f.toJson())]);
    _changes.add(followUps);
  }
}

/// Assigned in main.
DiaryFollowUpStore diaryFollowUpStore = DiaryFollowUpStore();
