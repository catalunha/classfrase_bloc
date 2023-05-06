import 'package:classfrase_bloc/app/core/repositories/user_profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/authentication/authentication.dart';
import '../../../core/models/user_profile_model.dart';
import '../../../core/repositories/learn_repository.dart';
import '../../utils/app_textformfield.dart';
import '../list/bloc/learn_list_bloc.dart';
import '../list/bloc/learn_list_event.dart';
import 'bloc/learn_save_bloc.dart';
import 'bloc/learn_save_event.dart';
import 'bloc/learn_save_state.dart';

class LearnSavePage extends StatelessWidget {
  const LearnSavePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => LearnRepository(),
        ),
        RepositoryProvider(
          create: (context) => UserProfileRepository(),
        ),
      ],
      child: BlocProvider(
        create: (context) {
          UserProfileModel userProfile =
              context.read<AuthenticationBloc>().state.user!.profile!;

          return LearnSaveBloc(
            userProfile: userProfile,
            userProfileRepository:
                RepositoryProvider.of<UserProfileRepository>(context),
            learnRepository: RepositoryProvider.of<LearnRepository>(context),
          );
        },
        child: const LearnSaveView(),
      ),
    );
  }
}

class LearnSaveView extends StatefulWidget {
  const LearnSaveView({Key? key}) : super(key: key);

  @override
  State<LearnSaveView> createState() => _LearnSaveViewState();
}

class _LearnSaveViewState extends State<LearnSaveView> {
  final _formKey = GlobalKey<FormState>();
  final _emailTEC = TextEditingController();
  @override
  void initState() {
    super.initState();
    _emailTEC.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: BlocListener<LearnSaveBloc, LearnSaveState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == LearnSaveStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == LearnSaveStateStatus.success) {
            Navigator.of(context).pop();
            if (state.model != null) {
              context
                  .read<LearnListBloc>()
                  .add(LearnListEventUpdateList(state.model));
            }
            // else {
            //   context
            //       .read<LearnListBloc>()
            //       .add(LearnListEventRemoveFromList(state.model!.id!));
            // }
            Navigator.of(context).pop();
          }
          if (state.status == LearnSaveStateStatus.loading) {
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          }
        },
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Adicionar apenas uma pessoa'),
              AppTextFormField(
                label: 'Informe um email',
                controller: _emailTEC,
                validator: Validatorless.required('Email é obrigatório'),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        context.read<LearnSaveBloc>().add(
                              LearnSaveEventFormSubmitted(''),
                            );
                      },
                      child: const Text('Cancelar')),
                  const SizedBox(
                    width: 50,
                  ),
                  TextButton(
                      onPressed: () async {
                        final formValid =
                            _formKey.currentState?.validate() ?? false;
                        if (formValid) {
                          context.read<LearnSaveBloc>().add(
                                LearnSaveEventFormSubmitted(_emailTEC.text),
                              );
                        }
                      },
                      child: const Text('Buscar')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
