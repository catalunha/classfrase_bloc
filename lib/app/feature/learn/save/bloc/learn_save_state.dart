import '../../../../core/models/learn_model.dart';

enum LearnSaveStateStatus { initial, loading, success, error, delete }

class LearnSaveState {
  final LearnSaveStateStatus status;
  final String? error;
  final LearnModel? model;
  LearnSaveState({
    required this.status,
    this.error,
    this.model,
  });
  LearnSaveState.initial()
      : status = LearnSaveStateStatus.initial,
        error = '',
        model = null;
  LearnSaveState copyWith({
    LearnSaveStateStatus? status,
    String? error,
    LearnModel? model,
  }) {
    return LearnSaveState(
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
    );
  }

  @override
  String toString() =>
      'LearnSaveState(status: $status, error: $error, model: $model)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LearnSaveState &&
        other.status == status &&
        other.error == error &&
        other.model == model;
  }

  @override
  int get hashCode => status.hashCode ^ error.hashCode ^ model.hashCode;
}
