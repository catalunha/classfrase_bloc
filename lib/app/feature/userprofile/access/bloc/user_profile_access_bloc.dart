import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/user_profile_repository.dart';
import '../../../../data/b4a/entity/user_profile_entity.dart';
import 'user_profile_access_event.dart';
import 'user_profile_access_state.dart';

class UserProfileAccessBloc
    extends Bloc<UserProfileAccessEvent, UserProfileAccessState> {
  final UserProfileRepository _repository;

  UserProfileAccessBloc(
      {required UserProfileModel model,
      required UserProfileRepository repository})
      : _repository = repository,
        super(UserProfileAccessState.initial(model)) {
    on<UserProfileAccessEventStart>(_onUserProfileAccessEventStart);

    on<UserProfileAccessEventFormSubmitted>(
        _onUserProfileAccessEventFormSubmitted);
    on<UserProfileAccessEventUpdateAccess>(
        _onUserProfileAccessEventUpdateAccess);

    add(UserProfileAccessEventStart());
  }
  final List<String> cols = [
    ...UserProfileEntity.singleCols,
  ];
  FutureOr<void> _onUserProfileAccessEventStart(
      UserProfileAccessEventStart event,
      Emitter<UserProfileAccessState> emit) async {
    print('UserProfileAccessBloc Staaaaaaaarting....');
    emit(state.copyWith(status: UserProfileAccessStateStatus.loading));
    try {
      UserProfileModel? temp = await _repository.readById(state.model.id, cols);
      emit(state.copyWith(
        model: temp,
        status: UserProfileAccessStateStatus.updated,
      ));
    } catch (e) {
      //print(e);
      emit(state.copyWith(
          status: UserProfileAccessStateStatus.error,
          error: 'Erro ao buscar dados do paciente'));
    }
  }

  FutureOr<void> _onUserProfileAccessEventFormSubmitted(
      UserProfileAccessEventFormSubmitted event,
      Emitter<UserProfileAccessState> emit) async {
    emit(state.copyWith(status: UserProfileAccessStateStatus.loading));
    try {
      UserProfileModel model = state.model.copyWith(
        isActive: event.isActive,
        access: state.access,
      );

      String userProfileId = await _repository.update(model);

      emit(state.copyWith(
          model: model, status: UserProfileAccessStateStatus.success));
    } catch (_) {
      emit(state.copyWith(
          status: UserProfileAccessStateStatus.error,
          error: 'Erro ao salvar dados neste perfil'));
    }
  }

  FutureOr<void> _onUserProfileAccessEventUpdateAccess(
      UserProfileAccessEventUpdateAccess event,
      Emitter<UserProfileAccessState> emit) {
    List<String> access = [...state.access];
    if (access.contains(event.access)) {
      access.remove(event.access);
    } else {
      access.add(event.access);
    }
    emit(state.copyWith(access: access));
  }
}
