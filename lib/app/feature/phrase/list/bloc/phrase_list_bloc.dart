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
    on<PhraseListEventSortAlpha>(_onPhraseListEventSortAlpha);
    on<PhraseListEventSortFolder>(_onPhraseListEventSortFolder);
    on<PhraseListEventIsArchived>(_onPhraseListEventIsArchived);
    on<PhraseListEventAddToList>(_onPhraseListEventAddToList);

    on<PhraseListEventUpdateList>(_onPhraseListEventUpdateList);
    on<PhraseListEventRemoveFromList>(_onPhraseListEventRemoveFromList);
    add(PhraseListEventStartList());
  }
  // final List<String> cols = [
  //   ...PhraseEntity.singleCols,
  //   ...PhraseEntity.pointerCols,
  // ];

  final List<String> cols = PhraseEntity.selectedCols([
    PhraseEntity.phrase,
    PhraseEntity.folder,
    PhraseEntity.font,
    PhraseEntity.diagramUrl,
    PhraseEntity.note,
    PhraseEntity.isArchived,
    PhraseEntity.isPublic,
    PhraseEntity.userProfile,
  ]);
  FutureOr<void> _onPhraseListEventStartList(
      PhraseListEventStartList event, Emitter<PhraseListState> emit) async {
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
      query.whereEqualTo(PhraseEntity.isArchived, event.isArchived);

      query.orderByAscending(PhraseEntity.folder);
      List<PhraseModel> listGet = await _repository.list(
        query,
        Pagination(page: 1, limit: 500),
        cols,
      );
      emit(state.copyWith(
        status: PhraseListStateStatus.success,
        list: listGet,
        query: query,
      ));
    } catch (e) {
      print(e);
      emit(
        state.copyWith(
            status: PhraseListStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onPhraseListEventSortAlpha(
      PhraseListEventSortAlpha event, Emitter<PhraseListState> emit) {
    emit(state.copyWith(isSortedByFolder: false));
  }

  FutureOr<void> _onPhraseListEventSortFolder(
      PhraseListEventSortFolder event, Emitter<PhraseListState> emit) {
    emit(state.copyWith(isSortedByFolder: true));
  }

  FutureOr<void> _onPhraseListEventIsArchived(
      PhraseListEventIsArchived event, Emitter<PhraseListState> emit) async {
    await _repository.updateIsArchive(event.phraseId, event.isArchived);
    add(PhraseListEventStartList());
  }

  FutureOr<void> _onPhraseListEventAddToList(
      PhraseListEventAddToList event, Emitter<PhraseListState> emit) {
    List<PhraseModel> listTemp = [...state.list];
    listTemp.add(event.model);
    listTemp.sort((a, b) => a.folder!.compareTo(b.folder!));
    emit(state.copyWith(list: listTemp));
  }

  FutureOr<void> _onPhraseListEventUpdateList(
      PhraseListEventUpdateList event, Emitter<PhraseListState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.model.id);
    if (index >= 0) {
      List<PhraseModel> listTemp = [...state.list];
      listTemp.replaceRange(index, index + 1, [event.model]);
      listTemp.sort((a, b) => a.folder!.compareTo(b.folder!));

      emit(state.copyWith(list: listTemp));
    }
  }

  FutureOr<void> _onPhraseListEventRemoveFromList(
      PhraseListEventRemoveFromList event, Emitter<PhraseListState> emit) {
    int index = state.list.indexWhere((model) => model.id == event.modelId);
    if (index >= 0) {
      List<PhraseModel> listTemp = [...state.list];
      listTemp.removeAt(index);
      listTemp.sort((a, b) => a.folder!.compareTo(b.folder!));
      emit(state.copyWith(list: listTemp));
    }
  }
}
