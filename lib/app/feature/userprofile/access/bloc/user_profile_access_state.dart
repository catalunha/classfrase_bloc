import 'package:flutter/foundation.dart';

import '../../../../core/models/user_profile_model.dart';

enum UserProfileAccessStateStatus { initial, updated, loading, success, error }

class UserProfileAccessState {
  final UserProfileAccessStateStatus status;
  final String? error;
  final List<String> access;
  final UserProfileModel model;

  UserProfileAccessState({
    required this.status,
    this.error,
    required this.access,
    required this.model,
  });
  UserProfileAccessState.initial(this.model)
      : status = UserProfileAccessStateStatus.initial,
        error = '',
        access = model.access;

  UserProfileAccessState copyWith({
    UserProfileAccessStateStatus? status,
    String? error,
    List<String>? access,
    UserProfileModel? model,
  }) {
    return UserProfileAccessState(
      status: status ?? this.status,
      error: error ?? this.error,
      access: access ?? this.access,
      model: model ?? this.model,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfileAccessState &&
        other.status == status &&
        other.error == error &&
        listEquals(other.access, access) &&
        other.model == model;
  }

  @override
  int get hashCode {
    return status.hashCode ^ error.hashCode ^ access.hashCode ^ model.hashCode;
  }

  @override
  String toString() {
    return 'UserProfileAccessState(status: $status, error: $error, access: $access, model: $model)';
  }
}
