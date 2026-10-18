part of 'home_cubit.dart';

enum HomeStatus { loading, loaded }

/// A booked vet appointment, resolved to its pet.
typedef UpcomingVetVisit = ({VetVisitModel visit, PetModel pet});

/// The latest past visit or vaccine of a pet, for when nothing is booked.
typedef LastHealthEntry = ({PetModel pet, DateTime at});

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
  final List<VetVisitModel> vetVisits;

  /// Null until the cache holds a published article: the card then falls back
  /// on its embedded tip.
  final ArticleModel? article;

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
    this.article,
    this.vetVisits = const [],
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

  Map<String, String> get _petIdByDiaryId => {for (final diary in diaries) diary.healthDiaryId: diary.petId};

  PetModel? _petById(String? petId) {
    if (petId == null) return null;
    for (final pet in pets) {
      if (pet.petId == petId) return pet;
    }
    return null;
  }

  /// False until a vaccine of one of the account's pets is recorded: an empty
  /// alert list then means "unknown", not "up to date".
  bool get hasAnyVaccine {
    final petIdByDiary = _petIdByDiaryId;
    return vaccines.any((vaccine) => _petById(petIdByDiary[vaccine.healthDiaryId]) != null);
  }

  /// Every booster ahead or overdue, however far (NAN-115): the owner sees
  /// where the pet stands, not only what is urgent. Most urgent first.
  /// Vaccines whose diary resolves to no pet of the account are dropped: they
  /// belong to another user and would render an alert without any icon.
  List<VaccineAlert> vaccineAlerts({DateTime? now}) {
    final petIdByDiary = _petIdByDiaryId;
    final alerts = <VaccineAlert>[
      for (final vaccine in vaccines)
        if (vaccine.nextDate != null)
          if (_petById(petIdByDiary[vaccine.healthDiaryId]) case final pet?)
            (
              vaccine: vaccine,
              pet: pet,
              status: vaccineStatusFor(vaccine.nextDate, now: now),
            ),
    ];
    alerts.sort((a, b) => a.vaccine.nextDate!.compareTo(b.vaccine.nextDate!));
    return alerts;
  }

  /// Appointments still ahead, nearest first. Derived from the date alone,
  /// there is no status column on a vet visit.
  List<UpcomingVetVisit> upcomingVetVisits({DateTime? now}) {
    final reference = now ?? DateTime.now();
    final today = DateTime(reference.year, reference.month, reference.day);
    final upcoming = <UpcomingVetVisit>[
      for (final visit in vetVisits)
        if (!visit.visitedAt.isBefore(today))
          if (_petById(visit.petId) case final pet?) (visit: visit, pet: pet),
    ];
    upcoming.sort((a, b) => a.visit.visitedAt.compareTo(b.visit.visitedAt));
    return upcoming;
  }

  /// Latest visit already past, one per pet, in the order of the pets.
  List<LastHealthEntry> lastVetVisits({DateTime? now}) {
    final reference = now ?? DateTime.now();
    final today = DateTime(reference.year, reference.month, reference.day);
    return _latestPerPet([
      for (final visit in vetVisits)
        if (visit.visitedAt.isBefore(today)) (petId: visit.petId, at: visit.visitedAt),
    ]);
  }

  /// Latest vaccine given, one per pet, in the order of the pets.
  List<LastHealthEntry> lastVaccinations({DateTime? now}) {
    final reference = now ?? DateTime.now();
    final petIdByDiary = _petIdByDiaryId;
    return _latestPerPet([
      for (final vaccine in vaccines)
        if (vaccine.lastDate case final given? when !given.isAfter(reference))
          (petId: petIdByDiary[vaccine.healthDiaryId], at: given),
    ]);
  }

  List<LastHealthEntry> _latestPerPet(List<({String? petId, DateTime at})> entries) {
    final latest = <String, DateTime>{};
    for (final entry in entries) {
      final petId = entry.petId;
      if (petId == null) continue;
      final known = latest[petId];
      if (known == null || entry.at.isAfter(known)) latest[petId] = entry.at;
    }
    return [
      for (final pet in pets)
        if (latest[pet.petId] case final at?) (pet: pet, at: at),
    ];
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
    ArticleModel? article,
    List<VetVisitModel>? vetVisits,
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
      article: article ?? this.article,
      vetVisits: vetVisits ?? this.vetVisits,
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
        article,
        vetVisits,
      ];
}
