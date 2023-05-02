import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/phrase_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/phrase_repository.dart';
import '../../../../data/b4a/entity/phrase_entity.dart';
import '../../../../data/b4a/entity/user_profile_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'phrase_list_event.dart';
import 'phrase_list_state.dart';

class PhraseListBloc extends Bloc<PhraseListEvent, PhraseListState> {
  final PhraseRepository _repository;
  final UserProfileModel _userProfile;
  PhraseListBloc({
    required UserProfileModel userProfile,
    required PhraseRepository repository,
  })  : _userProfile = userProfile,
        _repository = repository,
        super(PhraseListState.initial()) {
    on<PhraseListEventStartList>(_onPhraseListEventStartList);
    add(PhraseListEventStartList());
    print('=====================1>');
  }
  final List<String> cols = [
    ...PhraseEntity.singleCols,
    ...PhraseEntity.pointerCols,
  ];
  FutureOr<void> _onPhraseListEventStartList(
      PhraseListEventStartList event, Emitter<PhraseListState> emit) async {
    print('=====================2>');
    emit(state.copyWith(
      status: PhraseListStateStatus.loading,
      list: [],
      query: QueryBuilder<ParseObject>(ParseObject(PhraseEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(PhraseEntity.className));
      query.whereEqualTo(
          PhraseEntity.userProfile,
          (ParseObject(UserProfileEntity.className)..objectId = _userProfile.id)
              .toPointer());
      query.whereEqualTo(PhraseEntity.isArchived, false);

      query.orderByAscending(PhraseEntity.folder);
      print('------------> listGet: 0');
      List<PhraseModel> listGet = await _repository.list(
        query,
        Pagination(page: 1, limit: 10),
        cols,
      );
      print('------------> listGet: ${listGet.length}');
      emit(state.copyWith(
        status: PhraseListStateStatus.success,
        list: listGet,
        query: query,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: PhraseListStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }
}
