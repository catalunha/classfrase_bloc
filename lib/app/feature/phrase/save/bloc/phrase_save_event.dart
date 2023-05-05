abstract class PhraseSaveEvent {}

class PhraseSaveEventDelete extends PhraseSaveEvent {}

class PhraseSaveEventFormSubmitted extends PhraseSaveEvent {
  final String phrase;
  final String folder;
  final String? font;
  final String? diagramUrl;
  final String? note;
  final bool isPublic;
  PhraseSaveEventFormSubmitted({
    required this.phrase,
    required this.folder,
    this.font,
    this.diagramUrl,
    this.note,
    this.isPublic = false,
  });
}
