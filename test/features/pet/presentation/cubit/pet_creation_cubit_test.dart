import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_creation_cubit.dart';
import 'package:uuid/uuid.dart';

class _MockAuthCubit extends Mock implements AuthCubit {}

class _MockPetRepository extends Mock implements PetRepository {}

class _MockUuid extends Mock implements Uuid {}

PetModel _buildPet() => PetModel(
      petId: 'p',
      petName: 'p',
      birthdate: DateTime(2020),
      gender: Gender.unknown,
      createdAt: DateTime(2020),
      petRaceId: 'r',
      petSpeciesId: 's',
    );

void main() {
  setUpAll(() {
    registerFallbackValue(_buildPet());
  });

  late _MockAuthCubit authCubit;
  late _MockPetRepository petRepo;
  late StreamController<AuthState> authStream;
  late _MockUuid uuid;

  setUp(() {
    authCubit = _MockAuthCubit();
    petRepo = _MockPetRepository();
    authStream = StreamController<AuthState>.broadcast();
    uuid = _MockUuid();

    when(() => authCubit.stream).thenAnswer((_) => authStream.stream);
    when(() => authCubit.state).thenReturn(const AuthState.unauthenticated());
    when(() => uuid.v4()).thenReturn('generated-pet-id');
  });

  tearDown(() {
    authStream.close();
  });

  PetCreationCubit createCubit() => PetCreationCubit(
        authCubit: authCubit,
        petRepository: petRepo,
        uuid: uuid,
      );

  void prepareDraft(PetCreationCubit cubit, {String? petIconId = 'i1'}) {
    cubit.prepare(
      petName: 'Milo',
      petSpeciesId: 's1',
      petRaceId: 'r1',
      gender: Gender.female,
      birthdate: DateTime.utc(2022, 6, 15),
      petIconId: petIconId,
    );
  }

  group('prepare', () {
    /// Written at creation so the row carries its own portrait, instead of it
    /// being re-derived from the breed on every read.
    test('stamps the resolved icon on the pending pet', () {
      final cubit = createCubit();
      prepareDraft(cubit);

      expect(cubit.state.pendingPet!.petIconId, 'i1');
      expect(cubit.state.pendingPet!.toJson()['pet_icon_id'], 'i1');
    });

    test('leaves the icon empty when none was resolved', () {
      final cubit = createCubit();
      prepareDraft(cubit, petIconId: null);

      expect(cubit.state.pendingPet!.petIconId, isNull);
    });

    test('captures the draft as a pending pet built with a fresh uuid', () {
      final cubit = createCubit();
      prepareDraft(cubit);

      final pending = cubit.state.pendingPet;
      expect(pending, isNotNull);
      expect(pending!.petId, 'generated-pet-id');
      expect(pending.petName, 'Milo');
      expect(pending.gender, Gender.female);
      expect(pending.petRaceId, 'r1');
      expect(pending.petSpeciesId, 's1');
      expect(cubit.state.status, PetCreationStatus.idle);
    });

    test('creates immediately when already authenticated (in-app add)',
        () async {
      when(() => authCubit.state)
          .thenReturn(const AuthState.authenticated());
      when(() => petRepo.createPet(any())).thenAnswer((_) async {});

      final cubit = createCubit();
      prepareDraft(cubit);
      await Future<void>.delayed(Duration.zero);

      verify(() => petRepo.createPet(any())).called(1);
      expect(cubit.state.status, PetCreationStatus.success);
      expect(cubit.state.pendingPet, isNull);
      await cubit.close();
    });

    test('keeps waiting for signup when unauthenticated (onboarding)',
        () async {
      final cubit = createCubit();
      prepareDraft(cubit);
      await Future<void>.delayed(Duration.zero);

      verifyNever(() => petRepo.createPet(any()));
      expect(cubit.state.pendingPet, isNotNull);
      await cubit.close();
    });
  });

  group('auth listener', () {
    test('does not fire on unknown → authenticated transition', () async {
      when(() => authCubit.state).thenReturn(const AuthState.unknown());
      final cubit = createCubit();
      prepareDraft(cubit);

      authStream.add(const AuthState.authenticated());
      await Future<void>.delayed(Duration.zero);

      verifyNever(() => petRepo.createPet(any()));
      await cubit.close();
    });

    test('fires createPet on unauthenticated → authenticated with a draft',
        () async {
      PetModel? captured;
      when(() => petRepo.createPet(any())).thenAnswer((invocation) async {
        captured = invocation.positionalArguments.first as PetModel;
      });

      final cubit = createCubit();
      prepareDraft(cubit);

      authStream.add(const AuthState.authenticated());
      await Future<void>.delayed(Duration.zero);

      verify(() => petRepo.createPet(any())).called(1);
      expect(captured, isNotNull);
      expect(captured!.petId, 'generated-pet-id');
      expect(captured!.petName, 'Milo');
      expect(cubit.state.status, PetCreationStatus.success);
      expect(cubit.state.pendingPet, isNull,
          reason: 'pending pet should be cleared after success');
      await cubit.close();
    });

    test('does not fire when no draft was prepared', () async {
      final cubit = createCubit();

      authStream.add(const AuthState.authenticated());
      await Future<void>.delayed(Duration.zero);

      verifyNever(() => petRepo.createPet(any()));
      await cubit.close();
    });

    test('keeps the pending pet and exposes an error when createPet fails',
        () async {
      when(() => petRepo.createPet(any())).thenThrow(
        const RepositoryNetworkException('offline'),
      );
      final cubit = createCubit();
      prepareDraft(cubit);

      authStream.add(const AuthState.authenticated());
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.status, PetCreationStatus.error);
      expect(cubit.state.error, 'offline');
      expect(cubit.state.pendingPet, isNotNull,
          reason: 'draft must survive a failed insert for retry');
      await cubit.close();
    });
  });

  group('retry', () {
    test('re-runs the insert and succeeds the second time', () async {
      var calls = 0;
      when(() => petRepo.createPet(any())).thenAnswer((_) async {
        calls++;
        if (calls == 1) {
          throw const RepositoryNetworkException('offline');
        }
      });

      final cubit = createCubit();
      prepareDraft(cubit);

      authStream.add(const AuthState.authenticated());
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.status, PetCreationStatus.error);

      await cubit.retry();

      expect(cubit.state.status, PetCreationStatus.success);
      expect(cubit.state.pendingPet, isNull);
      verify(() => petRepo.createPet(any())).called(2);
      await cubit.close();
    });

    test('is a no-op when there is no pending pet', () async {
      final cubit = createCubit();

      await cubit.retry();

      verifyNever(() => petRepo.createPet(any()));
      await cubit.close();
    });
  });
}
