import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserProfileModel {
  final String id;
  final String email;
  final bool isActive;
  final List<String> access;

  final String? name;
  final String? phone;
  final String? photo;
  final String? description;
  final String? community;
  UserProfileModel({
    required this.id,
    required this.email,
    required this.isActive,
    required this.access,
    this.name,
    this.phone,
    this.photo,
    this.description,
    this.community,
  });

  UserProfileModel copyWith({
    String? id,
    String? email,
    bool? isActive,
    List<String>? access,
    String? name,
    String? phone,
    String? photo,
    String? description,
    String? community,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      access: access ?? this.access,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      description: description ?? this.description,
      community: community ?? this.community,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'email': email});
    result.addAll({'isActive': isActive});
    result.addAll({'access': access});
    if (name != null) {
      result.addAll({'name': name});
    }
    if (phone != null) {
      result.addAll({'phone': phone});
    }
    if (photo != null) {
      result.addAll({'photo': photo});
    }
    if (description != null) {
      result.addAll({'description': description});
    }
    if (community != null) {
      result.addAll({'community': community});
    }

    return result;
  }

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      isActive: map['isActive'] ?? false,
      access: List<String>.from(map['access']),
      name: map['name'],
      phone: map['phone'],
      photo: map['photo'],
      description: map['description'],
      community: map['community'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfileModel.fromJson(String source) =>
      UserProfileModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserProfileModel(id: $id, email: $email, isActive: $isActive, access: $access, name: $name, phone: $phone, photo: $photo, description: $description, community: $community)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfileModel &&
        other.id == id &&
        other.email == email &&
        other.isActive == isActive &&
        listEquals(other.access, access) &&
        other.name == name &&
        other.phone == phone &&
        other.photo == photo &&
        other.description == description &&
        other.community == community;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        isActive.hashCode ^
        access.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        photo.hashCode ^
        description.hashCode ^
        community.hashCode;
  }
}
