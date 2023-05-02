import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/user_profile_model.dart';
import '../../../../data/b4a/entity/user_profile_entity.dart';

enum UserProfileSearchStateStatus { initial, loading, success, error }

class UserProfileSearchState {
  final UserProfileSearchStateStatus status;
  final String? error;
  final List<UserProfileModel> list;
  final int page;
  final int limit;
  final bool firstPage;
  final bool lastPage;
  QueryBuilder<ParseObject> query;
  UserProfileSearchState({
    required this.status,
    this.error,
    required this.list,
    required this.page,
    required this.limit,
    required this.lastPage,
    required this.firstPage,
    required this.query,
  });

  UserProfileSearchState.initial()
      : status = UserProfileSearchStateStatus.initial,
        error = '',
        list = [],
        page = 1,
        limit = 20,
        firstPage = true,
        lastPage = false,
        query =
            QueryBuilder<ParseObject>(ParseObject(UserProfileEntity.className));

  UserProfileSearchState copyWith({
    UserProfileSearchStateStatus? status,
    String? error,
    List<UserProfileModel>? list,
    int? page,
    int? limit,
    bool? lastPage,
    bool? firstPage,
    QueryBuilder<ParseObject>? query,
  }) {
    return UserProfileSearchState(
      status: status ?? this.status,
      error: error ?? this.error,
      list: list ?? this.list,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      lastPage: lastPage ?? this.lastPage,
      firstPage: firstPage ?? this.firstPage,
      query: query ?? this.query,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfileSearchState &&
        other.status == status &&
        other.error == error &&
        listEquals(other.list, list) &&
        other.page == page &&
        other.limit == limit &&
        other.lastPage == lastPage &&
        other.firstPage == firstPage &&
        other.query == query;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        list.hashCode ^
        page.hashCode ^
        limit.hashCode ^
        lastPage.hashCode ^
        firstPage.hashCode ^
        query.hashCode;
  }
}
