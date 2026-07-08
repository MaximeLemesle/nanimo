part of 'journal_cubit.dart';

enum JournalStatus { loading, loaded, error }

enum JournalViewMode { timeline, calendar }

class JournalState extends Equatable {
  final JournalStatus status;
  final JournalViewMode viewMode;
  final List<EventModel> events;
  final List<PetModel> pets;
  final List<EventTypeModel> types;
  final Map<String, List<String>> petIdsByEvent;
  final Map<String, List<String>> imagePathsByEvent;
  final Map<String, String> iconsKey;
  final Set<String> selectedPetIds;
  final Set<String> selectedTypeIds;
  final DateTime? selectedCalendarDay;
  final String? error;

  const JournalState({
    this.status = JournalStatus.loading,
    this.viewMode = JournalViewMode.timeline,
    this.events = const [],
    this.pets = const [],
    this.types = const [],
    this.petIdsByEvent = const {},
    this.imagePathsByEvent = const {},
    this.iconsKey = const {},
    this.selectedPetIds = const {},
    this.selectedTypeIds = const {},
    this.selectedCalendarDay,
    this.error,
  });

  bool get hasActiveFilters =>
      selectedPetIds.isNotEmpty || selectedTypeIds.isNotEmpty;

  int get activeFilterCount => selectedPetIds.length + selectedTypeIds.length;

  List<EventModel> get filteredEvents {
    return events.where((event) {
      if (selectedTypeIds.isNotEmpty &&
          !selectedTypeIds.contains(event.eventTypeId)) {
        return false;
      }
      if (selectedPetIds.isNotEmpty) {
        final petIds = petIdsByEvent[event.eventId] ?? const [];
        if (!petIds.any(selectedPetIds.contains)) return false;
      }
      return true;
    }).toList();
  }

  Map<DateTime, List<EventModel>> get calendarEventsByDay {
    final map = <DateTime, List<EventModel>>{};
    for (final event in filteredEvents) {
      final entryDate = event.entryDate;
      if (entryDate == null) continue;

      final day = calendarDayKey(entryDate);
      map.putIfAbsent(day, () => []).add(event);
    }
    return map;
  }

  List<DateTime> get calendarMonths {
    final months = {
      for (final day in calendarEventsByDay.keys) DateTime(day.year, day.month),
    }.toList()
      ..sort((a, b) => b.compareTo(a));
    return months;
  }

  /// Returns the oldest month
  DateTime? get firstCalendarEventMonth {
    DateTime? firstMonth;
    for (final day in calendarEventsByDay.keys) {
      final month = DateTime(day.year, day.month);
      if (firstMonth == null || month.isBefore(firstMonth)) {
        firstMonth = month;
      }
    }
    return firstMonth;
  }

  List<EventModel> eventsForCalendarDay(DateTime day) {
    return calendarEventsByDay[calendarDayKey(day)] ?? const [];
  }

  bool hasEventsOnCalendarDay(DateTime day) {
    return calendarEventsByDay.containsKey(calendarDayKey(day));
  }

  bool isSelectedCalendarDay(DateTime day) {
    final selected = selectedCalendarDay;
    return selected != null && calendarDayKey(selected) == calendarDayKey(day);
  }

  static DateTime calendarDayKey(DateTime value) {
    final local = value.toLocal();
    return DateTime(local.year, local.month, local.day);
  }

  JournalState copyWith({
    JournalStatus? status,
    JournalViewMode? viewMode,
    List<EventModel>? events,
    List<PetModel>? pets,
    List<EventTypeModel>? types,
    Map<String, List<String>>? petIdsByEvent,
    Map<String, List<String>>? imagePathsByEvent,
    Map<String, String>? iconsKey,
    Set<String>? selectedPetIds,
    Set<String>? selectedTypeIds,
    DateTime? selectedCalendarDay,
    bool clearSelectedCalendarDay = false,
    String? error,
  }) {
    return JournalState(
      status: status ?? this.status,
      viewMode: viewMode ?? this.viewMode,
      events: events ?? this.events,
      pets: pets ?? this.pets,
      types: types ?? this.types,
      petIdsByEvent: petIdsByEvent ?? this.petIdsByEvent,
      imagePathsByEvent: imagePathsByEvent ?? this.imagePathsByEvent,
      iconsKey: iconsKey ?? this.iconsKey,
      selectedPetIds: selectedPetIds ?? this.selectedPetIds,
      selectedTypeIds: selectedTypeIds ?? this.selectedTypeIds,
      selectedCalendarDay: clearSelectedCalendarDay
          ? null
          : selectedCalendarDay ?? this.selectedCalendarDay,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        status,
        viewMode,
        events,
        pets,
        types,
        petIdsByEvent,
        imagePathsByEvent,
        iconsKey,
        selectedPetIds,
        selectedTypeIds,
        selectedCalendarDay,
        error,
      ];
}
