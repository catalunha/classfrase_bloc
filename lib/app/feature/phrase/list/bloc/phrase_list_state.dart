import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/phrase_model.dart';
import '../../../../data/b4a/entity/phrase_entity.dart';

enum PhraseListStateStatus { initial, loading, success, error }

class PhraseListState {
  final PhraseListStateStatus status;
  final String? error;
  final List<PhraseModel> list;
  final bool isSortedByFolder;
  QueryBuilder<ParseObject> query;
  PhraseListState({
    required this.status,
    this.error,
    required this.list,
    this.isSortedByFolder = true,
    required this.query,
  });
  PhraseListState.initial()
      : status = PhraseListStateStatus.initial,
        error = '',
        list = [],
        isSortedByFolder = true,
        query = QueryBuilder<ParseObject>(ParseObject(PhraseEntity.className));

  PhraseListState copyWith({
    PhraseListStateStatus? status,
    String? error,
    List<PhraseModel>? list,
    bool? isSortedByFolder,
    QueryBuilder<ParseObject>? query,
  }) {
    return PhraseListState(
      status: status ?? this.status,
      error: error ?? this.error,
      list: list ?? this.list,
      isSortedByFolder: isSortedByFolder ?? this.isSortedByFolder,
      query: query ?? this.query,
    );
  }

  @override
  String toString() {
    return 'PhraseListState(status: $status, error: $error, list: $list, isSortedByFolder: $isSortedByFolder, query: $query)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PhraseListState &&
        other.status == status &&
        other.error == error &&
        listEquals(other.list, list) &&
        other.isSortedByFolder == isSortedByFolder &&
        other.query == query;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        list.hashCode ^
        isSortedByFolder.hashCode ^
        query.hashCode;
  }
}
