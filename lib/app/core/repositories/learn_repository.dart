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

  Future<String> update(LearnModel model) => apiB4a.update(model);
  Future<bool> delete(String modelId) => apiB4a.delete(modelId);
}
