import 'package:nanimo/core/notifications/diary_follow_up_store.dart';
import 'package:nanimo/features/health/data/models/health_diary_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/settings/data/models/notification_prefs_model.dart';

enum ReminderKind { vaccine, vetVisit, birthday, adoption, trialEnd, diaryFollowUp, deworming }

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

  /// Promised on the trial screen: two days before the first charge.
  static const trialEndLeadDays = 2;
  static const trialPayloadId = 'trial';

  /// Same-day call before the appointment, never before [earliestSameDay].
  static const vetVisitSameDayLead = Duration(hours: 2);
  static const earliestSameDay = 7;

  static List<PlannedReminder> plan({
    required List<PetModel> pets,
    required List<HealthDiaryModel> diaries,
    required List<HealthDiaryVaccineModel> vaccines,
    required List<VetVisitModel> vetVisits,
    required NotificationPrefsModel prefs,
    required DateTime now,
    DateTime? trialEndsAt,
    List<DiaryFollowUp> followUps = const [],
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
            title: '💉 Rappel de vaccin',
            body: 'Rappel ${vaccine.vaccineName} de ${pet.petName} ${_inDays(lead)}',
            petId: pet.petId,
          ));
        }
      }
    }

    if (prefs.vaccineReminders) {
      for (final diary in diaries) {
        final due = diary.nextDeworming;
        final pet = petsById[diary.petId];
        if (due == null || pet == null) continue;
        for (final lead in vaccineLeadDays) {
          planned.add(PlannedReminder(
            key: 'deworming:${pet.petId}:${due.toIso8601String()}:$lead',
            kind: ReminderKind.deworming,
            when: _at(due, lead),
            title: '💊 Rappel de vermifuge',
            body: 'Vermifuge de ${pet.petName} ${_inDays(lead)}',
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
            title: '🩺 Visite chez le vétérinaire',
            body: '${visit.title} pour ${pet.petName} ${_inDays(lead)}',
            petId: pet.petId,
          ));
        }
        planned.add(PlannedReminder(
          key: 'vet:${visit.vetVisitId}:0',
          kind: ReminderKind.vetVisit,
          when: sameDayCall(visit.visitedAt),
          title: '🩺 Visite chez le vétérinaire',
          body: '${visit.title} pour ${pet.petName} ${_todayAt(visit.visitedAt)}',
          petId: pet.petId,
        ));
      }
    }

    if (prefs.anniversaryReminders) {
      for (final pet in pets) {
        final when = nextBirthday(pet.birthdate, now: now);
        final age = when.year - pet.birthdate.year;
        if (age < 1) continue;
        planned.add(PlannedReminder(
          key: 'birthday:${pet.petId}:${when.year}',
          kind: ReminderKind.birthday,
          when: when,
          title: '🎂 Joyeux anniversaire ${pet.petName} !',
          body: '${pet.petName} a $age ${age == 1 ? 'an' : 'ans'} aujourd\'hui. Un souvenir pour marquer le jour ?',
          petId: pet.petId,
        ));
      }
    }

    /// Asked for explicitly: only the master switch can silence it.
    for (final followUp in followUps) {
      final pet = petsById[followUp.petId];
      if (pet == null) continue;
      planned.add(PlannedReminder(
        key: 'diary:${pet.petId}:${followUp.topic.name}',
        kind: ReminderKind.diaryFollowUp,
        when: followUp.at,
        title: '✏️ Complète le carnet de ${pet.petName}',
        body: switch (followUp.topic) {
          DiaryFollowUpTopic.vaccines => 'Ses vaccins et vermifuges t\'attendent !',
          DiaryFollowUpTopic.vetVisits => 'Ses visites chez le vétérinaire t\'attendent !',
        },
        petId: pet.petId,
      ));
    }

    if (trialEndsAt != null) {
      final end = trialEndsAt.toLocal();
      planned.add(PlannedReminder(
        key: 'trial:${end.toIso8601String()}',
        kind: ReminderKind.trialEnd,
        when: _at(end, trialEndLeadDays),
        title: '🔔 Ton essai se termine dans 2 jours',
        body: 'Ton essaie de 14 jours se termine le ${_dayMonth(end)}. Tu peux le résilier à tout moment dans les réglages.',
        petId: trialPayloadId,
      ));
    }

    return nearest(planned, now: now);
  }

  static String _dayMonth(DateTime day) => '${day.day.toString().padLeft(2, '0')}/${day.month.toString().padLeft(2, '0')}';

  /// Next anniversary at [hour], today included if the hour is still ahead.
  /// A 29 February falls on the 28th in common years.
  static DateTime nextBirthday(DateTime birthdate, {required DateTime now}) {
    DateTime on(int year) {
      final lastDay = DateTime(year, birthdate.month + 1, 0).day;
      final day = birthdate.day > lastDay ? lastDay : birthdate.day;
      return DateTime(year, birthdate.month, day, hour);
    }

    final thisYear = on(now.year);
    return thisYear.isAfter(now) ? thisYear : on(now.year + 1);
  }

  /// Drops what is already past and keeps the [maxPending] nearest.
  static List<PlannedReminder> nearest(List<PlannedReminder> planned, {required DateTime now}) {
    final upcoming = planned.where((r) => r.when.isAfter(now)).toList()..sort((a, b) => a.when.compareTo(b.when));
    return upcoming.length > maxPending ? upcoming.sublist(0, maxPending) : upcoming;
  }

  /// A visit saved without a time (midnight) is called at 8:00.
  static DateTime sameDayCall(DateTime visit) {
    final local = visit.toLocal();
    if (_hasNoTime(local)) return DateTime(local.year, local.month, local.day, 8);
    final earliest = DateTime(local.year, local.month, local.day, earliestSameDay);
    final call = local.subtract(vetVisitSameDayLead);
    return call.isBefore(earliest) ? earliest : call;
  }

  static bool _hasNoTime(DateTime local) => local.hour == 0 && local.minute == 0;

  static String _todayAt(DateTime visit) {
    final local = visit.toLocal();
    if (_hasNoTime(local)) return "aujourd'hui";
    return "aujourd'hui à ${local.hour}h${local.minute.toString().padLeft(2, '0')}";
  }

  static DateTime _at(DateTime day, int leadDays) => DateTime(day.year, day.month, day.day - leadDays, hour);

  static String _inDays(int lead) => lead == 1 ? 'demain' : 'dans $lead jours';
}
