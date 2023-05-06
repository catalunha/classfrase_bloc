import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/learn_model.dart';
import 'user_profile_entity.dart';

class LearnEntity {
  static const String className = 'Learn';
  static const String id = 'objectId';
  static const String userProfile = 'userProfile';
  static const String person = 'person';

  static List<String> selectedCols(List<String> cols) {
    return cols.map((e) => '${LearnEntity.className}.$e').toList();
  }

  static final List<String> singleCols =
      [].map((e) => '${LearnEntity.className}.$e').toList();

  static final List<String> pointerCols = [
    LearnEntity.userProfile,
    LearnEntity.person,
  ].map((e) => '${LearnEntity.className}.$e').toList();

  static final List<String> relationCols =
      [].map((e) => '${LearnEntity.className}.$e').toList();

  static List<String> filterSingleCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (LearnEntity.singleCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${LearnEntity.className}.', ''))
        .toList();
  }

  static List<String> filterPointerCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (LearnEntity.pointerCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${LearnEntity.className}.', ''))
        .toList();
  }

  static List<String> filterRelationCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (LearnEntity.relationCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${LearnEntity.className}.', ''))
        .toList();
  }

  LearnModel toModel(ParseObject parseObject, [List<String> cols = const []]) {
    LearnModel model = LearnModel(
      id: parseObject.objectId!,
      userProfile:
          UserProfileEntity().toModel(parseObject.get(LearnEntity.userProfile)),
      person: UserProfileEntity().toModel(parseObject.get(LearnEntity.person)),
    );
    return model;
  }

  Future<ParseObject> toParse(LearnModel model) async {
    final parseObject = ParseObject(LearnEntity.className);
    parseObject.objectId = model.id;

    parseObject.set(
        LearnEntity.userProfile,
        (ParseObject(UserProfileEntity.className)
              ..objectId = model.userProfile.id)
            .toPointer());
    parseObject.set(
        LearnEntity.person,
        (ParseObject(UserProfileEntity.className)..objectId = model.person.id)
            .toPointer());

    return parseObject;
  }
}
