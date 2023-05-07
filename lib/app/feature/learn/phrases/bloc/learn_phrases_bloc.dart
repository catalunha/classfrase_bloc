import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

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
    add(LearnPhrasesEventStart());
  }
  final List<String> cols = PhraseEntity.selectedCols([
    PhraseEntity.phrase,
    PhraseEntity.folder,
    PhraseEntity.font,
    PhraseEntity.diagramUrl,
    PhraseEntity.isPublic,
    PhraseEntity.userProfile,
  ]);
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
}
