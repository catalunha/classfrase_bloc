import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/user_profile_repository.dart';
import '../../../../data/b4a/entity/user_profile_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'user_profile_select_event.dart';
import 'user_profile_select_state.dart';

class UserProfileSelectBloc
    extends Bloc<UserProfileSelectEvent, UserProfileSelectState> {
  final UserProfileRepository _repository;
  UserProfileSelectBloc({
    required UserProfileRepository repository,
    required UserProfileModel seller,
    required bool isSingleValue,
  })  : _repository = repository,
        super(UserProfileSelectState.initial(isSingleValue)) {
    on<UserProfileSelectEventStartQuery>(_onUserProfileSelectEventStartQuery);
    on<UserProfileSelectEventPreviousPage>(
        _onUserProfileSelectEventPreviousPage);
    on<UserProfileSelectEventNextPage>(_onUserProfileSelectEventNextPage);
    on<UserProfileSelectEventFormSubmitted>(
        _onUserProfileSelectEventFormSubmitted);
    on<UserProfileSelectEventUpdateSelectedValues>(
        _onUserProfileSelectEventUpdateSelectedValues);
    add(UserProfileSelectEventStartQuery());
  }
  final List<String> cols = [
    // ...UserProfileEntity.allCols,
    ...UserProfileEntity.selectedCols([
      UserProfileEntity.name,
      UserProfileEntity.isActive,
      UserProfileEntity.access,
      UserProfileEntity.email,
    ]),
  ];
  FutureOr<void> _onUserProfileSelectEventStartQuery(
      UserProfileSelectEventStartQuery event,
      Emitter<UserProfileSelectState> emit) async {
    emit(state.copyWith(
      status: UserProfileSelectStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      list: [],
      query:
          QueryBuilder<ParseObject>(ParseObject(UserProfileEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(UserProfileEntity.className));

      query.orderByAscending('name');
      List<UserProfileModel> listGet = await _repository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
        cols,
      );

      emit(state.copyWith(
        status: UserProfileSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        query: query,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: UserProfileSelectStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onUserProfileSelectEventPreviousPage(
      UserProfileSelectEventPreviousPage event,
      Emitter<UserProfileSelectState> emit) async {
    emit(
      state.copyWith(
        status: UserProfileSelectStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<UserProfileModel> listGet = await _repository.list(
        state.query,
        Pagination(page: state.page, limit: state.limit),
        cols,
      );
      if (state.page == 1) {
        emit(
          state.copyWith(
            page: 1,
            firstPage: true,
            lastPage: false,
          ),
        );
      }
      emit(state.copyWith(
        status: UserProfileSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: UserProfileSelectStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onUserProfileSelectEventNextPage(
      UserProfileSelectEventNextPage event,
      Emitter<UserProfileSelectState> emit) async {
    emit(
      state.copyWith(status: UserProfileSelectStateStatus.loading),
    );
    List<UserProfileModel> listGet = await _repository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
      cols,
    );
    if (listGet.isEmpty) {
      emit(state.copyWith(
        status: UserProfileSelectStateStatus.success,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: UserProfileSelectStateStatus.success,
        list: listGet,
        listFiltered: listGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onUserProfileSelectEventFormSubmitted(
      UserProfileSelectEventFormSubmitted event,
      Emitter<UserProfileSelectState> emit) {
    if (event.name.isEmpty) {
      emit(state.copyWith(listFiltered: state.list));
    } else {
      List<UserProfileModel> listTemp;
      listTemp = state.list.where((e) => e.name!.contains(event.name)).toList();
      emit(state.copyWith(listFiltered: listTemp));
    }
  }

  FutureOr<void> _onUserProfileSelectEventUpdateSelectedValues(
      UserProfileSelectEventUpdateSelectedValues event,
      Emitter<UserProfileSelectState> emit) {
    int index =
        state.selectedValues.indexWhere((model) => model.id == event.model.id);
    if (index >= 0) {
      List<UserProfileModel> temp = [...state.selectedValues];
      temp.removeAt(index);
      emit(state.copyWith(selectedValues: temp));
    } else {
      List<UserProfileModel> temp = [...state.selectedValues];
      temp.add(event.model);
      emit(state.copyWith(selectedValues: temp));
    }
  }
}
