import 'package:image_picker/image_picker.dart';

import '../../../../core/models/user_model.dart';

enum UserProfileSaveStateStatus { initial, updated, loading, success, error }

class UserProfileSaveState {
  final UserProfileSaveStateStatus status;
  final String? error;
  final UserModel user;
  final XFile? xfile;

  UserProfileSaveState({
    required this.status,
    this.error,
    required this.user,
    this.xfile,
  });

  UserProfileSaveState.initial(this.user)
      : status = UserProfileSaveStateStatus.initial,
        error = '',
        xfile = null;

  UserProfileSaveState copyWith({
    UserProfileSaveStateStatus? status,
    String? error,
    UserModel? user,
    XFile? xfile,
  }) {
    return UserProfileSaveState(
      status: status ?? this.status,
      error: error ?? this.error,
      user: user ?? this.user,
      xfile: xfile ?? this.xfile,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfileSaveState &&
        other.status == status &&
        other.error == error &&
        other.user == user &&
        other.xfile == xfile;
  }

  @override
  int get hashCode {
    return status.hashCode ^ error.hashCode ^ user.hashCode ^ xfile.hashCode;
  }

  @override
  String toString() {
    return 'UserProfileSaveState(status: $status, error: $error, user: $user, xfile: $xfile)';
  }
}
