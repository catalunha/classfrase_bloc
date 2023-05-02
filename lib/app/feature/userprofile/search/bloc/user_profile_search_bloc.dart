import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/user_profile_repository.dart';
import '../../../../data/b4a/entity/user_profile_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'user_profile_search_event.dart';
import 'user_profile_search_state.dart';

class UserProfileSearchBloc
    extends Bloc<UserProfileSearchEvent, UserProfileSearchState> {
  final UserProfileRepository _userProfileRepository;

  UserProfileSearchBloc({required UserProfileRepository userProfileRepository})
      : _userProfileRepository = userProfileRepository,
        super(UserProfileSearchState.initial()) {
    on<UserProfileSearchEventNextPage>(_onUserProfileSearchEventNextPage);
    on<UserProfileSearchEventUpdateList>(_onUserProfileSearchEventUpdateList);
    on<UserProfileSearchEventPreviousPage>(
        _onUserProfileSearchEventPreviousPage);
    on<UserProfileSearchEventFormSubmitted>(
        _onUserProfileSearchEventFormSubmitted);
  }

  final List<String> cols = [
    ...UserProfileEntity.selectedCols([
      UserProfileEntity.name,
      UserProfileEntity.phone,
      UserProfileEntity.email,
      UserProfileEntity.access,
      UserProfileEntity.isActive,
    ]),
  ];

  FutureOr<void> _onUserProfileSearchEventFormSubmitted(
      UserProfileSearchEventFormSubmitted event,
      Emitter<UserProfileSearchState> emit) async {
    emit(state.copyWith(
      status: UserProfileSearchStateStatus.loading,
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

      if (event.nameContainsBool) {
        query.whereContains('name', event.nameContainsString);
      }

      if (event.cpfEqualToBool) {
        query.whereEqualTo('register', event.cpfEqualToString);
      }
      if (event.phoneEqualToBool) {
        query.whereEqualTo('phone', event.phoneEqualToString);
      }
      query.orderByDescending('updatedAt');
      print(cols);
      List<UserProfileModel> listGet = await _userProfileRepository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
        cols,
      );
      emit(state.copyWith(
        status: UserProfileSearchStateStatus.success,
        list: listGet,
        query: query,
      ));
    } catch (e) {
      print(e);
      emit(
        state.copyWith(
            status: UserProfileSearchStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onUserProfileSearchEventUpdateList(
      UserProfileSearchEventUpdateList event,
      Emitter<UserProfileSearchState> emit) {
    int index =
        state.list.indexWhere((model) => model.id == event.userProfileModel.id);
    List<UserProfileModel> listTemp = [...state.list];
    listTemp.replaceRange(index, index + 1, [event.userProfileModel]);
    emit(state.copyWith(list: listTemp));
  }

  FutureOr<void> _onUserProfileSearchEventPreviousPage(
      UserProfileSearchEventPreviousPage event,
      Emitter<UserProfileSearchState> emit) async {
    emit(
      state.copyWith(
        status: UserProfileSearchStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<UserProfileModel> listGet = await _userProfileRepository.list(
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
        status: UserProfileSearchStateStatus.success,
        list: listGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: UserProfileSearchStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onUserProfileSearchEventNextPage(
      UserProfileSearchEventNextPage event,
      Emitter<UserProfileSearchState> emit) async {
    emit(
      state.copyWith(status: UserProfileSearchStateStatus.loading),
    );
    List<UserProfileModel> listGet = await _userProfileRepository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
      cols,
    );
    if (listGet.isEmpty) {
      emit(state.copyWith(
        status: UserProfileSearchStateStatus.success,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: UserProfileSearchStateStatus.success,
        list: listGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }
}
