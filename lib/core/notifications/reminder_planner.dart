import 'package:nanimo/features/health/data/models/health_diary_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/settings/data/models/notification_prefs_model.dart';

enum ReminderKind { vaccine, vetVisit, birthday, adoption }

/// One local notification to schedule. [key] is stable across runs, so the
/// same reminder always gets the same platform id.
class PlannedReminder {
  final String key;
  final ReminderKind kind;
  final DateTime when;
  final String title;
  final String body;
  final String petId;

  const PlannedReminder({
    required this.key,
    required this.kind,
    required this.when,
    required this.title,
    required this.body,
    required this.petId,
  });

  int get id => notificationIdFor(key);

  /// What a tap carries back: the kind, then the animal.
  String get payload => '${kind.name}|$petId';

  @override
  String toString() => '$key @ $when';
}

/// FNV-1a folded to 31 bits: platform ids are signed 32-bit ints.
int notificationIdFor(String key) {
  var hash = 0x811c9dc5;
  for (final unit in key.codeUnits) {
    hash ^= unit;
    hash = (hash * 0x01000193) & 0xffffffff;
  }
  return hash & 0x7fffffff;
}

({ReminderKind kind, String petId})? parseReminderPayload(String? payload) {
  if (payload == null) return null;
  final parts = payload.split('|');
  if (parts.length != 2 || parts[1].isEmpty) return null;
  for (final kind in ReminderKind.values) {
    if (kind.name == parts[0]) return (kind: kind, petId: parts[1]);
  }
  return null;
}

/// Pure: what should be scheduled for this data at [now] (NAN-106).
abstract final class ReminderPlanner {
  /// iOS keeps at most 64 pending notifications; the nearest ones win.
  static const maxPending = 60;
  static const hour = 10;
  static const vaccineLeadDays = [7, 1];
  static const vetVisitLeadDays = [1];

  static List<PlannedReminder> plan({
    required List<PetModel> pets,
    required List<HealthDiaryModel> diaries,
    required List<HealthDiaryVaccineModel> vaccines,
    required List<VetVisitModel> vetVisits,
    required NotificationPrefsModel prefs,
    required DateTime now,
  }) {
    if (!prefs.pushEnabled) return const [];
    final petsById = {for (final pet in pets) pet.petId: pet};
    final petIdByDiary = {for (final diary in diaries) diary.healthDiaryId: diary.petId};
    final planned = <PlannedReminder>[];

    if (prefs.vaccineReminders) {
      for (final vaccine in vaccines) {
        final due = vaccine.nextDate;
        final pet = petsById[petIdByDiary[vaccine.healthDiaryId]];
        if (due == null || pet == null) continue;
        for (final lead in vaccineLeadDays) {
          planned.add(PlannedReminder(
            key: 'vaccine:${vaccine.healthDiaryVaccineId}:$lead',
            kind: ReminderKind.vaccine,
            when: _at(due, lead),
            title: 'Rappel de vaccin',
            body: 'Rappel ${vaccine.vaccineName} de ${pet.petName} ${_inDays(lead)}',
            petId: pet.petId,
          ));
        }
      }
    }

    if (prefs.vetReminders) {
      for (final visit in vetVisits) {
        final pet = petsById[visit.petId];
        if (pet == null) continue;
        for (final lead in vetVisitLeadDays) {
          planned.add(PlannedReminder(
            key: 'vet:${visit.vetVisitId}:$lead',
            kind: ReminderKind.vetVisit,
            when: _at(visit.visitedAt, lead),
            title: 'Visite chez le vétérinaire',
            body: '${visit.title} pour ${pet.petName} ${_inDays(lead)}',
            petId: pet.petId,
          ));
        }
      }
    }

    return nearest(planned, now: now);
  }

  /// Drops what is already past and keeps the [maxPending] nearest.
  static List<PlannedReminder> nearest(List<PlannedReminder> planned, {required DateTime now}) {
    final upcoming = planned.where((r) => r.when.isAfter(now)).toList()
      ..sort((a, b) => a.when.compareTo(b.when));
    return upcoming.length > maxPending ? upcoming.sublist(0, maxPending) : upcoming;
  }

  static DateTime _at(DateTime day, int leadDays) =>
      DateTime(day.year, day.month, day.day - leadDays, hour);

  static String _inDays(int lead) => lead == 1 ? 'demain' : 'dans $lead jours';
}
