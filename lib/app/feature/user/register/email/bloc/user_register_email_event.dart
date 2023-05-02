part of 'user_register_email_bloc.dart';

abstract class UserRegisterEmailEvent {}

class UserRegisterEmailEventFormSubmitted extends UserRegisterEmailEvent {
  final String email;
  final String password;
  UserRegisterEmailEventFormSubmitted(
      {required this.email, required this.password});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserRegisterEmailEventFormSubmitted &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode => email.hashCode ^ password.hashCode;
}
