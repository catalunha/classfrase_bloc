abstract class UserProfileAccessEvent {}

class UserProfileAccessEventStart extends UserProfileAccessEvent {}

class UserProfileAccessEventFormSubmitted extends UserProfileAccessEvent {
  final bool isActive;
  UserProfileAccessEventFormSubmitted({
    required this.isActive,
  });
}

class UserProfileAccessEventUpdateAccess extends UserProfileAccessEvent {
  final String access;
  UserProfileAccessEventUpdateAccess({
    required this.access,
  });
}
