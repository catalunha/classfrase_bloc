import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../core/models/phrase_classification_model.dart';
import '../../../core/models/phrase_model.dart';
import '../../../core/repositories/phrase_repository.dart';
import 'classifying_event.dart';
import 'classifying_state.dart';

class ClassifyingBloc extends Bloc<ClassifyingEvent, ClassifyingState> {
  final PhraseRepository _repository;
  ClassifyingBloc({
    required PhraseModel model,
    required PhraseRepository repository,
  })  : _repository = repository,
        super(ClassifyingState.initial(model)) {
    on<ClassifyingEventOnSelectPhrase>(_onClassifyingEventOnSelectPhrase);
    on<ClassifyingEventOnSelectAllPhrase>(_onClassifyingEventOnSelectAllPhrase);
    on<ClassifyingEventOnSelectClearPhrase>(
        _onClassifyingEventOnSelectClearPhrase);
    on<ClassifyingEventOnSelectInversePhrase>(
        _onClassifyingEventOnSelectInversePhrase);
    on<ClassifyingEventOnChangeClassOrder>(
        _onClassifyingEventOnChangeClassOrder);
    on<ClassifyingEventOnMarkCategoryIfAlreadyClassifiedInPos>(
        _onClassifyingEventOnMarkCategoryIfAlreadyClassifiedInPos);
  }

  FutureOr<void> _onClassifyingEventOnChangeClassOrder(
      ClassifyingEventOnChangeClassOrder event,
      Emitter<ClassifyingState> emit) async {
    try {
      emit(state.copyWith(status: ClassifyingStateStatus.loading));
      await _repository.updateClassOrder(state.model.id!, event.classOrder);
      emit(state.copyWith(status: ClassifyingStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: ClassifyingStateStatus.error,
          error: 'Erro na troca de ordem'));
    }
  }

  FutureOr<void> _onClassifyingEventOnSelectPhrase(
      ClassifyingEventOnSelectPhrase event, Emitter<ClassifyingState> emit) {
    List<int> listTemp = [...state.selectedPosPhraseList];
    if (listTemp.contains(event.phrasePos)) {
      listTemp.remove(event.phrasePos);
    } else {
      listTemp.add(event.phrasePos);
    }
    emit(state.copyWith(selectedPosPhraseList: listTemp));
  }

  FutureOr<void> _onClassifyingEventOnSelectAllPhrase(
      ClassifyingEventOnSelectAllPhrase event, Emitter<ClassifyingState> emit) {
    List<int> listTemp = [];
    for (var wordPos = 0; wordPos < state.model.phrase.length; wordPos++) {
      if (state.model.phrase[wordPos] != ' ') {
        listTemp.add(wordPos);
      }
    }
    emit(state.copyWith(selectedPosPhraseList: listTemp));
  }

  FutureOr<void> _onClassifyingEventOnSelectClearPhrase(
      ClassifyingEventOnSelectClearPhrase event,
      Emitter<ClassifyingState> emit) {
    emit(state.copyWith(selectedPosPhraseList: []));
  }

  FutureOr<void> _onClassifyingEventOnSelectInversePhrase(
      ClassifyingEventOnSelectInversePhrase event,
      Emitter<ClassifyingState> emit) {
    for (var wordPos = 0; wordPos < state.model.phrase.length; wordPos++) {
      if (state.model.phrase[wordPos] != ' ') {
        add(ClassifyingEventOnSelectPhrase(phrasePos: wordPos));
      }
    }
  }

  FutureOr<void> _onClassifyingEventOnMarkCategoryIfAlreadyClassifiedInPos(
      ClassifyingEventOnMarkCategoryIfAlreadyClassifiedInPos event,
      Emitter<ClassifyingState> emit) {
    Map<String, Classification> classifications = state.model.classifications;
    List<int> posPhraseListNow = [...state.selectedPosPhraseList];
    posPhraseListNow.sort();
    List<String> categoryIdListNow = [];
    for (var classification in classifications.values) {
      if (listEquals(classification.posPhraseList, posPhraseListNow)) {
        categoryIdListNow.addAll(classification.categoryIdList);
        break;
      }
    }
    emit(state.copyWith(selectedCategoryIdList: categoryIdListNow));
  }
}
