import '../../../../core/models/user_profile_model.dart';

abstract class UserProfileSearchEvent {}

class UserProfileSearchEventNextPage extends UserProfileSearchEvent {}

class UserProfileSearchEventPreviousPage extends UserProfileSearchEvent {}

class UserProfileSearchEventUpdateList extends UserProfileSearchEvent {
  final UserProfileModel userProfileModel;
  UserProfileSearchEventUpdateList(
    this.userProfileModel,
  );
}

class UserProfileSearchEventFormSubmitted extends UserProfileSearchEvent {
  final bool nameContainsBool;
  final String nameContainsString;
  final bool cpfEqualToBool;
  final String cpfEqualToString;
  final bool phoneEqualToBool;
  final String phoneEqualToString;
  UserProfileSearchEventFormSubmitted({
    required this.nameContainsBool,
    required this.nameContainsString,
    required this.cpfEqualToBool,
    required this.cpfEqualToString,
    required this.phoneEqualToBool,
    required this.phoneEqualToString,
  });
}
