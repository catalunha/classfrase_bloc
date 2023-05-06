abstract class ClassifyingEvent {}

class ClassifyingEventStart extends ClassifyingEvent {}

class ClassifyingEventOnSelectPhrase extends ClassifyingEvent {
  final int phrasePos;
  ClassifyingEventOnSelectPhrase({
    required this.phrasePos,
  });
}

class ClassifyingEventOnSelectAllPhrase extends ClassifyingEvent {}

class ClassifyingEventOnSelectClearPhrase extends ClassifyingEvent {}

class ClassifyingEventOnSelectInversePhrase extends ClassifyingEvent {}

class ClassifyingEventOnChangeClassOrder extends ClassifyingEvent {
  final List<String> classOrder;
  ClassifyingEventOnChangeClassOrder({
    required this.classOrder,
  });
}

class ClassifyingEventOnMarkCategoryIfAlreadyClassifiedInPos
    extends ClassifyingEvent {}

class ClassifyingEventOnSelectCategory extends ClassifyingEvent {
  final String categoryId;
  ClassifyingEventOnSelectCategory(this.categoryId);
}

class ClassifyingEventOnSaveClassification extends ClassifyingEvent {}
