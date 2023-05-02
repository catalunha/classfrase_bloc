part of 'authentication_bloc.dart';

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
  databaseError
}

class AuthenticationState {
  final AuthenticationStatus status;
  final String error;
  final UserModel? user;
  const AuthenticationState({
    this.status = AuthenticationStatus.unknown,
    this.user,
    this.error = '',
  });
  const AuthenticationState.unknown() : this();
  const AuthenticationState.authenticated(UserModel? user)
      : this(
          status: AuthenticationStatus.authenticated,
          user: user,
          error: '',
        );
  const AuthenticationState.unauthenticated()
      : this(
          status: AuthenticationStatus.unauthenticated,
          user: null,
          error: '',
        );

  AuthenticationState copyWith({
    AuthenticationStatus? status,
    String? error,
    UserModel? user,
  }) {
    return AuthenticationState(
      status: status ?? this.status,
      error: error ?? this.error,
      user: user ?? this.user,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthenticationState &&
        other.status == status &&
        other.error == error &&
        other.user == user;
  }

  @override
  int get hashCode => status.hashCode ^ error.hashCode ^ user.hashCode;
}
