import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/user_profile_model.dart';

class UserProfileEntity {
  static const String className = 'UserProfile';

  static const String id = 'objectId';
  static const String email = 'email';
  static const String isActive = 'isActive';
  static const String access = 'access';

  static const String name = 'name';
  static const String phone = 'phone';
  static const String photo = 'photo';

  static const String description = 'description';
  static const String community = 'community';

  static List<String> selectedCols(List<String> cols) {
    return cols.map((e) => '${UserProfileEntity.className}.$e').toList();
  }

  static final List<String> singleCols = [
    UserProfileEntity.email,
    UserProfileEntity.isActive,
    UserProfileEntity.access,
    UserProfileEntity.name,
    UserProfileEntity.phone,
    UserProfileEntity.photo,
    UserProfileEntity.description,
    UserProfileEntity.community,
  ].map((e) => '${UserProfileEntity.className}.$e').toList();
  static final List<String> pointerCols =
      [].map((e) => '${UserProfileEntity.className}.$e').toList();

  static final List<String> relationCols =
      [].map((e) => '${UserProfileEntity.className}.$e').toList();

  static List<String> filterSingleCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (UserProfileEntity.singleCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${UserProfileEntity.className}.', ''))
        .toList();
  }

  static List<String> filterPointerCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (UserProfileEntity.pointerCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${UserProfileEntity.className}.', ''))
        .toList();
  }

  static List<String> filterRelationCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (UserProfileEntity.relationCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${UserProfileEntity.className}.', ''))
        .toList();
  }

  Future<UserProfileModel> toModel(
    ParseObject parseObject, [
    List<String> cols = const [],
  ]) async {
    UserProfileModel model = UserProfileModel(
      id: parseObject.objectId!,
      email: parseObject.get(UserProfileEntity.email),
      name: parseObject.get(UserProfileEntity.name),
      phone: parseObject.get(UserProfileEntity.phone),
      photo: parseObject.get(UserProfileEntity.photo)?.get('url'),
      isActive: parseObject.get(UserProfileEntity.isActive),
      access: parseObject.get<List<dynamic>>(UserProfileEntity.access) != null
          ? parseObject
              .get<List<dynamic>>(UserProfileEntity.access)!
              .map((e) => e.toString())
              .toList()
          : [],
      description: parseObject.get(UserProfileEntity.description),
      community: parseObject.get(UserProfileEntity.community),
    );
    return model;
  }

  Future<ParseObject> toParse(UserProfileModel model) async {
    final parseObject = ParseObject(UserProfileEntity.className);
    parseObject.objectId = model.id;

    if (model.name != null) {
      parseObject.set(UserProfileEntity.name, model.name);
    }
    if (model.phone != null) {
      parseObject.set(UserProfileEntity.phone, model.phone);
    }
    if (model.description != null) {
      parseObject.set(UserProfileEntity.description, model.description);
    }
    if (model.community != null) {
      parseObject.set(UserProfileEntity.community, model.community);
    }
    parseObject.set(UserProfileEntity.access, model.access);
    parseObject.set(UserProfileEntity.isActive, model.isActive);
    return parseObject;
  }
}
