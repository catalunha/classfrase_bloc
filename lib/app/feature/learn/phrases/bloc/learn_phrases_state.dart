import 'package:flutter/foundation.dart';

import '../../../../core/models/phrase_model.dart';
import '../../../../core/models/user_profile_model.dart';

enum LearnPhrasesStateStatus { initial, loading, success, error }

class LearnPhrasesState {
  final LearnPhrasesStateStatus status;
  final String? error;
  final UserProfileModel person;
  final List<PhraseModel> list;
  LearnPhrasesState({
    required this.status,
    this.error,
    required this.person,
    required this.list,
  });
  LearnPhrasesState.initial(this.person)
      : status = LearnPhrasesStateStatus.initial,
        error = '',
        list = [];
  LearnPhrasesState copyWith({
    LearnPhrasesStateStatus? status,
    String? error,
    UserProfileModel? person,
    List<PhraseModel>? list,
  }) {
    return LearnPhrasesState(
      status: status ?? this.status,
      error: error ?? this.error,
      person: person ?? this.person,
      list: list ?? this.list,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LearnPhrasesState &&
        other.status == status &&
        other.error == error &&
        other.person == person &&
        listEquals(other.list, list);
  }

  @override
  int get hashCode {
    return status.hashCode ^ error.hashCode ^ person.hashCode ^ list.hashCode;
  }
}
