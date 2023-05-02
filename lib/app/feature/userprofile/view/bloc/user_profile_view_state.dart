import '../../../../core/models/user_profile_model.dart';

enum UserProfileViewStateStatus { initial, updated, loading, success, error }

class UserProfileViewState {
  final UserProfileViewStateStatus status;
  final String? error;
  final UserProfileModel model;
  UserProfileViewState({
    required this.status,
    this.error,
    required this.model,
  });
  UserProfileViewState.initial(this.model)
      : status = UserProfileViewStateStatus.initial,
        error = '';

  UserProfileViewState copyWith({
    UserProfileViewStateStatus? status,
    String? error,
    UserProfileModel? model,
  }) {
    return UserProfileViewState(
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
    );
  }

  @override
  String toString() =>
      'UserProfileViewState(status: $status, error: $error, model: $model)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfileViewState &&
        other.status == status &&
        other.error == error &&
        other.model == model;
  }

  @override
  int get hashCode => status.hashCode ^ error.hashCode ^ model.hashCode;
}
