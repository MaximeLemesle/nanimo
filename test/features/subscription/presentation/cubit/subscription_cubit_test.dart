import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/features/auth/data/auth_repository.dart';
import 'package:nanimo/features/auth/data/models/user_model.dart'
    show UserModel;
import 'package:nanimo/features/auth/data/models/user_model.dart' as user_model;
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nanimo/features/subscription/data/models/subscription_config_model.dart';
import 'package:nanimo/features/subscription/data/subscription_repository.dart';
import 'package:nanimo/features/subscription/presentation/cubit/subscription_cubit.dart';

class _MockAuthCubit extends Mock implements AuthCubit {}

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockSubscriptionRepository extends Mock
    implements SubscriptionRepository {}

const _freemiumConfig = SubscriptionConfigModel(
  configId: 'cfg-freemium',
  planName: 'freemium',
  maxImagesPerEvent: 1,
  maxPets: 1,
  maxStorageMb: 500,
);

const _premiumConfig = SubscriptionConfigModel(
  configId: 'cfg-premium',
  planName: 'premium',
  maxImagesPerEvent: 5,
  maxPets: 10,
  maxStorageMb: 5000,
);

UserModel _user(user_model.SubscriptionStatus status) => UserModel(
      userId: 'user-1',
      userName: 'Maxime',
      mail: 'maxime@example.com',
      subscriptionStatus: status,
    );

