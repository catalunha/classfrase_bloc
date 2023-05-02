import '../../../../core/models/user_profile_model.dart';

abstract class UserProfileSelectEvent {}

class UserProfileSelectEventNextPage extends UserProfileSelectEvent {}

class UserProfileSelectEventPreviousPage extends UserProfileSelectEvent {}

class UserProfileSelectEventStartQuery extends UserProfileSelectEvent {}

class UserProfileSelectEventFormSubmitted extends UserProfileSelectEvent {
  final String name;
  UserProfileSelectEventFormSubmitted(this.name);
}

class UserProfileSelectEventUpdateSelectedValues
    extends UserProfileSelectEvent {
  final UserProfileModel model;
  UserProfileSelectEventUpdateSelectedValues(
    this.model,
  );
}
