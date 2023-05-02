import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/user_profile_model.dart';
import '../../../core/repositories/user_profile_repository.dart';
import '../../utils/app_photo_show.dart';
import '../../utils/app_text_title_value.dart';
import '../search/bloc/user_profile_search_bloc.dart';
import '../search/bloc/user_profile_search_event.dart';
import 'bloc/user_profile_access_bloc.dart';
import 'bloc/user_profile_access_event.dart';
import 'bloc/user_profile_access_state.dart';

class UserProfileAccessPage extends StatelessWidget {
  final UserProfileModel userProfileModel;
  const UserProfileAccessPage({
    Key? key,
    required this.userProfileModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepositoryProvider(
        create: (context) => UserProfileRepository(),
        child: BlocProvider(
          create: (context) => UserProfileAccessBloc(
              model: userProfileModel,
              repository:
                  RepositoryProvider.of<UserProfileRepository>(context)),
          child: UserProfileAccessView(userProfileModel: userProfileModel),
        ),
      ),
    );
  }
}

class UserProfileAccessView extends StatefulWidget {
  final UserProfileModel userProfileModel;

  const UserProfileAccessView({Key? key, required this.userProfileModel})
      : super(key: key);

  @override
  State<UserProfileAccessView> createState() => _UserProfileAccessViewState();
}

class _UserProfileAccessViewState extends State<UserProfileAccessView> {
  final _formKey = GlobalKey<FormState>();
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    isActive = widget.userProfileModel.isActive;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atualizar este operador'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.cloud_upload),
        onPressed: () async {
          final formValid = _formKey.currentState?.validate() ?? false;
          if (formValid) {
            context.read<UserProfileAccessBloc>().add(
                  UserProfileAccessEventFormSubmitted(
                    isActive: isActive,
                  ),
                );
          }
        },
      ),
      body: BlocListener<UserProfileAccessBloc, UserProfileAccessState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == UserProfileAccessStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }

          if (state.status == UserProfileAccessStateStatus.success) {
            Navigator.of(context).pop();
            context
                .read<UserProfileSearchBloc>()
                .add(UserProfileSearchEventUpdateList(state.model));
            Navigator.of(context).pop();
          }
          if (state.status == UserProfileAccessStateStatus.updated) {
            Navigator.of(context).pop();
            isActive = state.model.isActive;
          }
          if (state.status == UserProfileAccessStateStatus.loading) {
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          }
        },
        child: Center(
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Text(
                      //   'Id: ${widget._userProfileAccessController.userProfile!.id}',
                      // ),
                      const SizedBox(height: 5),
                      BlocBuilder<UserProfileAccessBloc,
                          UserProfileAccessState>(
                        builder: (context, state) {
                          return AppImageShow(
                            photoUrl: state.model.photo,
                          );
                        },
                      ),
                      AppTextTitleValue(
                        title: 'Email: ',
                        value: widget.userProfileModel.email,
                        inColumn: true,
                      ),
                      BlocBuilder<UserProfileAccessBloc,
                          UserProfileAccessState>(
                        builder: (context, state) {
                          return AppTextTitleValue(
                            inColumn: true,
                            title: 'Nome: ',
                            value: '${state.model.name}',
                          );
                        },
                      ),

                      BlocBuilder<UserProfileAccessBloc,
                          UserProfileAccessState>(
                        builder: (context, state) {
                          return AppTextTitleValue(
                            title: 'Telefone: ',
                            value: '${state.model.phone}',
                          );
                        },
                      ),

                      const Divider(
                        thickness: 2,
                      ),
                      CheckboxListTile(
                        title: const Text("* Liberar acesso ?"),
                        value: isActive,
                        onChanged: (value) {
                          setState(() {
                            isActive = value ?? false;
                          });
                        },
                      ),

                      const SizedBox(height: 70),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget accessSelect(String name, String access) {
    return SizedBox(
      width: 170,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(name),
              BlocBuilder<UserProfileAccessBloc, UserProfileAccessState>(
                builder: (context, state) {
                  return Checkbox(
                      tristate: true,
                      value: state.access.contains(access),
                      onChanged: (value) {
                        context.read<UserProfileAccessBloc>().add(
                            UserProfileAccessEventUpdateAccess(access: access));
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
