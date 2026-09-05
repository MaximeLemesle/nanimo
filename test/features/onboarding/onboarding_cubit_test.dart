import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:nanimo/data/models/referential/pet_icon_model.dart';
import 'package:nanimo/data/models/referential/pet_race_model.dart';
import 'package:nanimo/data/models/referential/pet_species_model.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';

class _MockReferentialRepository extends Mock
    implements ReferentialRepository {}

const _species = PetSpeciesModel(
  petSpeciesId: 's1',
  speciesName: 'Chat',
  weightUnit: WeightUnit.kg,
  iconKey: 'cat-europeen',
);

const _races = [
  PetRaceModel(petRaceId: 'r1', raceName: 'Bengal', petSpeciesId: 's1'),
];

const _icons = [
  PetIconModel(
    petIconId: 'i1',
    petIconName: 'Bengal',
    assetPath: 'assets/icons/species/cat-bengal.png',
    isPremium: false,
    petSpeciesId: 's1',
    petRaceId: 'r1',
  ),
];

void main() {
  late _MockReferentialRepository referentialRepo;

  setUp(() {
    referentialRepo = _MockReferentialRepository();

    when(() => referentialRepo.fetchSpecies())
        .thenAnswer((_) async => [_species]);
    when(() => referentialRepo.fetchRacesBySpecies(any()))
        .thenAnswer((_) async => _races);
    when(() => referentialRepo.fetchIcons()).thenAnswer((_) async => _icons);
  });

  OnboardingCubit createCubit() => OnboardingCubit(
        referentialRepository: referentialRepo,
      );

  Future<void> seedCompleteDraft(OnboardingCubit cubit) async {
    cubit.setPetName('Milo');
    await cubit.selectSpecies('s1');
    cubit.setRace('r1');
    cubit.setGender(Gender.female);
    cubit.setBirthdate(DateTime.utc(2022, 6, 15));
  }

  group('portrait', () {
    test('gives the icon of the picked breed', () async {
      final cubit = createCubit();
      await cubit.fetchSpecies();
      await seedCompleteDraft(cubit);

      expect(
        cubit.state.portrait,
        const PetPortrait(
          iconKey: 'cat-europeen',
          assetPath: 'assets/icons/species/cat-bengal.png',
        ),
      );
    });

    test('falls back to the species icon before a breed is picked', () async {
      final cubit = createCubit();
      await cubit.fetchSpecies();
      await cubit.selectSpecies('s1');

      expect(cubit.state.portrait, const PetPortrait.species('cat-europeen'));
    });

    test('stamps the id of the icon it resolved', () async {
      final cubit = createCubit();
      await cubit.fetchSpecies();
      await seedCompleteDraft(cubit);

      expect(cubit.state.petIconId, 'i1');
    });

    /// No catalogue means no id to stamp, and a pet created offline must not
    /// point at a row that does not exist.
    test('stamps nothing when the catalogue failed to load', () async {
      when(() => referentialRepo.fetchIcons()).thenThrow(Exception('boom'));
      final cubit = createCubit();
      await cubit.fetchSpecies();
      await seedCompleteDraft(cubit);

      expect(cubit.state.petIconId, isNull);
    });

    test('is null while no species is picked', () async {
      final cubit = createCubit();
      await cubit.fetchSpecies();

      expect(cubit.state.portrait, isNull);
    });

    /// Icons are cosmetic: losing them must still leave a species avatar.
    test('keeps the species icon when the catalogue fails to load', () async {
      when(() => referentialRepo.fetchIcons()).thenThrow(Exception('boom'));
      final cubit = createCubit();
      await cubit.fetchSpecies();
      await seedCompleteDraft(cubit);

      expect(cubit.state.portrait, const PetPortrait.species('cat-europeen'));
    });
  });

  group('fetchSpecies', () {
    test('emits loading then loaded on success', () async {
      final cubit = createCubit();
      final statuses = <ReferentialStatus>[];
      final sub = cubit.stream.listen((s) => statuses.add(s.speciesStatus));

      await cubit.fetchSpecies();
      await Future<void>.delayed(Duration.zero);

      expect(
        statuses,
        containsAllInOrder([
          ReferentialStatus.loading,
          ReferentialStatus.loaded,
        ]),
      );
      expect(cubit.state.species, hasLength(1));
      await sub.cancel();
      await cubit.close();
    });

    test('emits error on repository throw', () async {
      when(() => referentialRepo.fetchSpecies()).thenThrow(Exception('boom'));

      final cubit = createCubit();
      await cubit.fetchSpecies();

      expect(cubit.state.speciesStatus, ReferentialStatus.error);
      expect(cubit.state.speciesError, isNotNull);
      await cubit.close();
    });

    test('is a no-op when already loaded', () async {
      final cubit = createCubit();
      await cubit.fetchSpecies();
      await cubit.fetchSpecies();

      verify(() => referentialRepo.fetchSpecies()).called(1);
      await cubit.close();
    });
  });

  group('selectSpecies', () {
    test('triggers race fetch for the selected species', () async {
      final cubit = createCubit();
      await cubit.selectSpecies('s1');

      expect(cubit.state.petSpeciesId, 's1');
      expect(cubit.state.races, hasLength(1));
      await cubit.close();
    });

    test('clears previously selected race when species changes', () async {
      final cubit = createCubit();
      await cubit.selectSpecies('s1');
      cubit.setRace('r1');

      await cubit.selectSpecies('s2');

      expect(cubit.state.petRaceId, isNull);
      await cubit.close();
    });

    test('is a no-op when reselecting the same species', () async {
      final cubit = createCubit();
      await cubit.selectSpecies('s1');
      await cubit.selectSpecies('s1');

      verify(() => referentialRepo.fetchRacesBySpecies('s1')).called(1);
      await cubit.close();
    });
  });

  group('stepping', () {
    test('nextStep stays at 1 until canGoToStep2 is satisfied', () async {
      final cubit = createCubit();
      cubit.nextStep();
      expect(cubit.state.currentStep, 1);

      cubit.setPetName('Milo');
      cubit.nextStep();
      expect(cubit.state.currentStep, 1,
          reason: 'still missing species selection');

      await cubit.selectSpecies('s1');
      cubit.nextStep();
      expect(cubit.state.currentStep, 2);
      await cubit.close();
    });

    test('nextStep advances to step 3 once gender/race/birthdate are set',
        () async {
      final cubit = createCubit();
      cubit.setPetName('Milo');
      await cubit.selectSpecies('s1');
      cubit.nextStep();

      cubit.setRace('r1');
      cubit.setGender(Gender.male);
      cubit.setBirthdate(DateTime.utc(2022, 1, 1));
      cubit.nextStep();

      expect(cubit.state.currentStep, 3);
      await cubit.close();
    });

    test('previousStep decrements but stops at one', () async {
      final cubit = createCubit();
      await seedCompleteDraft(cubit);
      cubit.nextStep();
      cubit.nextStep();
      cubit.previousStep();
      cubit.previousStep();
      cubit.previousStep();
      expect(cubit.state.currentStep, 1);
      await cubit.close();
    });
  });

  group('reset', () {
    test('returns to a fresh state', () async {
      final cubit = createCubit();
      await seedCompleteDraft(cubit);
      cubit.reset();

      expect(cubit.state, const OnboardingState());
      await cubit.close();
    });
  });
}
