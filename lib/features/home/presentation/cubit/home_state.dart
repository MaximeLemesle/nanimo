part of 'home_cubit.dart';

enum HomeStatus { loading, loaded }

/// A vaccine needing attention, resolved to its pet.
typedef VaccineAlert = ({
  HealthDiaryVaccineModel vaccine,
  PetModel? pet,
  VaccineStatus status,
});

class HomeState extends Equatable {
  final HomeStatus status;
  final List<PetModel> pets;
  final Map<String, String> iconsKey;
  final List<PetIconModel> icons;
  final String? userName;
  final List<EventModel> events;
  final Map<String, List<String>> petIdsByEvent;
  final Map<String, List<String>> imagePathsByEvent;
  final List<HealthDiaryModel> diaries;
  final List<HealthDiaryVaccineModel> vaccines;

  const HomeState({
    this.status = HomeStatus.loading,
    this.pets = const [],
    this.iconsKey = const {},
    this.icons = const [],
    this.userName,
    this.events = const [],
    this.petIdsByEvent = const {},
    this.imagePathsByEvent = const {},
    this.diaries = const [],
    this.vaccines = const [],
  });

  /// Events whose entry date falls within the last 7 days.
  List<EventModel> weekEvents({DateTime? now}) {
    final reference = now ?? DateTime.now();
    final weekAgo = reference.subtract(const Duration(days: 7));
    return events.where((event) {
      final date = event.entryDate?.toLocal();
      if (date == null) return false;
      return date.isAfter(weekAgo) && !date.isAfter(reference);
    }).toList();
  }

  /// Weekdays (DateTime.monday..sunday) covered by [weekEvents].
  Set<int> weekActiveDays({DateTime? now}) {
    return {
      for (final event in weekEvents(now: now)) event.entryDate!.toLocal().weekday,
    };
  }

  /// Most recent event that happened on today's day and month, a year or
  /// more ago.
  EventModel? anniversaryEvent({DateTime? now}) {
    final reference = now ?? DateTime.now();
    EventModel? best;
    for (final event in events) {
      final date = event.entryDate?.toLocal();
      if (date == null) continue;
      if (date.day != reference.day || date.month != reference.month) continue;
      if (date.year >= reference.year) continue;
      if (best == null || date.year > best.entryDate!.toLocal().year) {
        best = event;
      }
    }
    return best;
  }

  /// Full years between [event] and today.
  int yearsAgo(EventModel event, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    return reference.year - event.entryDate!.toLocal().year;
  }

  /// Latest event, used as fallback when no anniversary memory exists.
  EventModel? get latestEvent => events.isEmpty ? null : events.first;

  Map<String, String> get _petIdByDiaryId =>
      {for (final diary in diaries) diary.healthDiaryId: diary.petId};

  PetModel? _petById(String? petId) {
    if (petId == null) return null;
    for (final pet in pets) {
      if (pet.petId == petId) return pet;
    }
    return null;
  }

  /// Vaccines overdue or due within 30 days, most urgent first.
  /// Vaccines whose diary resolves to no pet of the account are dropped: they
  /// belong to another user and would render an alert without any icon.
  List<VaccineAlert> vaccineAlerts({DateTime? now}) {
    final petIdByDiary = _petIdByDiaryId;
    final alerts = <VaccineAlert>[
      for (final vaccine in vaccines)
        if (vaccineStatusFor(vaccine.nextDate, now: now) != VaccineStatus.done)
          if (_petById(petIdByDiary[vaccine.healthDiaryId]) case final pet?)
            (
              vaccine: vaccine,
              pet: pet,
              status: vaccineStatusFor(vaccine.nextDate, now: now),
            ),
    ];
    alerts.sort((a, b) => a.vaccine.nextDate.compareTo(b.vaccine.nextDate));
    return alerts;
  }

  /// Worst vaccine status per pet id (overdue > soon > done).
  Map<String, VaccineStatus> vaccineStatusByPet({DateTime? now}) {
    final petIdByDiary = _petIdByDiaryId;
    final result = {for (final pet in pets) pet.petId: VaccineStatus.done};
    for (final vaccine in vaccines) {
      final petId = petIdByDiary[vaccine.healthDiaryId];
      if (petId == null || !result.containsKey(petId)) continue;
      final status = vaccineStatusFor(vaccine.nextDate, now: now);
      if (status.index > result[petId]!.index) result[petId] = status;
    }
    return result;
  }
  /// What each pet looks like: its chosen catalogue icon, else its species one.
  Map<String, PetPortrait> get portraits => PetIconResolver.portraitsByPet(
        pets: pets,
        icons: icons,
        speciesIconKeys: iconsKey,
      );


  HomeState copyWith({
    HomeStatus? status,
    List<PetModel>? pets,
    Map<String, String>? iconsKey,
    List<PetIconModel>? icons,
    String? userName,
    List<EventModel>? events,
    Map<String, List<String>>? petIdsByEvent,
    Map<String, List<String>>? imagePathsByEvent,
    List<HealthDiaryModel>? diaries,
    List<HealthDiaryVaccineModel>? vaccines,
  }) {
    return HomeState(
      status: status ?? this.status,
      pets: pets ?? this.pets,
      iconsKey: iconsKey ?? this.iconsKey,
      icons: icons ?? this.icons,
      userName: userName ?? this.userName,
      events: events ?? this.events,
      petIdsByEvent: petIdsByEvent ?? this.petIdsByEvent,
      imagePathsByEvent: imagePathsByEvent ?? this.imagePathsByEvent,
      diaries: diaries ?? this.diaries,
      vaccines: vaccines ?? this.vaccines,
    );
  }

  @override
  List<Object?> get props => [
        status,
        pets,
        iconsKey,
        icons,
        userName,
        events,
        petIdsByEvent,
        imagePathsByEvent,
        diaries,
        vaccines,
      ];
}
