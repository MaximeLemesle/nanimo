enum VaccineStatus { done, soon, overdue }

/// Resolves the alert status of a vaccine from its next due date. Without one
/// there is nothing to alert on.
VaccineStatus vaccineStatusFor(DateTime? nextDate, {DateTime? now}) {
  if (nextDate == null) return VaccineStatus.done;
  final reference = now ?? DateTime.now();
  final days = nextDate.difference(reference).inDays;
  if (days < 0) return VaccineStatus.overdue;
  if (days <= 30) return VaccineStatus.soon;
  return VaccineStatus.done;
}
