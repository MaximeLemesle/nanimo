import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/analytics/analytics.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';
import 'package:nanimo/core/analytics/analytics_service.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_creation_cubit.dart';

import '../../../../core/analytics/recording_analytics_service.dart';

class _MockAuthCubit extends Mock implements AuthCubit {}

class _MockPetRepository extends Mock implements PetRepository {}

void main() {
  late _MockAuthCubit authCubit;
  late _MockPetRepository petRepo;
  late StreamController<AuthState> authStream;
  late RecordingAnalyticsService recorder;

  setUpAll(() {
    registerFallbackValue(PetModel(
      petId: 'p',
      petName: 'p',
      birthdate: DateTime(2020),
      gender: Gender.unknown,
      createdAt: DateTime(2020),
      petRaceId: 'r',
      petSpeciesId: 's',
    ));
  });

  setUp(() {
    authCubit = _MockAuthCubit();
    petRepo = _MockPetRepository();
    authStream = StreamController<AuthState>.broadcast();
    recorder = RecordingAnalyticsService();
    analytics = recorder;
    when(() => authCubit.stream).thenAnswer((_) => authStream.stream);
    when(() => petRepo.createPet(any())).thenAnswer((_) async {});
  });

  tearDown(() {
    analytics = const NoopAnalyticsService();
    return authStream.close();
  });

  void prepare(PetCreationCubit cubit, {String? speciesKey}) => cubit.prepare(
        petName: 'Milo',
        petSpeciesId: 's1',
        petRaceId: 'r1',
        gender: Gender.male,
        birthdate: DateTime.utc(2022, 6, 15),
        speciesKey: speciesKey,
      );

  test('a pet added from the app is tagged add_pet with its species', () async {
    when(() => authCubit.state).thenReturn(const AuthState.authenticated());
    final cubit = PetCreationCubit(authCubit: authCubit, petRepository: petRepo);

    prepare(cubit, speciesKey: 'dog-border_collie');
    await pumpEventQueue();

    expect(recorder.lastOf(AnalyticsEvents.petCreated)!.properties, {
      AnalyticsProperties.source: OnboardingSource.addPet,
      AnalyticsProperties.species: 'dog',
    });
    await cubit.close();
  });

  test('the onboarding pet is tagged onboarding once the account exists', () async {
    when(() => authCubit.state).thenReturn(const AuthState.unauthenticated());
    final cubit = PetCreationCubit(authCubit: authCubit, petRepository: petRepo);

    prepare(cubit);
    authStream.add(const AuthState.authenticated());
    await pumpEventQueue();

    expect(recorder.lastOf(AnalyticsEvents.petCreated)!.properties, {
      AnalyticsProperties.source: OnboardingSource.onboarding,
    });
    await cubit.close();
  });
}
