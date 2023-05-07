
abstract class LearnSaveEvent {}


class LearnSaveEventFormSubmitted extends LearnSaveEvent {
  final String email;
  LearnSaveEventFormSubmitted(this.email);
}
