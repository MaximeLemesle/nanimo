part of 'auth_cubit.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final bool isSubmitting;
  final String? errorMessage;

  const AuthState._({
    this.status = AuthStatus.unknown,
    this.isSubmitting = false,
    this.errorMessage,
  });

  const AuthState.unknown() : this._();
  const AuthState.authenticated() : this._(status: AuthStatus.authenticated);
  const AuthState.unauthenticated() : this._(status: AuthStatus.unauthenticated);

  AuthState copyWith({
    AuthStatus? status,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState._(
      status: status ?? this.status,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;
  bool get isUnknown => status == AuthStatus.unknown;

  @override
  List<Object?> get props => [status, isSubmitting, errorMessage];
}