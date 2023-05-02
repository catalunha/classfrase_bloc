part of 'authentication_bloc.dart';

abstract class AuthenticationEvent {
  const AuthenticationEvent();
}

class AuthenticationEventLogoutRequested extends AuthenticationEvent {}

class AuthenticationEventInitial extends AuthenticationEvent {}

class AuthenticationEventLoginRequested extends AuthenticationEvent {
  final UserModel? user;

  AuthenticationEventLoginRequested(this.user);
}

class AuthenticationEventUpdateUserProfile extends AuthenticationEvent {
  final UserModel? user;

  AuthenticationEventUpdateUserProfile(this.user);
}
