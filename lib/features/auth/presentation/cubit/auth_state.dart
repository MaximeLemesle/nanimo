part of 'auth_cubit.dart';

enum AuthStatus {unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? errorMessage;

  const AuthState._({
    this.status       = AuthStatus.unknown,
    this.errorMessage,
  });

  const AuthState.unknown()          : this._();
  const AuthState.authenticated()    : this._(status: AuthStatus.authenticated);
  const AuthState.unauthenticated()  : this._(status: AuthStatus.unauthenticated);
  const AuthState.error(String msg)  : this._(
    status:       AuthStatus.unauthenticated,
    errorMessage: msg,
  );

    bool get isAuthenticated   => status == AuthStatus.authenticated;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;
  bool get isUnknown         => status == AuthStatus.unknown;

  @override
  List<Object?> get props => [status, errorMessage];
}