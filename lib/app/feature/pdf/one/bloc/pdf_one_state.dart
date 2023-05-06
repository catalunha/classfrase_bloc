import '../../../../core/models/phrase_model.dart';

enum PdfOneStateStatus { initial, updated, loading, success, error }

class PdfOneState {
  final PdfOneStateStatus status;
  final String? error;
  final PhraseModel model;
  PdfOneState({
    required this.status,
    this.error,
    required this.model,
  });
  PdfOneState.initial(this.model)
      : status = PdfOneStateStatus.initial,
        error = '';
  PdfOneState copyWith({
    PdfOneStateStatus? status,
    String? error,
    PhraseModel? model,
  }) {
    return PdfOneState(
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
    );
  }

  @override
  String toString() =>
      'PdfOneState(status: $status, error: $error, model: $model)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PdfOneState &&
        other.status == status &&
        other.error == error &&
        other.model == model;
  }

  @override
  int get hashCode => status.hashCode ^ error.hashCode ^ model.hashCode;
}
