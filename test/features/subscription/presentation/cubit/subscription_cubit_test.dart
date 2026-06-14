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

const _freeConfig = SubscriptionConfigModel(
  configId: 'cfg-free',
  planName: 'free',
  maxImagesPerEvent: 1,
  maxPets: 1,
  maxStorageMb: 500,
  canAccessPremiumIcons: false,
);

const _premiumConfig = SubscriptionConfigModel(
  configId: 'cfg-premium',
  planName: 'premium',
  maxImagesPerEvent: 5,
  maxPets: 10,
  maxStorageMb: 5000,
  canAccessPremiumIcons: true,
);

UserModel _user(String configId) => UserModel(
      userId: 'user-1',
      userName: 'Maxime',
      mail: 'maxime@example.com',
      subscriptionStatus: user_model.SubscriptionStatus.freemium,
      subscriptionConfigId: configId,
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
    when(() => subRepo.getConfigById('cfg-free'))
        .thenAnswer((_) async => _freeConfig);

    final cubit = createCubit();
    authStream.add(const AuthState.authenticated());
    await Future<void>.delayed(Duration.zero);

    userStream.add(_user('cfg-free'));
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.status, SubscriptionStatus.loaded);
    expect(cubit.state.config, _freeConfig);
    verifyNever(() => subRepo.fetchConfigById(any()));
    await cubit.close();
  });

  test('falls back to fetch when the cache is empty', () async {
    when(() => subRepo.getConfigById('cfg-free'))
        .thenAnswer((_) async => null);
    when(() => subRepo.fetchConfigById('cfg-free'))
        .thenAnswer((_) async => _freeConfig);

    final cubit = createCubit();
    authStream.add(const AuthState.authenticated());
    await Future<void>.delayed(Duration.zero);

    userStream.add(_user('cfg-free'));
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.status, SubscriptionStatus.loaded);
    expect(cubit.state.config, _freeConfig);
    verify(() => subRepo.fetchConfigById('cfg-free')).called(1);
    await cubit.close();
  });

  test('emits an error when both cache and fetch fail', () async {
    when(() => subRepo.getConfigById('cfg-free'))
        .thenAnswer((_) async => null);
    when(() => subRepo.fetchConfigById('cfg-free'))
        .thenThrow(Exception('offline'));

    final cubit = createCubit();
    authStream.add(const AuthState.authenticated());
    await Future<void>.delayed(Duration.zero);

    userStream.add(_user('cfg-free'));
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
    verifyNever(() => subRepo.getConfigById(any()));
    await cubit.close();
  });

  test('resets to unknown when the user logs out', () async {
    when(() => subRepo.getConfigById('cfg-free'))
        .thenAnswer((_) async => _freeConfig);

    final cubit = createCubit();
    authStream.add(const AuthState.authenticated());
    await Future<void>.delayed(Duration.zero);
    userStream.add(_user('cfg-free'));
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.status, SubscriptionStatus.loaded);

    authStream.add(const AuthState.unauthenticated());
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.status, SubscriptionStatus.unknown);
    await cubit.close();
  });

  test('forces a refresh on a config upgrade, bypassing the cache', () async {
    when(() => subRepo.getConfigById('cfg-free'))
        .thenAnswer((_) async => _freeConfig);
    when(() => subRepo.fetchConfigById('cfg-premium'))
        .thenAnswer((_) async => _premiumConfig);

    final cubit = createCubit();
    authStream.add(const AuthState.authenticated());
    await Future<void>.delayed(Duration.zero);

    userStream.add(_user('cfg-free'));
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.config, _freeConfig);

    userStream.add(_user('cfg-premium'));
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.config, _premiumConfig);
    // Upgrade must skip the cache and hit the network for the new config.
    verifyNever(() => subRepo.getConfigById('cfg-premium'));
    verify(() => subRepo.fetchConfigById('cfg-premium')).called(1);
    await cubit.close();
  });

  test('subscribes immediately when already authenticated at construction',
      () async {
    when(() => authCubit.state).thenReturn(const AuthState.authenticated());
    when(() => subRepo.getConfigById('cfg-free'))
        .thenAnswer((_) async => _freeConfig);

    final cubit = createCubit();
    await Future<void>.delayed(Duration.zero);

    userStream.add(_user('cfg-free'));
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.status, SubscriptionStatus.loaded);
    await cubit.close();
  });
}
