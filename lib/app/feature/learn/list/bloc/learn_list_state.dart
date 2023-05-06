import 'package:flutter/foundation.dart';

import '../../../../core/models/learn_model.dart';

enum LearnListStateStatus { initial, loading, success, error }

class LearnListState {
  final LearnListStateStatus status;
  final String? error;
  final List<LearnModel> list;
  LearnListState({
    required this.status,
    this.error,
    required this.list,
  });
  LearnListState.initial()
      : status = LearnListStateStatus.initial,
        error = '',
        list = [];
  LearnListState copyWith({
    LearnListStateStatus? status,
    String? error,
    List<LearnModel>? list,
  }) {
    return LearnListState(
      status: status ?? this.status,
      error: error ?? this.error,
      list: list ?? this.list,
    );
  }

  @override
  String toString() =>
      'LearnListState(status: $status, error: $error, list: $list)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LearnListState &&
        other.status == status &&
        other.error == error &&
        listEquals(other.list, list);
  }

  @override
  int get hashCode => status.hashCode ^ error.hashCode ^ list.hashCode;
}
