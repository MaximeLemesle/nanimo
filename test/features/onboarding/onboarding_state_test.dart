import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';

void main() {
  group('OnboardingState', () {
    test('default constructor exposes empty defaults and step 1', () {
      const state = OnboardingState();

      expect(state.currentStep, 1);
      expect(state.petName, '');
      expect(state.petSpeciesId, isNull);
      expect(state.petRaceId, isNull);
      expect(state.gender, isNull);
      expect(state.birthdate, isNull);
      expect(state.speciesStatus, ReferentialStatus.idle);
      expect(state.racesStatus, ReferentialStatus.idle);
    });

    group('canGoToStep2', () {
      test('false when name is shorter than 2 chars', () {
        const state = OnboardingState(petName: 'M', petSpeciesId: 's1');
        expect(state.canGoToStep2, isFalse);
      });

      test('false when speciesId is null', () {
        const state = OnboardingState(petName: 'Milo');
        expect(state.canGoToStep2, isFalse);
      });

      test('true when both name and species are set', () {
        const state = OnboardingState(petName: 'Milo', petSpeciesId: 's1');
        expect(state.canGoToStep2, isTrue);
      });

      test('trims whitespace before validating name length', () {
        const state = OnboardingState(petName: '  M ', petSpeciesId: 's1');
        expect(state.canGoToStep2, isFalse);
      });
    });

    group('canGoToStep3', () {
      test('false when any of gender/race/birthdate is missing', () {
        const a = OnboardingState(gender: Gender.male, petRaceId: 'r1');
        expect(a.canGoToStep3, isFalse);

        final b = OnboardingState(
          gender: Gender.male,
          birthdate: DateTime(2020),
        );
        expect(b.canGoToStep3, isFalse);
      });

      test('true when all three are set', () {
        final state = OnboardingState(
          gender: Gender.female,
          petRaceId: 'r1',
          birthdate: DateTime(2020, 1, 1),
        );
        expect(state.canGoToStep3, isTrue);
      });
    });

    test('canFinish requires a complete draft', () {
      const idle = OnboardingState();
      expect(idle.canFinish, isFalse);

      final complete = OnboardingState(
        petName: 'Milo',
        petSpeciesId: 's1',
        gender: Gender.female,
        petRaceId: 'r1',
        birthdate: DateTime(2020, 1, 1),
      );
      expect(complete.canFinish, isTrue);
    });

    group('copyWith', () {
      test('clearRaceId resets the field even when a new value is passed', () {
        const initial = OnboardingState(petRaceId: 'r1');
        final next = initial.copyWith(petRaceId: 'r2', clearRaceId: true);
        expect(next.petRaceId, isNull);
      });

      test('preserves untouched fields', () {
        final initial = OnboardingState(
          petName: 'Milo',
          petSpeciesId: 's1',
          birthdate: DateTime(2020),
        );
        final next = initial.copyWith(currentStep: 2);
        expect(next.petName, 'Milo');
        expect(next.petSpeciesId, 's1');
        expect(next.birthdate, DateTime(2020));
        expect(next.currentStep, 2);
      });
    });

    test('equality uses value semantics', () {
      const a = OnboardingState(petName: 'Milo', petSpeciesId: 's1');
      const b = OnboardingState(petName: 'Milo', petSpeciesId: 's1');
      expect(a, equals(b));
    });
  });
}
