import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/phrase_classification_model.dart';
import '../../../core/models/phrase_model.dart';
import 'user_profile_entity.dart';

class PhraseEntity {
  static const String className = 'Phrase';
  static const String id = 'objectId';
  static const String name = 'name';
  static const String phrase = 'phrase';
  static const String phraseList = 'phraseList';
  static const String classifications = 'classifications';
  static const String classOrder = 'classOrder';
  static const String allCategoryList = 'allCategoryList';
  static const String folder = 'folder';
  static const String font = 'font';
  static const String diagramUrl = 'diagramUrl';
  static const String note = 'note';
  static const String isArchived = 'isArchived';
  static const String isPublic = 'isPublic';

  static const String userProfile = 'userProfile';

  static List<String> selectedCols(List<String> cols) {
    return cols.map((e) => '${PhraseEntity.className}.$e').toList();
  }

  static final List<String> singleCols = [
    PhraseEntity.name,
    PhraseEntity.phrase,
    PhraseEntity.phraseList,
    PhraseEntity.classifications,
    PhraseEntity.classOrder,
    PhraseEntity.allCategoryList,
    PhraseEntity.folder,
    PhraseEntity.font,
    PhraseEntity.diagramUrl,
    PhraseEntity.note,
    PhraseEntity.isArchived,
    PhraseEntity.isPublic,
  ].map((e) => '${PhraseEntity.className}.$e').toList();

  static final List<String> pointerCols = [
    PhraseEntity.userProfile,
  ].map((e) => '${PhraseEntity.className}.$e').toList();

  static final List<String> relationCols =
      [].map((e) => '${PhraseEntity.className}.$e').toList();

  static List<String> filterSingleCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (PhraseEntity.singleCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${PhraseEntity.className}.', ''))
        .toList();
  }

  static List<String> filterPointerCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (PhraseEntity.pointerCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${PhraseEntity.className}.', ''))
        .toList();
  }

  static List<String> filterRelationCols(List<String> cols) {
    List<String> temp = [];
    for (var col in cols) {
      if (PhraseEntity.relationCols.contains(col)) {
        temp.add(col);
      }
    }
    return temp
        .map((e) => e.replaceFirst('${PhraseEntity.className}.', ''))
        .toList();
  }

  PhraseModel toModel(ParseObject parseObject, [List<String> cols = const []]) {
    print('PhraseModel.toModel: 1');
    Map<String, Classification>? classifications = <String, Classification>{};
    Map<String, dynamic>? tempClass =
        parseObject.get<Map<String, dynamic>>(PhraseEntity.classifications);
    if (tempClass != null) {
      for (var item in tempClass.entries) {
        classifications[item.key] = Classification.fromMap(item.value);
      }
    }
    print('PhraseModel.toModel: 2');
    print(
        'PhraseModel.toModel.phrase: ${parseObject.get<String>(PhraseEntity.phrase)}');
    print('PhraseModel.toModel: ${parseObject.get(PhraseEntity.userProfile)}');

    PhraseModel model = PhraseModel(
      id: parseObject.objectId!,
      userProfile: UserProfileEntity()
          .toModel(parseObject.get(PhraseEntity.userProfile)),
      phrase: parseObject.get<String>(PhraseEntity.phrase)!,
      phraseList: parseObject
          .get<List<dynamic>>(PhraseEntity.phraseList)!
          .map((e) => e.toString())
          .toList(),
      classifications: classifications,
      classOrder: parseObject
          .get<List<dynamic>>(PhraseEntity.classOrder)!
          .map((e) => e.toString())
          .toList(),
      folder: parseObject.get<String>(PhraseEntity.folder) ?? '/',
      font: parseObject.get<String>(PhraseEntity.font),
      diagramUrl: parseObject.get<String>(PhraseEntity.diagramUrl),
      note: parseObject.get<String>(PhraseEntity.note),
      isArchived: parseObject.get<bool>(PhraseEntity.isArchived) ?? false,
      isPublic: parseObject.get<bool>(PhraseEntity.isPublic) ?? false,
    );
    return model;
  }

  Future<ParseObject> toParse(PhraseModel model) async {
    final parseObject = ParseObject(PhraseEntity.className);
    parseObject.objectId = model.id;

    parseObject.set(
        PhraseEntity.userProfile,
        (ParseObject(UserProfileEntity.className)
              ..objectId = model.userProfile.id)
            .toPointer());
    parseObject.set(PhraseEntity.phrase, model.phrase);
    parseObject.set(PhraseEntity.phraseList, model.phraseList);
    var data = <String, dynamic>{};
    for (var item in model.classifications.entries) {
      data[item.key] = item.value.toMap();
    }
    parseObject.set(PhraseEntity.classifications, data);
    parseObject.set(PhraseEntity.classOrder, model.classOrder);
    parseObject.set(PhraseEntity.folder, model.folder);
    parseObject.set(PhraseEntity.font, model.font);
    parseObject.set(PhraseEntity.folder, model.folder);
    parseObject.set(PhraseEntity.diagramUrl, model.diagramUrl);
    parseObject.set(PhraseEntity.note, model.note);
    parseObject.set(PhraseEntity.isArchived, model.isArchived);
    parseObject.set(PhraseEntity.isPublic, model.isPublic);

    return parseObject;
  }
}
