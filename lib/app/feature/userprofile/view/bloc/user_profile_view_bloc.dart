import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/user_profile_repository.dart';
import '../../../../data/b4a/entity/user_profile_entity.dart';
import 'user_profile_view_event.dart';
import 'user_profile_view_state.dart';

class UserProfileViewBloc
    extends Bloc<UserProfileViewEvent, UserProfileViewState> {
  final UserProfileRepository _repository;
  UserProfileViewBloc({
    required UserProfileModel model,
    required UserProfileRepository repository,
  })  : _repository = repository,
        super(UserProfileViewState.initial(model)) {
    on<UserProfileViewEventStart>(_onUserProfileViewEventStart);
    add(UserProfileViewEventStart());
  }
  final List<String> cols = [
    ...UserProfileEntity.singleCols,
  ];
  FutureOr<void> _onUserProfileViewEventStart(UserProfileViewEventStart event,
      Emitter<UserProfileViewState> emit) async {
    print('Staaaaaaaarting....');
    emit(state.copyWith(status: UserProfileViewStateStatus.loading));
    try {
      UserProfileModel? temp = await _repository.readById(state.model.id, cols);
      emit(state.copyWith(
          model: temp, status: UserProfileViewStateStatus.updated));
    } catch (e) {
      //print(e);
      emit(state.copyWith(
          status: UserProfileViewStateStatus.error,
          error: 'Erro ao buscar dados do paciente'));
    }
  }
}
