import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/phrase_classification_model.dart';
import '../../../../core/models/phrase_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/phrase_repository.dart';
import '../../../../data/b4a/entity/phrase_entity.dart';
import '../../../../data/b4a/entity/user_profile_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'learn_phrases_event.dart';
import 'learn_phrases_state.dart';

class LearnPhrasesBloc extends Bloc<LearnPhrasesEvent, LearnPhrasesState> {
  final UserProfileModel _userProfile;
  final PhraseRepository _repository;
  LearnPhrasesBloc({
    required UserProfileModel userProfile,
    required PhraseRepository repository,
  })  : _userProfile = userProfile,
        _repository = repository,
        super(LearnPhrasesState.initial(userProfile)) {
    on<LearnPhrasesEventStart>(_onLearnPhrasesEventStart);
    on<LearnPhrasesEventSortAlpha>(_onLearnPhrasesEventSortAlpha);
    on<LearnPhrasesEventSortFolder>(_onLearnPhrasesEventSortFolder);
    on<LearnPhrasesEventOnMarkCategoryIfAlreadyClassifiedInPos>(
        _onLearnPhrasesEventOnMarkCategoryIfAlreadyClassifiedInPos);
    on<LearnPhrasesEventFilterPhasesByThisCategory>(
        _onLearnPhrasesEventFilterPhasesByThisCategory);
    on<LearnPhrasesEventFilterRemoved>(_onLearnPhrasesEventFilterRemoved);
    add(LearnPhrasesEventStart());
  }
  final List<String> cols = [
    ...PhraseEntity.singleCols,
    ...PhraseEntity.pointerCols,
  ];
  FutureOr<void> _onLearnPhrasesEventStart(
      LearnPhrasesEventStart event, Emitter<LearnPhrasesState> emit) async {
    emit(state.copyWith(
      status: LearnPhrasesStateStatus.loading,
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(PhraseEntity.className));

      query.whereEqualTo(
          PhraseEntity.userProfile,
          (ParseObject(UserProfileEntity.className)..objectId = _userProfile.id)
              .toPointer());
      query.whereEqualTo(PhraseEntity.isPublic, true);
      query.whereEqualTo(PhraseEntity.isPublic, true);

      query.orderByAscending(PhraseEntity.folder);
      List<PhraseModel> listTemp = await _repository.list(
        query,
        Pagination(page: 1, limit: 500),
        cols,
      );

      emit(state.copyWith(
        status: LearnPhrasesStateStatus.success,
        list: listTemp,
        listOriginal: listTemp,
      ));
    } catch (e) {
      emit(
        state.copyWith(
            status: LearnPhrasesStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onLearnPhrasesEventSortAlpha(
      LearnPhrasesEventSortAlpha event, Emitter<LearnPhrasesState> emit) {
    emit(state.copyWith(isSortedByFolder: false));
  }

  FutureOr<void> _onLearnPhrasesEventSortFolder(
      LearnPhrasesEventSortFolder event, Emitter<LearnPhrasesState> emit) {
    emit(state.copyWith(isSortedByFolder: true));
  }

  FutureOr<void> _onLearnPhrasesEventOnMarkCategoryIfAlreadyClassifiedInPos(
      LearnPhrasesEventOnMarkCategoryIfAlreadyClassifiedInPos event,
      Emitter<LearnPhrasesState> emit) {
    List<String> categoryIdListNow = [];
    for (var phrase in state.list) {
      Map<String, Classification> classifications = phrase.classifications!;
      for (var classification in classifications.values) {
        categoryIdListNow.addAll(classification.categoryIdList);
      }
    }
    emit(state.copyWith(selectedCategoryIdList: categoryIdListNow));
  }

  FutureOr<void> _onLearnPhrasesEventFilterPhasesByThisCategory(
      LearnPhrasesEventFilterPhasesByThisCategory event,
      Emitter<LearnPhrasesState> emit) {
    final listTempSearch = [...state.list];
    final listTemp = [...state.list];
    for (var phrase in listTempSearch) {
      Map<String, Classification> classifications = phrase.classifications!;
      bool contain = false;
      for (var classification in classifications.values) {
        if (classification.categoryIdList.contains(event.catClassId)) {
          contain = true;
        }
      }
      if (!contain) {
        listTemp.removeWhere((element) => element.id == phrase.id);
      }
    }
    emit(state.copyWith(isFiltered: true, list: listTemp));
  }

  FutureOr<void> _onLearnPhrasesEventFilterRemoved(
      LearnPhrasesEventFilterRemoved event, Emitter<LearnPhrasesState> emit) {
    emit(state.copyWith(isFiltered: false, list: state.listOriginal));
  }
}
