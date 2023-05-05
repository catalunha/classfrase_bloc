import '../../../../core/models/phrase_model.dart';

enum PhraseSaveStateStatus { initial, loading, success, error }

class PhraseSaveState {
  final PhraseSaveStateStatus status;
  final String? error;
  final PhraseModel? model;
  PhraseSaveState({
    required this.status,
    this.error,
    this.model,
  });
  PhraseSaveState.initial(this.model)
      : status = PhraseSaveStateStatus.initial,
        error = '';
  PhraseSaveState copyWith({
    PhraseSaveStateStatus? status,
    String? error,
    PhraseModel? model,
  }) {
    return PhraseSaveState(
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PhraseSaveState &&
        other.status == status &&
        other.error == error &&
        other.model == model;
  }

  @override
  int get hashCode {
    return status.hashCode ^ error.hashCode ^ model.hashCode;
  }
}
