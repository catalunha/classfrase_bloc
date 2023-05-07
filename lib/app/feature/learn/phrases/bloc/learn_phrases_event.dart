abstract class LearnPhrasesEvent {}

class LearnPhrasesEventStart extends LearnPhrasesEvent {}

class LearnPhrasesEventSortAlpha extends LearnPhrasesEvent {}

class LearnPhrasesEventSortFolder extends LearnPhrasesEvent {}

class LearnPhrasesEventOnMarkCategoryIfAlreadyClassifiedInPos
    extends LearnPhrasesEvent {}

class LearnPhrasesEventFilterPhasesByThisCategory extends LearnPhrasesEvent {
  final String catClassId;
  LearnPhrasesEventFilterPhasesByThisCategory(
    this.catClassId,
  );
}

class LearnPhrasesEventFilterRemoved extends LearnPhrasesEvent {}
