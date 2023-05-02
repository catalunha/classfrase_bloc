import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/user_profile_model.dart';
import '../bloc/user_profile_select_bloc.dart';
import '../bloc/user_profile_select_event.dart';
import '../bloc/user_profile_select_state.dart';

class UserProfileCard extends StatelessWidget {
  final UserProfileModel model;
  const UserProfileCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileSelectBloc, UserProfileSelectState>(
      builder: (context, state) {
        Color? color;
        if (state.selectedValues.contains(model)) {
          color = Colors.green;
        }
        return ListTile(
            title: Text('${model.name}'),
            tileColor: color,
            onTap: () {
              if (state.isSingleValue) {
                Navigator.of(context).pop([model]);
              } else {
                context
                    .read<UserProfileSelectBloc>()
                    .add(UserProfileSelectEventUpdateSelectedValues(model));
              }
            });
      },
    );
  }
}
