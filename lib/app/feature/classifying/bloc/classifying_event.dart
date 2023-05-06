abstract class ClassifyingEvent {}

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
