import '../../../../core/models/phrase_model.dart';

abstract class PhraseListEvent {}

class PhraseListEventStartList extends PhraseListEvent {
  final bool isArchived;
  PhraseListEventStartList({
    this.isArchived = false,
  });
}

class PhraseListEventSortAlpha extends PhraseListEvent {}

class PhraseListEventSortFolder extends PhraseListEvent {}

class PhraseListEventIsArchived extends PhraseListEvent {
  final String phraseId;
  final bool isArchived;
  PhraseListEventIsArchived({
    required this.phraseId,
    required this.isArchived,
  });
}

class PhraseListEventAddToList extends PhraseListEvent {
  final PhraseModel model;
  PhraseListEventAddToList(
    this.model,
  );
}

class PhraseListEventUpdateList extends PhraseListEvent {
  final PhraseModel model;
  PhraseListEventUpdateList(
    this.model,
  );
}

class PhraseListEventRemoveFromList extends PhraseListEvent {
  final String modelId;
  PhraseListEventRemoveFromList(
    this.modelId,
  );
}
