import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../data/b4a/table/phrase_b4a.dart';
import '../../data/utils/pagination.dart';
import '../models/phrase_classification_model.dart';
import '../models/phrase_model.dart';

class PhraseRepository {
  final PhraseB4a phraseB4a = PhraseB4a();
  PhraseRepository();
  Future<List<PhraseModel>> list(
    QueryBuilder<ParseObject> query,
    Pagination pagination, [
    List<String> cols = const [],
  ]) =>
      phraseB4a.list(query, pagination, cols);
  Future<List<PhraseModel>> listThisPerson(String personId) =>
      phraseB4a.listThisPerson(personId);
  Future<String> update(PhraseModel model) => phraseB4a.update(model);
  Future<bool> delete(String modelId) => phraseB4a.delete(modelId);
  Future<PhraseModel?> readById(String id, [List<String> cols = const []]) =>
      phraseB4a.readById(id, cols);
  Future<void> updateIsArchive(String id, bool mode) =>
      phraseB4a.updateIsArchive(id, mode);
  Future<void> updateClassOrder(String id, List<String> classOrder) =>
      phraseB4a.updateClassOrder(id, classOrder);
  Future<void> updateClassification(
          String id,
          Map<String, Classification> classifications,
          List<String> classOrder) =>
      phraseB4a.updateClassification(id, classifications, classOrder);
}
