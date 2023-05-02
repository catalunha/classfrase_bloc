import 'package:image_picker/image_picker.dart';

abstract class UserProfileSaveEvent {}

class UserProfileSaveEventSendXFile extends UserProfileSaveEvent {
  final XFile? xfile;
  UserProfileSaveEventSendXFile({
    required this.xfile,
  });
}

class UserProfileSaveEventFormSubmitted extends UserProfileSaveEvent {
  final String? name;
  final String? phone;
  final String? description;
  final String? community;
  UserProfileSaveEventFormSubmitted({
    this.name,
    this.phone,
    this.description,
    this.community,
  });
}
