import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../../core/models/user_model.dart';
import '../../../../../data/b4a/b4a_exception.dart';
import '../../../../../core/repositories/user_repository.dart';

part 'user_register_email_event.dart';
part 'user_register_email_state.dart';

class UserRegisterEmailBloc
    extends Bloc<UserRegisterEmailEvent, UserRegisterEmailState> {
  final UserRepository _userRepository;

  UserRegisterEmailBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(UserRegisterEmailState.initial()) {
    on<UserRegisterEmailEventFormSubmitted>(
        _onUserRegisterEmailEventFormSubmitted);
  }

  FutureOr<void> _onUserRegisterEmailEventFormSubmitted(
      UserRegisterEmailEventFormSubmitted event,
      Emitter<UserRegisterEmailState> emit) async {
    emit(state.copyWith(status: UserRegisterEmailStateStatus.loading));

    try {
      UserModel? user = await _userRepository.register(
          email: event.email, password: event.password);
      if (user != null) {
        emit(state.copyWith(status: UserRegisterEmailStateStatus.success));
      }
      emit(state.copyWith(status: UserRegisterEmailStateStatus.success));
    } on B4aException catch (e) {
      emit(state.copyWith(
          status: UserRegisterEmailStateStatus.error,
          error: '${e.message} (${e.where} -> ${e.originalError}'));
    } catch (e) {
      //print(e);
      emit(state.copyWith(
          status: UserRegisterEmailStateStatus.error,
          error: 'Erro desconhecido em registrar seu cadastro'));
    }
  }
}
