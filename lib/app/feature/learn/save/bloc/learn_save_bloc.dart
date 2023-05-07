import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/learn_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/learn_repository.dart';
import '../../../../core/repositories/user_profile_repository.dart';
import '../../../../data/b4a/entity/user_profile_entity.dart';
import 'learn_save_event.dart';
import 'learn_save_state.dart';

class LearnSaveBloc extends Bloc<LearnSaveEvent, LearnSaveState> {
  final UserProfileModel _userProfile;
  final UserProfileRepository _userProfileRepository;
  final LearnRepository _learnRepository;
  LearnSaveBloc({
    required UserProfileModel userProfile,
    required UserProfileRepository userProfileRepository,
    required LearnRepository learnRepository,
  })  : _userProfile = userProfile,
        _userProfileRepository = userProfileRepository,
        _learnRepository = learnRepository,
        super(LearnSaveState.initial()) {
    on<LearnSaveEventFormSubmitted>(_onLearnSaveEventFormSubmitted);
  }
  final List<String> cols = UserProfileEntity.selectedCols([
    UserProfileEntity.email,
    UserProfileEntity.name,
  ]);
  FutureOr<void> _onLearnSaveEventFormSubmitted(
      LearnSaveEventFormSubmitted event, Emitter<LearnSaveState> emit) async {
    emit(state.copyWith(status: LearnSaveStateStatus.loading));
    try {
      print('event.email ${event.email}');
      if (event.email.isNotEmpty) {
        UserProfileModel? person =
            await _userProfileRepository.readByEmail(event.email, cols);
        if (person != null) {
          print('person ${person.name}');
          LearnModel model;
          model = LearnModel(userProfile: _userProfile, person: person);
          String cycleModelId = await _learnRepository.update(model);
          model = model.copyWith(id: cycleModelId);
          emit(state.copyWith(
              model: model, status: LearnSaveStateStatus.success));
        }
      }
      emit(state.copyWith(model: null, status: LearnSaveStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: LearnSaveStateStatus.error,
          error: 'Erro ao salvar aprendizado'));
    }
  }
}
