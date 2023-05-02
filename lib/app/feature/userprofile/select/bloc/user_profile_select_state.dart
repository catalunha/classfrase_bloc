import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/user_profile_model.dart';
import '../../../../data/b4a/entity/user_profile_entity.dart';

enum UserProfileSelectStateStatus { initial, loading, success, error }

class UserProfileSelectState {
  final UserProfileSelectStateStatus status;
  final String? error;
  final List<UserProfileModel> list;
  final List<UserProfileModel> listFiltered;
  final int page;
  final int limit;
  final bool firstPage;
  final bool lastPage;
  QueryBuilder<ParseObject> query;
  final List<UserProfileModel> selectedValues;
  final bool isSingleValue;
  UserProfileSelectState({
    required this.status,
    this.error,
    required this.list,
    required this.listFiltered,
    required this.page,
    required this.limit,
    required this.firstPage,
    required this.lastPage,
    required this.query,
    required this.selectedValues,
    required this.isSingleValue,
  });
  UserProfileSelectState.initial(this.isSingleValue)
      : status = UserProfileSelectStateStatus.initial,
        error = '',
        list = [],
        listFiltered = [],
        page = 1,
        limit = 20,
        firstPage = true,
        lastPage = false,
        query =
            QueryBuilder<ParseObject>(ParseObject(UserProfileEntity.className)),
        selectedValues = const [];

  UserProfileSelectState copyWith({
    UserProfileSelectStateStatus? status,
    String? error,
    List<UserProfileModel>? list,
    List<UserProfileModel>? listFiltered,
    int? page,
    int? limit,
    bool? firstPage,
    bool? lastPage,
    QueryBuilder<ParseObject>? query,
    List<UserProfileModel>? selectedValues,
    bool? isSingleValue,
  }) {
    return UserProfileSelectState(
      status: status ?? this.status,
      error: error ?? this.error,
      list: list ?? this.list,
      listFiltered: listFiltered ?? this.listFiltered,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      firstPage: firstPage ?? this.firstPage,
      lastPage: lastPage ?? this.lastPage,
      query: query ?? this.query,
      selectedValues: selectedValues ?? this.selectedValues,
      isSingleValue: isSingleValue ?? this.isSingleValue,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfileSelectState &&
        other.status == status &&
        other.error == error &&
        listEquals(other.list, list) &&
        listEquals(other.listFiltered, listFiltered) &&
        other.page == page &&
        other.limit == limit &&
        other.firstPage == firstPage &&
        other.lastPage == lastPage &&
        other.query == query &&
        listEquals(other.selectedValues, selectedValues) &&
        other.isSingleValue == isSingleValue;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        list.hashCode ^
        listFiltered.hashCode ^
        page.hashCode ^
        limit.hashCode ^
        firstPage.hashCode ^
        lastPage.hashCode ^
        query.hashCode ^
        selectedValues.hashCode ^
        isSingleValue.hashCode;
  }

  @override
  String toString() {
    return 'UserProfileSelectState(status: $status, error: $error, list: $list, listFiltered: $listFiltered, page: $page, limit: $limit, firstPage: $firstPage, lastPage: $lastPage, query: $query, selectedValues: $selectedValues, isSingleValue: $isSingleValue)';
  }
}
