import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/phrase_model.dart';
import '../../../../core/repositories/phrase_repository.dart';
import '../../../../data/b4a/entity/phrase_entity.dart';
import 'pdf_one_event.dart';
import 'pdf_one_state.dart';

class PdfOneBloc extends Bloc<PdfOneEvent, PdfOneState> {
  final PhraseRepository _repository;
  PdfOneBloc({
    required PhraseModel model,
    required PhraseRepository repository,
  })  : _repository = repository,
        super(PdfOneState.initial(model)) {
    on<PdfOneEventStart>(_onPdfOneEventStart);

    add(PdfOneEventStart());
  }
  final List<String> cols = [
    ...PhraseEntity.singleCols,
    ...PhraseEntity.pointerCols,
  ];

  FutureOr<void> _onPdfOneEventStart(
      PdfOneEventStart event, Emitter<PdfOneState> emit) async {
    print('Staaaaaaaarting....');
    emit(state.copyWith(status: PdfOneStateStatus.loading));
    try {
      PhraseModel? temp = await _repository.readById(state.model!.id!, cols);
      emit(state.copyWith(
        model: temp,
        status: PdfOneStateStatus.success,
      ));
    } catch (e) {
      //print(e);
      emit(state.copyWith(
          status: PdfOneStateStatus.error,
          error: 'Erro ao buscar dados da frase para pdf'));
    }
  }
}
