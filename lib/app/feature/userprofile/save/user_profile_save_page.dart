import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/authentication/authentication.dart';
import '../../../core/models/user_model.dart';
import '../../../core/repositories/user_profile_repository.dart';
import '../../utils/app_import_image.dart';
import '../../utils/app_textformfield.dart';
import 'bloc/user_profile_save_bloc.dart';
import 'bloc/user_profile_save_event.dart';
import 'bloc/user_profile_save_state.dart';

class UserProfileSavePage extends StatelessWidget {
  final UserModel userModel;
  const UserProfileSavePage({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepositoryProvider(
        create: (context) => UserProfileRepository(),
        child: BlocProvider(
          create: (context) => UserProfileSaveBloc(
              model: userModel,
              repository:
                  RepositoryProvider.of<UserProfileRepository>(context)),
          child: UserProfileSaveView(userModel: userModel),
        ),
      ),
    );
  }
}

class UserProfileSaveView extends StatefulWidget {
  final UserModel userModel;
  const UserProfileSaveView({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  State<UserProfileSaveView> createState() => _UserProfileSaveViewState();
}

class _UserProfileSaveViewState extends State<UserProfileSaveView> {
  final _formKey = GlobalKey<FormState>();
  final _nameTec = TextEditingController();
  final _phoneTec = TextEditingController();
  final _descriptionTec = TextEditingController();
  final _communityTec = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameTec.text = widget.userModel.profile?.name ?? "";
    _phoneTec.text = widget.userModel.profile?.phone ?? "";
    _descriptionTec.text = widget.userModel.profile?.description ?? "";
    _communityTec.text = widget.userModel.profile?.community ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar seu perfil'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.cloud_upload),
        onPressed: () async {
          final formValid = _formKey.currentState?.validate() ?? false;
          if (formValid) {
            context.read<UserProfileSaveBloc>().add(
                  UserProfileSaveEventFormSubmitted(
                    name: _nameTec.text,
                    phone: _phoneTec.text,
                    description: _descriptionTec.text,
                    community: _communityTec.text,
                  ),
                );
          }
        },
      ),
      body: BlocListener<UserProfileSaveBloc, UserProfileSaveState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == UserProfileSaveStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == UserProfileSaveStateStatus.success) {
            Navigator.of(context).pop();
            context
                .read<AuthenticationBloc>()
                .add(AuthenticationEventUpdateUserProfile(state.user));
            Navigator.of(context).pop();
          }
          if (state.status == UserProfileSaveStateStatus.loading) {
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
                      //   'Id: ${widget.userModel.profile!.id}',
                      // ),
                      Text(
                        'email: ${widget.userModel.profile!.email}',
                      ),
                      const SizedBox(height: 5),
                      AppTextFormField(
                        label: '* Seu nome',
                        controller: _nameTec,
                        validator: Validatorless.required(
                            'Nome completo é obrigatório'),
                      ),
                      AppTextFormField(
                          label: '* Seu telefone. Formato: DDDNÚMERO',
                          controller: _phoneTec,
                          validator: Validatorless.multiple([
                            Validatorless.number(
                                'Apenas números. Formato: DDDNÚMERO'),
                            Validatorless.required('Telefone é obrigatório'),
                          ])),
                      AppTextFormField(
                        label: 'Uma breve descrição sobre você',
                        controller: _descriptionTec,
                      ),
                      AppTextFormField(
                        label: 'Nome da sua comunidade',
                        controller: _communityTec,
                      ),
                      const SizedBox(height: 5),
                      AppImportImage(
                        label:
                            'Click aqui para buscar sua foto, apenas face. Padrão 3x4.',
                        imageUrl: widget.userModel.profile!.photo,
                        setXFile: (value) => context
                            .read<UserProfileSaveBloc>()
                            .add(UserProfileSaveEventSendXFile(xfile: value)),
                        maxHeightImage: 150,
                        maxWidthImage: 100,
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
}
