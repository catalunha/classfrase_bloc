import 'package:flutter/foundation.dart';

import '../../../core/models/phrase_model.dart';

enum ClassifyingStateStatus { initial, loading, success, error }

class ClassifyingState {
  final ClassifyingStateStatus status;
  final String? error;
  final PhraseModel model;
  final List<int> selectedPosPhraseList;
  final List<String> selectedCategoryIdList;
  ClassifyingState({
    required this.status,
    this.error,
    required this.model,
    required this.selectedPosPhraseList,
    required this.selectedCategoryIdList,
  });

  ClassifyingState.initial(this.model)
      : status = ClassifyingStateStatus.initial,
        error = '',
        selectedPosPhraseList = [],
        selectedCategoryIdList = [];

  ClassifyingState copyWith({
    ClassifyingStateStatus? status,
    String? error,
    PhraseModel? model,
    List<int>? selectedPosPhraseList,
    List<String>? selectedCategoryIdList,
  }) {
    return ClassifyingState(
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
      selectedPosPhraseList:
          selectedPosPhraseList ?? this.selectedPosPhraseList,
      selectedCategoryIdList:
          selectedCategoryIdList ?? this.selectedCategoryIdList,
    );
  }

  @override
  String toString() {
    return 'ClassifyingState(status: $status, error: $error, model: $model, selectedPosPhraseList: $selectedPosPhraseList, selectedCategoryIdList: $selectedCategoryIdList)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ClassifyingState &&
        other.status == status &&
        other.error == error &&
        other.model == model &&
        listEquals(other.selectedPosPhraseList, selectedPosPhraseList) &&
        listEquals(other.selectedCategoryIdList, selectedCategoryIdList);
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        model.hashCode ^
        selectedPosPhraseList.hashCode ^
        selectedCategoryIdList.hashCode;
  }
}
