import 'dart:convert';

import 'package:classfrase_bloc/app/core/models/user_profile_model.dart';

class LearnModel {
  final String? id;
  final UserProfileModel userProfile;
  final UserProfileModel person;
  LearnModel({
    this.id,
    required this.userProfile,
    required this.person,
  });

  LearnModel copyWith({
    String? id,
    UserProfileModel? userProfile,
    UserProfileModel? person,
  }) {
    return LearnModel(
      id: id ?? this.id,
      userProfile: userProfile ?? this.userProfile,
      person: person ?? this.person,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    result.addAll({'userProfile': userProfile.toMap()});
    result.addAll({'person': person.toMap()});

    return result;
  }

  factory LearnModel.fromMap(Map<String, dynamic> map) {
    return LearnModel(
      id: map['id'],
      userProfile: UserProfileModel.fromMap(map['userProfile']),
      person: UserProfileModel.fromMap(map['person']),
    );
  }

  String toJson() => json.encode(toMap());

  factory LearnModel.fromJson(String source) =>
      LearnModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'LearnModel(id: $id, userProfile: $userProfile, person: $person)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LearnModel &&
        other.id == id &&
        other.userProfile == userProfile &&
        other.person == person;
  }

  @override
  int get hashCode => id.hashCode ^ userProfile.hashCode ^ person.hashCode;
}
