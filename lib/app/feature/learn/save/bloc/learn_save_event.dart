abstract class LearnSaveEvent {}

class LearnSaveEventDelete extends LearnSaveEvent {
  final String id;
  LearnSaveEventDelete(this.id);
}

class LearnSaveEventFormSubmitted extends LearnSaveEvent {
  final String email;
  LearnSaveEventFormSubmitted(this.email);
}
