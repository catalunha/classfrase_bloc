import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

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
    on<ClassifyingEventOnSelectCategory>(_onClassifyingEventOnSelectCategory);
    on<ClassifyingEventOnSaveClassification>(
        _onClassifyingEventOnSaveClassification);
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

  FutureOr<void> _onClassifyingEventOnSelectCategory(
      ClassifyingEventOnSelectCategory event, Emitter<ClassifyingState> emit) {
    List<String> listTemp = [...state.selectedCategoryIdList];
    if (listTemp.contains(event.categoryId)) {
      listTemp.remove(event.categoryId);
    } else {
      listTemp.add(event.categoryId);
    }
    emit(state.copyWith(selectedCategoryIdList: listTemp));
  }

  FutureOr<void> _onClassifyingEventOnSaveClassification(
      ClassifyingEventOnSaveClassification event,
      Emitter<ClassifyingState> emit) async {
    try {
      emit(state.copyWith(status: ClassifyingStateStatus.loading));

      Map<String, Classification> classifications = state.model.classifications;

      List<int> posPhraseListNow = [...state.selectedPosPhraseList];
      posPhraseListNow.sort();
      List<String> categoryIdListNow = [...state.selectedCategoryIdList];
      String classificationsId = const Uuid().v4();
      for (var classificationsItem in classifications.entries) {
        if (listEquals(
            classificationsItem.value.posPhraseList, posPhraseListNow)) {
          classificationsId = classificationsItem.key;
        }
      }
      Classification classificationNew = Classification(
          posPhraseList: posPhraseListNow, categoryIdList: categoryIdListNow);
      List<String> classOrderTemp = [...state.model.classOrder];
      Map<String, Classification> classificationsTemp =
          <String, Classification>{};
      classificationsTemp.addAll(state.model.classifications);

      if (classificationNew.categoryIdList.isEmpty) {
        classOrderTemp.remove(classificationsId);
        classificationsTemp.remove(classificationsId);
      } else {
        if (!classOrderTemp.contains(classificationsId)) {
          classOrderTemp.add(classificationsId);
        }
        classificationsTemp[classificationsId] = classificationNew;
      }
      await _repository.updateClassification(
          state.model.id!, classificationsTemp, classOrderTemp);
      PhraseModel? temp = await _repository.readById(state.model.id!);
      emit(state.copyWith(model: temp, status: ClassifyingStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: ClassifyingStateStatus.error,
          error: 'Ocorreu algum erro ao salvar esta classificação'));
    }
  }
}
