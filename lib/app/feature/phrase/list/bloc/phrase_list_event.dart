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
