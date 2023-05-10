import 'package:classfrase_bloc/app/core/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/models/phrase_model.dart';
import '../../../core/models/user_profile_model.dart';
import '../../../core/repositories/phrase_repository.dart';
import '../../utils/app_textformfield.dart';
import '../list/bloc/phrase_list_bloc.dart';
import '../list/bloc/phrase_list_event.dart';
import 'bloc/phrase_save_bloc.dart';
import 'bloc/phrase_save_event.dart';
import 'bloc/phrase_save_state.dart';

class PhraseSavePage extends StatelessWidget {
  final PhraseModel? model;

  const PhraseSavePage({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PhraseRepository(),
      child: BlocProvider(
        create: (context) {
          UserProfileModel userProfile =
              context.read<AuthenticationBloc>().state.user!.profile!;
          return PhraseSaveBloc(
            userProfile: userProfile,
            model: model,
            repository: RepositoryProvider.of<PhraseRepository>(context),
          );
        },
        child: PhraseSaveView(
          model: model,
        ),
      ),
    );
  }
}

class PhraseSaveView extends StatefulWidget {
  final PhraseModel? model;
  const PhraseSaveView({Key? key, required this.model}) : super(key: key);

  @override
  State<PhraseSaveView> createState() => _PhraseSaveViewState();
}

class _PhraseSaveViewState extends State<PhraseSaveView> {
  final _formKey = GlobalKey<FormState>();
  final _phraseTEC = TextEditingController();
  final _fontTEC = TextEditingController();
  final _folderTEC = TextEditingController();
  final _diagramUrlTEC = TextEditingController();
  final _noteTEC = TextEditingController();
  bool _isPublic = false;
  bool _isDeleted = false;
  @override
  void initState() {
    super.initState();
    _phraseTEC.text = widget.model?.phrase ?? '';
    _fontTEC.text = widget.model?.font ?? '';
    _folderTEC.text = widget.model?.folder ?? '';
    _diagramUrlTEC.text = widget.model?.diagramUrl ?? '';
    _noteTEC.text = widget.model?.note ?? '';
    _isPublic = widget.model?.isPublic ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('${widget.model == null ? "Criar uma" : "Editar esta"} Frase'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.cloud_upload),
        onPressed: () async {
          if (_isDeleted) {
            context.read<PhraseSaveBloc>().add(
                  PhraseSaveEventDelete(),
                );
          } else {
            final formValid = _formKey.currentState?.validate() ?? false;
            if (formValid) {
              context.read<PhraseSaveBloc>().add(
                    PhraseSaveEventFormSubmitted(
                      phrase: _phraseTEC.text,
                      folder: _folderTEC.text,
                      font: _fontTEC.text,
                      diagramUrl: _diagramUrlTEC.text,
                      note: _noteTEC.text,
                      isPublic: _isPublic,
                    ),
                  );
            }
          }
        },
      ),
      body: BlocListener<PhraseSaveBloc, PhraseSaveState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == PhraseSaveStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == PhraseSaveStateStatus.success) {
            Navigator.of(context).pop();
            if (widget.model == null) {
              context
                  .read<PhraseListBloc>()
                  .add(PhraseListEventAddToList(state.model!));
            } else {
              if (_isDeleted) {
                context
                    .read<PhraseListBloc>()
                    .add(PhraseListEventRemoveFromList(state.model!.id!));
              } else {
                context
                    .read<PhraseListBloc>()
                    .add(PhraseListEventUpdateList(state.model!));
              }
            }
            Navigator.of(context).pop();
          }
          if (state.status == PhraseSaveStateStatus.loading) {
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
                      const SizedBox(height: 5),
                      if (widget.model != null) Text(_phraseTEC.text),
                      const SizedBox(height: 20),
                      if (widget.model == null)
                        AppTextFormField(
                          label: 'Informe a Frase',
                          controller: _phraseTEC,
                          validator: Validatorless.required(
                              'Este valor é obrigatório'),
                        ),
                      AppTextFormField(
                        label: 'Pasta desta frase',
                        controller: _folderTEC,
                        validator:
                            Validatorless.required('Este valor é obrigatório'),
                      ),
                      AppTextFormField(
                        label: 'Fonte desta frase',
                        controller: _fontTEC,
                      ),
                      AppTextFormField(
                        label: 'Link para o diagrama online desta frase',
                        controller: _diagramUrlTEC,
                      ),
                      AppTextFormField(
                        label: 'Observações sobre esta frase',
                        controller: _noteTEC,
                        maxLines: 3,
                      ),
                      // Row(
                      //   children: [
                      //     Switch(
                      //       value: _isPublic,
                      //       onChanged: (value) {
                      //         setState(() {
                      //           _isPublic = value;
                      //         });
                      //       },
                      //     ),
                      //     const Text("Esta frase é pública ?"),
                      //   ],
                      // ),
                      CheckboxListTile(
                        title: const Text("Esta frase é pública ?"),
                        onChanged: (value) {
                          setState(() {
                            _isPublic = value ?? false;
                          });
                        },
                        value: _isPublic,
                      ),
                      if (widget.model != null)
                        CheckboxListTile(
                          tileColor: _isDeleted ? Colors.red : null,
                          title: const Text("Apagar esta frase ?"),
                          onChanged: (value) {
                            setState(() {
                              _isDeleted = value ?? false;
                            });
                          },
                          value: _isDeleted,
                        ),
                      Text('Id: ${widget.model?.id}'),
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
