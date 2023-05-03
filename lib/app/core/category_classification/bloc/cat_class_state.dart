import 'package:flutter/foundation.dart';

import '../../models/catclass_model.dart';

enum CatClassStateStatus { initial, loading, success, error }

class CatClassState {
  final CatClassStateStatus status;
  final String? error;
  final List<CatClassModel> categoryAll;
  final List<CatClassModel> category;
  final String selectedFilter;
  CatClassState({
    required this.status,
    this.error,
    required this.categoryAll,
    required this.category,
    required this.selectedFilter,
  });
  CatClassState.initial()
      : status = CatClassStateStatus.initial,
        error = '',
        categoryAll = [],
        category = [],
        selectedFilter = 'ngb';

  CatClassState copyWith({
    CatClassStateStatus? status,
    String? error,
    List<CatClassModel>? categoryAll,
    List<CatClassModel>? category,
    String? selectedFilter,
  }) {
    return CatClassState(
      status: status ?? this.status,
      error: error ?? this.error,
      categoryAll: categoryAll ?? this.categoryAll,
      category: category ?? this.category,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  @override
  String toString() {
    return 'CatClassState(status: $status, error: $error, categoryAll: $categoryAll, category: $category, selectedFilter: $selectedFilter)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CatClassState &&
        other.status == status &&
        other.error == error &&
        listEquals(other.categoryAll, categoryAll) &&
        listEquals(other.category, category) &&
        other.selectedFilter == selectedFilter;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        categoryAll.hashCode ^
        category.hashCode ^
        selectedFilter.hashCode;
  }
}
