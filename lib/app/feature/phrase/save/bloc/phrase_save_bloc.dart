import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/phrase_classification_model.dart';
import '../../../../core/models/phrase_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/phrase_repository.dart';
import 'phrase_save_event.dart';
import 'phrase_save_state.dart';

class PhraseSaveBloc extends Bloc<PhraseSaveEvent, PhraseSaveState> {
  final PhraseRepository _repository;
  final UserProfileModel _userProfile;
  PhraseSaveBloc({
    required UserProfileModel userProfile,
    required PhraseModel? model,
    required PhraseRepository repository,
  })  : _userProfile = userProfile,
        _repository = repository,
        super(PhraseSaveState.initial(model)) {
    on<PhraseSaveEventFormSubmitted>(_onPhraseSaveEventFormSubmitted);
    on<PhraseSaveEventDelete>(_onPhraseSaveEventDelete);
  }

  FutureOr<void> _onPhraseSaveEventFormSubmitted(
      PhraseSaveEventFormSubmitted event, Emitter<PhraseSaveState> emit) async {
    emit(state.copyWith(status: PhraseSaveStateStatus.loading));
    try {
      PhraseModel model;
      if (state.model == null) {
        model = PhraseModel(
          userProfile: _userProfile,
          phrase: event.phrase,
          phraseList: PhraseModel.setPhraseList(event.phrase),
          folder: event.folder,
          font: event.font,
          diagramUrl: event.diagramUrl,
          note: event.note,
          isPublic: event.isPublic,
          classifications: <String, Classification>{},
          classOrder: [],
        );
      } else {
        model = state.model!.copyWith(
            folder: event.folder,
            font: event.font,
            diagramUrl: event.diagramUrl,
            note: event.note,
            isPublic: event.isPublic);
      }
      String modelId = await _repository.update(model);

      model = model.copyWith(id: modelId);

      emit(state.copyWith(model: model, status: PhraseSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: PhraseSaveStateStatus.error, error: 'Erro ao salvar cycle'));
    }
  }

  FutureOr<void> _onPhraseSaveEventDelete(
      PhraseSaveEventDelete event, Emitter<PhraseSaveState> emit) async {
    try {
      emit(state.copyWith(status: PhraseSaveStateStatus.loading));
      await _repository.delete(state.model!.id!);
      emit(state.copyWith(status: PhraseSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: PhraseSaveStateStatus.error, error: 'Erro ao delete item'));
    }
  }
}
