import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/models/user_model.dart';
import '../../../../core/models/user_profile_model.dart';
import '../../../../core/repositories/user_profile_repository.dart';
import '../../../../data/b4a/entity/user_profile_entity.dart';
import '../../../../data/b4a/utils/xfile_to_parsefile.dart';
import 'user_profile_save_event.dart';
import 'user_profile_save_state.dart';

class UserProfileSaveBloc
    extends Bloc<UserProfileSaveEvent, UserProfileSaveState> {
  final UserProfileRepository _repository;
  UserProfileSaveBloc(
      {required UserModel model, required UserProfileRepository repository})
      : _repository = repository,
        super(UserProfileSaveState.initial(model)) {
    on<UserProfileSaveEventFormSubmitted>(_onUserProfileSaveEventFormSubmitted);
    on<UserProfileSaveEventSendXFile>(_onUserProfileSaveEventSendXFile);
  }

  FutureOr<void> _onUserProfileSaveEventFormSubmitted(
      UserProfileSaveEventFormSubmitted event,
      Emitter<UserProfileSaveState> emit) async {
    emit(state.copyWith(status: UserProfileSaveStateStatus.loading));
    try {
      UserProfileModel userProfileModel = state.user.profile!.copyWith(
        name: event.name,
        phone: event.phone,
        description: event.description,
        community: event.community,
      );

      String userProfileId = await _repository.update(userProfileModel);
      if (state.xfile != null) {
        String? photoUrl = await XFileToParseFile.xFileToParseFile(
          xfile: state.xfile!,
          className: UserProfileEntity.className,
          objectId: userProfileId,
          objectAttribute: 'photo',
        );
        userProfileModel = userProfileModel.copyWith(photo: photoUrl);
      }

      userProfileModel = userProfileModel.copyWith(
        id: userProfileId,
      );

      UserModel user = state.user.copyWith(userProfile: userProfileModel);

      emit(state.copyWith(
          user: user, status: UserProfileSaveStateStatus.success));
    } catch (_) {
      emit(state.copyWith(
          status: UserProfileSaveStateStatus.error,
          error: 'Erro ao salvar dados no seu perfil'));
    }
  }

  FutureOr<void> _onUserProfileSaveEventSendXFile(
      UserProfileSaveEventSendXFile event, Emitter<UserProfileSaveState> emit) {
    emit(state.copyWith(xfile: event.xfile));
  }
}
