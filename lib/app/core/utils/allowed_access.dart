import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../authentication/authentication.dart';
import '../models/user_model.dart';

class GetModuleAllowedAccess {
  static bool consultFor(
      List<String> officeIdListAutorized, BuildContext context) {
    UserModel user = context.read<AuthenticationBloc>().state.user!;
    return user.profile!.access
        .any((element) => officeIdListAutorized.contains(element));
    // return true;
  }
}
