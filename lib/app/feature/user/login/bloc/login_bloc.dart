import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/user_model.dart';
import '../../../../core/repositories/user_repository.dart';
import '../../../../data/b4a/b4a_exception.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userRepository;
  LoginBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(LoginState.initial()) {
    on<LoginEventLoginSubmitted>(_onLoginEventFormSubmitted);
    on<LoginEventRequestPasswordReset>(_onLoginEventRequestPasswordReset);
  }

  FutureOr<void> _onLoginEventFormSubmitted(
      LoginEventLoginSubmitted event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStateStatus.loading));
    try {
      UserModel? user = await _userRepository.login(
          email: event.email, password: event.password);
      print('login_bloc: 1');
      if (user != null) {
        print('login_bloc: 2');
        if (user.profile!.isActive == true) {
          print('login_bloc: 3');
          emit(state.copyWith(status: LoginStateStatus.success, user: user));
        } else {
          print('login_bloc: 4');
          emit(state.copyWith(
              status: LoginStateStatus.error,
              user: null,
              error: 'Sua conta ainda esta em análise.'));
        }
      }
    } on B4aException catch (e) {
      print('login_bloc: 5');
      print(e);
      emit(state.copyWith(
          status: LoginStateStatus.error,
          user: null,
          error: '${e.message} (${e.where} -> ${e.originalError})'));
    } catch (e) {
      print('login_bloc: 6');
      print(e);
      emit(state.copyWith(
          status: LoginStateStatus.error,
          user: null,
          error: 'Erro desconhecido no login.'));
    }
  }

  FutureOr<void> _onLoginEventRequestPasswordReset(
      LoginEventRequestPasswordReset event, Emitter<LoginState> emit) async {
    await _userRepository.requestPasswordReset(event.email);
  }
}
