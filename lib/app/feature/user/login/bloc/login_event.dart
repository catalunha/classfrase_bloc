part of 'login_bloc.dart';

abstract class LoginEvent {}

class LoginEventLoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  LoginEventLoginSubmitted({required this.email, required this.password});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoginEventLoginSubmitted &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode => email.hashCode ^ password.hashCode;
}

class LoginEventRequestPasswordReset extends LoginEvent {
  final String email;

  LoginEventRequestPasswordReset({required this.email});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoginEventRequestPasswordReset && other.email == email;
  }

  @override
  int get hashCode => email.hashCode;
}
