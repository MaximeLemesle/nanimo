import 'dart:async';
import 'dart:developer' as developer;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/features/auth/data/auth_repository.dart';
import 'package:nanimo/features/auth/data/models/user_model.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nanimo/features/subscription/data/models/subscription_config_model.dart';
import 'package:nanimo/features/subscription/data/subscription_repository.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final AuthCubit _authCubit;
  final AuthRepository _authRepository;
  final SubscriptionRepository _subscriptionRepository;

  late final StreamSubscription<AuthState> _authSub;
  StreamSubscription<UserModel?>? _userSub;
  String? _lastPlanName;

  SubscriptionCubit({
    required AuthCubit authCubit,
    required AuthRepository authRepository,
    required SubscriptionRepository subscriptionRepository,
  })  : _authCubit = authCubit,
        _authRepository = authRepository,
        _subscriptionRepository = subscriptionRepository,
        super(const SubscriptionState.unknown()) {
    _bindToAuth();
  }

  void _bindToAuth() {
    if (_authCubit.state.isAuthenticated) {
      _onAuthenticated();
    }
    _authSub = _authCubit.stream.listen((auth) {
      if (auth.isAuthenticated) {
        _onAuthenticated();
      } else if (auth.isUnauthenticated) {
        _onUnauthenticated();
      }
    });
  }

  void _onAuthenticated() {
    _userSub?.cancel();
    _userSub = _authRepository.watchCurrentUser().listen(_onUserChanged);
  }

  void _onUnauthenticated() {
    _userSub?.cancel();
    _userSub = null;
    _lastPlanName = null;
    emit(const SubscriptionState.unknown());
  }

  Future<void> _onUserChanged(UserModel? user) async {
    if (user == null) return;
    final planName = user.planName;

    if (planName == _lastPlanName && state.status == SubscriptionStatus.loaded) {
      return;
    }
    final isUpgrade = _lastPlanName != null && _lastPlanName != planName;
    _lastPlanName = planName;
    await _load(planName, forceRefresh: isUpgrade);
  }

  Future<void> _load(String planName, {required bool forceRefresh}) async {
    emit(const SubscriptionState.loading());

    if (!forceRefresh) {
      final cached = await _readCache(planName);
      if (cached != null) {
        emit(SubscriptionState.loaded(cached));
        return;
      }
    }

    try {
      final fresh = await _subscriptionRepository.fetchConfigByPlanName(planName);
      emit(SubscriptionState.loaded(fresh));
    } catch (e, st) {
      developer.log('config load failed for plan "$planName"', name: 'subscription', error: e, stackTrace: st);
      final cached = forceRefresh ? await _readCache(planName) : null;
      if (cached != null) {
        emit(SubscriptionState.loaded(cached));
        return;
      }
      emit(SubscriptionState.error(e.toString()));
    }
  }

  Future<SubscriptionConfigModel?> _readCache(String planName) async {
    try {
      return await _subscriptionRepository.getConfigByPlanName(planName);
    } catch (e, st) {
      developer.log('config cache read failed for plan "$planName", falling back to network',
          name: 'subscription', error: e, stackTrace: st);
      return null;
    }
  }

  @override
  Future<void> close() {
    _authSub.cancel();
    _userSub?.cancel();
    return super.close();
  }
}
