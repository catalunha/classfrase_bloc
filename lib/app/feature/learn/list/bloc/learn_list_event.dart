import '../../../../core/models/learn_model.dart';

abstract class LearnListEvent {}

class LearnListEventStart extends LearnListEvent {}

class LearnListEventUpdateList extends LearnListEvent {
  final LearnModel? model;
  LearnListEventUpdateList(
    this.model,
  );
}

class LearnListEventRemoveFromList extends LearnListEvent {
  final String id;
  LearnListEventRemoveFromList(
    this.id,
  );
}

class LearnListEventDelete extends LearnListEvent {
  final String id;
  LearnListEventDelete(this.id);
}
