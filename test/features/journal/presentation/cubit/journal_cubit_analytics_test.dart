import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/analytics/analytics.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';
import 'package:nanimo/core/analytics/analytics_service.dart';
import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/event/data/event_repository.dart';
import 'package:nanimo/features/journal/presentation/cubit/journal_cubit.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';

import '../../../../core/analytics/recording_analytics_service.dart';

class _MockEventRepository extends Mock implements EventRepository {}

class _MockPetRepository extends Mock implements PetRepository {}

class _MockReferentialRepository extends Mock implements ReferentialRepository {}

void main() {
  late _MockEventRepository eventRepo;
  late RecordingAnalyticsService recorder;
  late JournalCubit cubit;

  setUp(() async {
    eventRepo = _MockEventRepository();
    final petRepo = _MockPetRepository();
    final refRepo = _MockReferentialRepository();
    recorder = RecordingAnalyticsService();
    analytics = recorder;

    when(() => eventRepo.watchEvents()).thenAnswer((_) => Stream.value(const []));
    when(() => eventRepo.watchPetEvents()).thenAnswer((_) => Stream.value(const {}));
    when(() => eventRepo.watchAllImages()).thenAnswer((_) => Stream.value(const {}));
    when(() => petRepo.getPets()).thenAnswer((_) async => []);
    when(() => refRepo.fetchEventTypes()).thenAnswer((_) async => []);
    when(() => refRepo.fetchSpecies()).thenAnswer((_) async => []);

    cubit = JournalCubit(
      eventRepository: eventRepo,
      petRepository: petRepo,
      referentialRepository: refRepo,
    );
    await Future<void>.delayed(const Duration(milliseconds: 20));
  });

  tearDown(() async {
    analytics = const NoopAnalyticsService();
    await cubit.close();
  });

  test('a view switch is tracked once, re-selecting the same view is not', () {
    cubit.setViewMode(JournalViewMode.calendar);
    cubit.setViewMode(JournalViewMode.calendar);

    expect(recorder.names, [AnalyticsEvents.journalViewSwitched]);
    expect(
      recorder.lastOf(AnalyticsEvents.journalViewSwitched)!.properties[AnalyticsProperties.viewMode],
      'calendar',
    );
  });

  test('adding a filter is tracked, removing it is not', () {
    cubit.togglePetFilter('p1');
    cubit.togglePetFilter('p1');
    cubit.toggleTypeFilter('t1');

    expect(
      recorder.events.map((e) => e.properties[AnalyticsProperties.filter]),
      ['pet', 'type'],
    );
  });

  test('a deleted memory is tracked only when the server agreed', () async {
    when(() => eventRepo.deleteEvent('e1')).thenAnswer((_) async {});
    when(() => eventRepo.deleteEvent('e2'))
        .thenThrow(const RepositoryNetworkException('offline'));

    await cubit.deleteEvent('e1');
    await cubit.deleteEvent('e2');

    expect(recorder.names, [AnalyticsEvents.memoryDeleted]);
  });
}