void main() {
  late _MockAuthCubit authCubit;
  late _MockAuthRepository authRepo;
  late _MockSubscriptionRepository subRepo;
  late StreamController<AuthState> authStream;
  late StreamController<UserModel?> userStream;

  setUp(() {
    authCubit = _MockAuthCubit();
    authRepo = _MockAuthRepository();
    subRepo = _MockSubscriptionRepository();
    authStream = StreamController<AuthState>.broadcast();
    userStream = StreamController<UserModel?>.broadcast();

    when(() => authCubit.stream).thenAnswer((_) => authStream.stream);
    when(() => authCubit.state).thenReturn(const AuthState.unauthenticated());
    when(() => authRepo.watchCurrentUser())
        .thenAnswer((_) => userStream.stream);
  });

  tearDown(() async {
    await authStream.close();
    await userStream.close();
  });

  SubscriptionCubit createCubit() => SubscriptionCubit(
        authCubit: authCubit,
        authRepository: authRepo,
        subscriptionRepository: subRepo,
      );

  test('starts in the unknown state', () {
    final cubit = createCubit();
    expect(cubit.state.status, SubscriptionStatus.unknown);
    cubit.close();
  });

  test('loads from cache when a user is emitted after authentication',
      () async {
    when(() => subRepo.getConfigByPlanName('freemium'))
        .thenAnswer((_) async => _freemiumConfig);

    final cubit = createCubit();
    authStream.add(const AuthState.authenticated());
    await Future<void>.delayed(Duration.zero);

    userStream.add(_user(user_model.SubscriptionStatus.freemium));
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.status, SubscriptionStatus.loaded);
    expect(cubit.state.config, _freemiumConfig);
    verifyNever(() => subRepo.fetchConfigByPlanName(any()));
    await cubit.close();
  });

  test('resolves the config from the status of a premium user', () async {
    when(() => subRepo.getConfigByPlanName('premium'))
        .thenAnswer((_) async => _premiumConfig);

    final cubit = createCubit();
    authStream.add(const AuthState.authenticated());
    await Future<void>.delayed(Duration.zero);

    userStream.add(_user(user_model.SubscriptionStatus.premium));
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.config, _premiumConfig);
    expect(cubit.state.maxPets, 10);
    await cubit.close();
  });

  test('falls back to fetch when the cache is empty', () async {
    when(() => subRepo.getConfigByPlanName('freemium'))
        .thenAnswer((_) async => null);
    when(() => subRepo.fetchConfigByPlanName('freemium'))
        .thenAnswer((_) async => _freemiumConfig);

    final cubit = createCubit();
    authStream.add(const AuthState.authenticated());
    await Future<void>.delayed(Duration.zero);

    userStream.add(_user(user_model.SubscriptionStatus.freemium));
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.status, SubscriptionStatus.loaded);
    expect(cubit.state.config, _freemiumConfig);
    verify(() => subRepo.fetchConfigByPlanName('freemium')).called(1);
    await cubit.close();
  });

  test('falls back to the network when the cache read throws', () async {
    when(() => subRepo.getConfigByPlanName('freemium'))
        .thenThrow(Exception('isar schema mismatch'));
    when(() => subRepo.fetchConfigByPlanName('freemium'))
        .thenAnswer((_) async => _freemiumConfig);

    final cubit = createCubit();
    authStream.add(const AuthState.authenticated());
    await Future<void>.delayed(Duration.zero);

    userStream.add(_user(user_model.SubscriptionStatus.freemium));
    await Future<void>.delayed(Duration.zero);

    // A throwing cache used to escape _load and strand the cubit in `loading`.
    expect(cubit.state.status, SubscriptionStatus.loaded);
    expect(cubit.state.config, _freemiumConfig);
    await cubit.close();
  });

  test('serves the cached config when an upgrade refresh fails', () async {
    when(() => subRepo.getConfigByPlanName('freemium'))
        .thenAnswer((_) async => _freemiumConfig);
    when(() => subRepo.getConfigByPlanName('premium'))
        .thenAnswer((_) async => _premiumConfig);
    when(() => subRepo.fetchConfigByPlanName('premium'))
        .thenThrow(Exception('offline'));

    final cubit = createCubit();
    authStream.add(const AuthState.authenticated());
    await Future<void>.delayed(Duration.zero);

    userStream.add(_user(user_model.SubscriptionStatus.freemium));
    await Future<void>.delayed(Duration.zero);

    userStream.add(_user(user_model.SubscriptionStatus.premium));
    await Future<void>.delayed(Duration.zero);

    // Failing the refresh must not lock a premium user out of every quota.
    expect(cubit.state.status, SubscriptionStatus.loaded);
    expect(cubit.state.config, _premiumConfig);
    await cubit.close();
  });

  test('emits an error when both cache and fetch fail', () async {
    when(() => subRepo.getConfigByPlanName('freemium'))
        .thenAnswer((_) async => null);
    when(() => subRepo.fetchConfigByPlanName('freemium'))
        .thenThrow(Exception('offline'));

    final cubit = createCubit();
    authStream.add(const AuthState.authenticated());
    await Future<void>.delayed(Duration.zero);

    userStream.add(_user(user_model.SubscriptionStatus.freemium));
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.status, SubscriptionStatus.error);
    expect(cubit.state.errorMessage, contains('offline'));
    await cubit.close();
  });

  test('ignores a null user emission', () async {
    final cubit = createCubit();
    authStream.add(const AuthState.authenticated());
    await Future<void>.delayed(Duration.zero);

    userStream.add(null);
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.status, SubscriptionStatus.unknown);
    verifyNever(() => subRepo.getConfigByPlanName(any()));
    await cubit.close();
  });

  test('resets to unknown when the user logs out', () async {
    when(() => subRepo.getConfigByPlanName('freemium'))
        .thenAnswer((_) async => _freemiumConfig);

    final cubit = createCubit();
    authStream.add(const AuthState.authenticated());
    await Future<void>.delayed(Duration.zero);
    userStream.add(_user(user_model.SubscriptionStatus.freemium));
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.status, SubscriptionStatus.loaded);

    authStream.add(const AuthState.unauthenticated());
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.status, SubscriptionStatus.unknown);
    await cubit.close();
  });

  test('forces a refresh on a plan upgrade, bypassing the cache', () async {
    when(() => subRepo.getConfigByPlanName('freemium'))
        .thenAnswer((_) async => _freemiumConfig);
    when(() => subRepo.fetchConfigByPlanName('premium'))
        .thenAnswer((_) async => _premiumConfig);

    final cubit = createCubit();
    authStream.add(const AuthState.authenticated());
    await Future<void>.delayed(Duration.zero);

    userStream.add(_user(user_model.SubscriptionStatus.freemium));
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.config, _freemiumConfig);

    userStream.add(_user(user_model.SubscriptionStatus.premium));
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.config, _premiumConfig);
    // Upgrade must skip the cache and hit the network for the new config.
    verifyNever(() => subRepo.getConfigByPlanName('premium'));
    verify(() => subRepo.fetchConfigByPlanName('premium')).called(1);
    await cubit.close();
  });

  test('subscribes immediately when already authenticated at construction',
      () async {
    when(() => authCubit.state).thenReturn(const AuthState.authenticated());
    when(() => subRepo.getConfigByPlanName('freemium'))
        .thenAnswer((_) async => _freemiumConfig);

    final cubit = createCubit();
    await Future<void>.delayed(Duration.zero);

    userStream.add(_user(user_model.SubscriptionStatus.freemium));
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.status, SubscriptionStatus.loaded);
    await cubit.close();
  });
}
