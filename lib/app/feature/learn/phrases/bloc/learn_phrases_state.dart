import 'package:flutter/foundation.dart';

import '../../../../core/models/phrase_model.dart';
import '../../../../core/models/user_profile_model.dart';

enum LearnPhrasesStateStatus { initial, loading, success, error }

class LearnPhrasesState {
  final LearnPhrasesStateStatus status;
  final String? error;
  final UserProfileModel person;
  final List<PhraseModel> list;
  final List<PhraseModel> listOriginal;
  final bool isSortedByFolder;
  final bool isFiltered;
  final List<String> selectedCategoryIdList;

  LearnPhrasesState({
    required this.status,
    this.error,
    required this.person,
    required this.list,
    required this.listOriginal,
    required this.isSortedByFolder,
    required this.isFiltered,
    required this.selectedCategoryIdList,
  });
  LearnPhrasesState.initial(this.person)
      : status = LearnPhrasesStateStatus.initial,
        error = '',
        list = [],
        listOriginal = [],
        selectedCategoryIdList = [],
        isSortedByFolder = true,
        isFiltered = false;
  LearnPhrasesState copyWith({
    LearnPhrasesStateStatus? status,
    String? error,
    UserProfileModel? person,
    List<PhraseModel>? list,
    List<PhraseModel>? listOriginal,
    bool? isSortedByFolder,
    bool? isFiltered,
    List<String>? selectedCategoryIdList,
  }) {
    return LearnPhrasesState(
      status: status ?? this.status,
      error: error ?? this.error,
      person: person ?? this.person,
      list: list ?? this.list,
      listOriginal: listOriginal ?? this.listOriginal,
      isSortedByFolder: isSortedByFolder ?? this.isSortedByFolder,
      isFiltered: isFiltered ?? this.isFiltered,
      selectedCategoryIdList:
          selectedCategoryIdList ?? this.selectedCategoryIdList,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LearnPhrasesState &&
        other.status == status &&
        other.error == error &&
        other.person == person &&
        listEquals(other.list, list) &&
        listEquals(other.listOriginal, listOriginal) &&
        other.isSortedByFolder == isSortedByFolder &&
        other.isFiltered == isFiltered &&
        listEquals(other.selectedCategoryIdList, selectedCategoryIdList);
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        person.hashCode ^
        list.hashCode ^
        listOriginal.hashCode ^
        isSortedByFolder.hashCode ^
        isFiltered.hashCode ^
        selectedCategoryIdList.hashCode;
  }

  @override
  String toString() {
    return 'LearnPhrasesState(status: $status, error: $error, person: $person, list: $list, listOriginal: $listOriginal, isSortedByFolder: $isSortedByFolder, isFiltered: $isFiltered, selectedCategoryIdList: $selectedCategoryIdList)';
  }
}
