import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/learn_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/learn_repository.dart';
import '../../../../data/b4a/entity/learn_entity.dart';
import '../../../../data/b4a/entity/user_profile_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'learn_list_event.dart';
import 'learn_list_state.dart';

class LearnListBloc extends Bloc<LearnListEvent, LearnListState> {
  final LearnRepository _repository;
  final UserProfileModel _userProfile;
  LearnListBloc({
    required UserProfileModel userProfile,
    required LearnRepository repository,
  })  : _userProfile = userProfile,
        _repository = repository,
        super(LearnListState.initial()) {
    on<LearnListEventStart>(_onLearnListEventStart);
    on<LearnListEventUpdateList>(_onLearnListEventUpdateList);
    on<LearnListEventRemoveFromList>(_onLearnListEventRemoveFromList);
    on<LearnListEventDelete>(_onLearnListEventDelete);

    add(LearnListEventStart());
  }
  final List<String> cols = [
    ...LearnEntity.pointerCols,
  ];
  FutureOr<void> _onLearnListEventStart(
      LearnListEventStart event, Emitter<LearnListState> emit) async {
    emit(state.copyWith(
      status: LearnListStateStatus.loading,
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(LearnEntity.className));

      query.whereEqualTo(
          LearnEntity.userProfile,
          (ParseObject(UserProfileEntity.className)..objectId = _userProfile.id)
              .toPointer());
      query.orderByDescending('updatedAt');
      List<LearnModel> listTemp = await _repository.list(
        query,
        Pagination(page: 1, limit: 100),
        cols,
      );
      print('listTemp: $listTemp');
      emit(state.copyWith(
        status: LearnListStateStatus.success,
        list: listTemp,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: LearnListStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onLearnListEventUpdateList(
      LearnListEventUpdateList event, Emitter<LearnListState> emit) {
    if (event.model != null) {
      List<LearnModel> listTemp = [...state.list];
      listTemp.add(event.model!);
      emit(state.copyWith(list: listTemp));
    }
  }

  FutureOr<void> _onLearnListEventRemoveFromList(
      LearnListEventRemoveFromList event, Emitter<LearnListState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.id);
    if (index >= 0) {
      List<LearnModel> listTemp = [...state.list];
      listTemp.removeAt(index);
      emit(state.copyWith(list: listTemp));
    }
  }

  FutureOr<void> _onLearnListEventDelete(
      LearnListEventDelete event, Emitter<LearnListState> emit) async {
    try {
      emit(state.copyWith(status: LearnListStateStatus.loading));
      await _repository.delete(event.id);
      add(LearnListEventRemoveFromList(event.id));
      emit(state.copyWith(status: LearnListStateStatus.success));
    } catch (e) {
      print(e);
      emit(state.copyWith(
          status: LearnListStateStatus.error,
          error: 'Erro ao deletar pessoa do aprendizado'));
    }
  }
}
