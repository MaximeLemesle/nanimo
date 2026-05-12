import 'dart:async';

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
  String? _lastConfigId;

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
    _lastConfigId = null;
    emit(const SubscriptionState.unknown());
  }

  Future<void> _onUserChanged(UserModel? user) async {
    if (user == null) return;
    final configId = user.subscriptionConfigId;
    if (configId == _lastConfigId && state.status == SubscriptionStatus.loaded) {
      return;
    }
    final isUpgrade = _lastConfigId != null && _lastConfigId != configId;
    _lastConfigId = configId;
    await _load(configId, forceRefresh: isUpgrade);
  }

  Future<void> _load(String configId, {required bool forceRefresh}) async {
    emit(const SubscriptionState.loading());

    if (!forceRefresh) {
      final cached = await _subscriptionRepository.getConfigById(configId);
      if (cached != null) {
        emit(SubscriptionState.loaded(cached));
        return;
      }
    }

    try {
      final fresh = await _subscriptionRepository.fetchConfigById(configId);
      emit(SubscriptionState.loaded(fresh));
    } catch (e) {
      emit(SubscriptionState.error(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _authSub.cancel();
    _userSub?.cancel();
    return super.close();
  }
}
