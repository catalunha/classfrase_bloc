import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/phrase_classification_model.dart';
import '../../../core/models/phrase_model.dart';
import '../../utils/pagination.dart';
import '../b4a_exception.dart';
import '../entity/phrase_entity.dart';
import '../utils/parse_error_translate.dart';

class PhraseB4a {
  Future<QueryBuilder<ParseObject>> getQueryAll(
      QueryBuilder<ParseObject> query, Pagination pagination,
      [List<String> cols = const []]) async {
    query.setAmountToSkip((pagination.page - 1) * pagination.limit);
    query.setLimit(pagination.limit);
    query.keysToReturn([
      ...PhraseEntity.filterSingleCols(cols),
      ...PhraseEntity.filterPointerCols(cols),
      ...PhraseEntity.filterRelationCols(cols),
    ]);
    query.includeObject(PhraseEntity.filterPointerCols(cols));

    return query;
  }

  Future<List<PhraseModel>> list(
      QueryBuilder<ParseObject> query, Pagination pagination,
      [List<String> cols = const []]) async {
    QueryBuilder<ParseObject> query2;
    query2 = await getQueryAll(query, pagination, cols);
    ParseResponse? parseResponse;
    try {
      parseResponse = await query2.query();
      List<PhraseModel> listTemp = <PhraseModel>[];
      if (parseResponse.success && parseResponse.results != null) {
        for (var element in parseResponse.results!) {
          listTemp.add(PhraseEntity().toModel(element, cols));
        }
        return listTemp;
      } else {
        return [];
      }
    } on Exception {
      var errorTranslated =
          ParseErrorTranslate.translate(parseResponse!.error!);
      throw B4aException(
        errorTranslated,
        where: 'PhraseRepositoryB4a.list',
        originalError:
            '${parseResponse.error!.code} -${parseResponse.error!.message}',
      );
    }
  }

  Future<List<PhraseModel>> listThisPerson(String personId) async {
    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject(PhraseEntity.className));
    query.whereEqualTo('userProfile', personId);

    query.whereEqualTo('isPublic', true);
    query.orderByAscending('folder');
    query.includeObject(['userProfile']);

    final ParseResponse response = await query.query();
    List<PhraseModel> listTemp = <PhraseModel>[];
    if (response.success && response.results != null) {
      for (var element in response.results!) {
        //print(element as ParseObject).objectId);
        listTemp.add(PhraseEntity().toModel(element));
      }
      return listTemp;
    } else {
      //print'Sem Phrases this person $personId...');
      return [];
    }
  }

  Future<PhraseModel?> readById(String id,
      [List<String> cols = const []]) async {
    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject(PhraseEntity.className));
    query.whereEqualTo(PhraseEntity.id, id);
    query.keysToReturn([
      ...PhraseEntity.filterSingleCols(cols),
    ]);
    query.includeObject(PhraseEntity.filterPointerCols(cols));
    query.first();
    try {
      var response = await query.query();

      if (response.success && response.results != null) {
        return PhraseEntity().toModel(response.results!.first, cols);
      }
      throw B4aException(
        'Perfil do usuário não encontrado.',
        where: 'PhraseRepositoryB4a.readById()',
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<String> update(PhraseModel model) async {
    final parseObject = await PhraseEntity().toParse(model);
    ParseResponse? parseResponse;
    try {
      parseResponse = await parseObject.save();

      if (parseResponse.success && parseResponse.results != null) {
        ParseObject parseObjectItem =
            parseResponse.results!.first as ParseObject;
        return parseObjectItem.objectId!;
      } else {
        throw Exception();
      }
    } on Exception {
      var errorTranslated =
          ParseErrorTranslate.translate(parseResponse!.error!);
      throw B4aException(
        errorTranslated,
        where: 'PhraseRepositoryB4a.update',
        originalError:
            '${parseResponse.error!.code} -${parseResponse.error!.message}',
      );
    }
  }

  Future<void> updateIsArchive(String id, bool mode) async {
    var parseObject = ParseObject(PhraseEntity.className)..objectId = id;
    parseObject.set('isArchived', mode);
    await parseObject.save();
  }

  Future<void> updateClassOrder(String id, List<String> classOrder) async {
    var parseObject = ParseObject(PhraseEntity.className)..objectId = id;
    parseObject.set('classOrder', classOrder);
    await parseObject.save();
  }

  Future<void> updateClassification(
      String id,
      Map<String, Classification> classifications,
      List<String> classOrder) async {
    var parseObject = ParseObject(PhraseEntity.className)..objectId = id;
    var data = <String, dynamic>{};
    for (var item in classifications.entries) {
      data[item.key] = item.value.toMap();
    }
    parseObject.set('classifications', data);
    parseObject.set('classOrder', classOrder);
    await parseObject.save();
  }

  Future<bool> delete(String modelId) async {
    final parseObject = ParseObject(PhraseEntity.className);
    parseObject.objectId = modelId;
    ParseResponse? parseResponse;

    try {
      parseResponse = await parseObject.delete();
      if (parseResponse.success && parseResponse.results != null) {
        return true;
      } else {
        return false;
      }
    } on Exception {
      var errorTranslated =
          ParseErrorTranslate.translate(parseResponse!.error!);
      throw B4aException(
        errorTranslated,
        where: 'PhraseRepositoryB4a.delete',
        originalError:
            '${parseResponse.error!.code} -${parseResponse.error!.message}',
      );
    }
  }
}
