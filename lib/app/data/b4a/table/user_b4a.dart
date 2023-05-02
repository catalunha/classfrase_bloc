import 'dart:async';

// import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/user_model.dart';
import '../../../core/models/user_profile_model.dart';
import '../b4a_exception.dart';
import '../entity/user_entity.dart';
import '../entity/user_profile_entity.dart';
import '../utils/parse_error_translate.dart';
import 'user_profile_b4a.dart';

class UserB4a {
  Future<UserModel?> register(
      {required String email, required String password}) async {
    ParseResponse? parseResponse;

    try {
      final user = ParseUser.createUser(email, password, email);
      parseResponse = await user.signUp();
      if (parseResponse.success && parseResponse.results != null) {
        UserModel userModel =
            await UserEntity().fromParse(parseResponse.results!.first);
        return userModel;
      } else {
        throw Exception();
      }
    } catch (e) {
      var errorTranslated =
          ParseErrorTranslate.translate(parseResponse!.error!);
      throw B4aException(
        errorTranslated,
        where: 'UserRepositoryB4a.register',
        originalError:
            '${parseResponse.error!.code} - ${parseResponse.error!.message}',
      );
    }
  }

  Future<UserModel?> readByEmail(String email) async {
    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject(UserEntity.className));
    query.whereEqualTo(UserEntity.email, email);
    query.includeObject([UserEntity.userProfile]);
    query.first();
    ParseResponse? parseResponse;
    try {
      parseResponse = await query.query();
      if (parseResponse.success && parseResponse.results != null) {
        return UserEntity().fromParse(parseResponse.results!.first);
      } else {
        throw Exception();
      }
    } catch (e) {
      var errorTranslated =
          ParseErrorTranslate.translate(parseResponse!.error!);
      throw B4aException(
        errorTranslated,
        where: 'UserRepositoryB4a.readByEmail',
        originalError:
            '${parseResponse.error!.code} -${parseResponse.error!.message}',
      );
    }
  }

  Future<UserModel?> login(
      {required String email, required String password}) async {
    UserModel userModel;
    ParseResponse? parseResponse;
    try {
      print('login: 1');
      final user = ParseUser(email, password, null);
      print('login: 2');

      parseResponse = await user.login();
      print('login: 3');
      if (parseResponse.success) {
        print('login: 4');
        print('login: 4');
        ParseUser parseUser = parseResponse.results!.first;

        UserProfileModel? userProfileModel = await readUserProfile(parseUser);

        if (userProfileModel != null) {
          userModel = UserModel(
            id: parseUser.objectId!,
            email: parseUser.emailAddress!,
            profile: userProfileModel,
          );
          return userModel;
        }
        throw B4aException(
          'Perfil do usuário não encontrado.',
          where: 'UserRepositoryB4a.login',
          originalError:
              '${parseResponse.error!.code} - ${parseResponse.error!.message}',
        );
      } else {
        var errorTranslated =
            ParseErrorTranslate.translate(parseResponse.error!);
        throw B4aException(
          errorTranslated,
          where: 'UserRepositoryB4a.login',
          originalError:
              '${parseResponse.error!.code} - ${parseResponse.error!.message}',
        );
      }
    } catch (_) {
      rethrow;
    }
  }

  Future<void> requestPasswordReset(String email) async {
    final ParseUser user = ParseUser(null, null, email);
    final ParseResponse parseResponse = await user.requestPasswordReset();
    if (!parseResponse.success) {
      var errorTranslated = ParseErrorTranslate.translate(parseResponse.error!);
      throw B4aException(
        errorTranslated,
        where: 'UserRepositoryB4a.requestPasswordReset',
        originalError:
            '${parseResponse.error!.code} -${parseResponse.error!.message}',
      );
    }
  }

  Future<bool> logout() async {
    final user = await ParseUser.currentUser() as ParseUser;
    var parseResponse = await user.logout();
    if (parseResponse.success) {
      return true;
    } else {
      return false;
    }
  }

  Future<UserModel?> hasUserLogged() async {
    var parseUser = await ParseUser.currentUser() as ParseUser?;
    if (parseUser == null) {
      return null;
    }
    //Checks whether the user's session token is valid
    final ParseResponse? parseResponse =
        await ParseUser.getCurrentUserFromServer(parseUser.sessionToken!);

    if (parseResponse?.success == null || !parseResponse!.success) {
      //Invalid session. Logout
      await parseUser.logout();
      return null;
    } else {
      try {
        UserProfileModel? userProfileModel = await readUserProfile(parseUser);

        if (userProfileModel != null) {
          UserModel userModel = UserModel(
            id: parseUser.objectId!,
            email: parseUser.emailAddress!,
            profile: userProfileModel,
          );
          return userModel;
        }

        throw B4aException(
          'Perfil do usuário não encontrado.',
          where: 'UserRepositoryB4a.hasUserLogged',
          originalError:
              '${parseResponse.error!.code} - ${parseResponse.error!.message}',
        );
      } catch (_) {
        rethrow;
      }
    }
  }

  Future<UserProfileModel?> readUserProfile(ParseUser parseUser) async {
    try {
      var profileField = parseUser.get(UserEntity.userProfile);
      var profileRepositoryB4a = UserProfileB4a();
      var profileModel = await profileRepositoryB4a.readById(
          profileField.objectId, UserProfileEntity.singleCols);
      return profileModel;
    } catch (_) {
      rethrow;
    }
  }
}
