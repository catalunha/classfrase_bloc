import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../data/b4a/table/learn_b4a.dart';
import '../../data/utils/pagination.dart';
import '../models/learn_model.dart';

class LearnRepository {
  final LearnB4a apiB4a = LearnB4a();
  LearnRepository();
  Future<List<LearnModel>> list(
    QueryBuilder<ParseObject> query,
    Pagination pagination, [
    List<String> cols = const [],
  ]) =>
      apiB4a.list(query, pagination, cols);
  // Future<List<LearnModel>> listThisPerson(String personId) =>
  //     apiB4a.listThisPerson(personId);
  Future<String> update(LearnModel model) => apiB4a.update(model);
  Future<bool> delete(String modelId) => apiB4a.delete(modelId);
  // Future<LearnModel?> readById(String id, [List<String> cols = const []]) =>
  //     apiB4a.readById(id, cols);
  // Future<void> updateIsArchive(String id, bool mode) =>
  //     apiB4a.updateIsArchive(id, mode);
  // Future<void> updateClassOrder(String id, List<String> classOrder) =>
  //     apiB4a.updateClassOrder(id, classOrder);
  // Future<void> updateClassification(
  //         String id,
  //         Map<String, Classification> classifications,
  //         List<String> classOrder) =>
  //     apiB4a.updateClassification(id, classifications, classOrder);
}
