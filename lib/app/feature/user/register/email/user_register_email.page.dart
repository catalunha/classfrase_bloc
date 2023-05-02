import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../../../core/repositories/user_repository.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_textformfield.dart';
import 'bloc/user_register_email_bloc.dart';

class UserRegisterEmailPage extends StatelessWidget {
  const UserRegisterEmailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => UserRegisterEmailBloc(
            userRepository: RepositoryProvider.of<UserRepository>(context)),
        child: const UserRegisterEmailView(),
      ),
    );
  }
}

class UserRegisterEmailView extends StatefulWidget {
  const UserRegisterEmailView({Key? key}) : super(key: key);

  @override
  State<UserRegisterEmailView> createState() => _UserRegisterEmailViewState();
}

class _UserRegisterEmailViewState extends State<UserRegisterEmailView> {
  final _formKey = GlobalKey<FormState>();
  final _emailTEC = TextEditingController();
  final _passwordTEC = TextEditingController();

  @override
  void dispose() {
    _emailTEC.dispose();
    _passwordTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (_, constrainsts) {
          return BlocListener<UserRegisterEmailBloc, UserRegisterEmailState>(
            listenWhen: (previous, current) {
              return previous.status != current.status;
            },
            listener: (context, state) async {
              if (state.status == UserRegisterEmailStateStatus.error) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
              }
              if (state.status == UserRegisterEmailStateStatus.success) {
                var contextTemp = Navigator.of(context);
                Navigator.of(context).pop();
                await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return Center(
                      child: Card(
                        color: Colors.green,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Lembre-se de olhar seu email.'),
                              const Text('Para validar seu cadastro.'),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: const Text('Entendi'))
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
                contextTemp.pop();
              }
              if (state.status == UserRegisterEmailStateStatus.loading) {
                if (context.mounted) {
                  await showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return const Center(child: CircularProgressIndicator());
                    },
                  );
                }
              }
            },
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constrainsts.maxHeight,
                    maxWidth: 400,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Cadastro',
                              // style: context.textTheme.titleLarge?.copyWith(
                              //   fontWeight: FontWeight.bold,
                              //   // color: context.theme.primaryColorDark,
                              // ),
                            ),
                            const Text(
                                'Preencha os campos abaixo para criar o seu cadastro.'),
                            const SizedBox(height: 20),
                            AppTextFormField(
                              label: 'E-mail',
                              controller: _emailTEC,
                              validator: Validatorless.multiple([
                                Validatorless.required('email obrigatório.'),
                                Validatorless.email('Email inválido.'),
                              ]),
                            ),
                            const SizedBox(height: 20),
                            AppTextFormField(
                              label: 'Senha',
                              obscureText: true,
                              controller: _passwordTEC,
                              validator: Validatorless.multiple([
                                Validatorless.required('Senha obrigatória.'),
                                Validatorless.min(6, 'Minimo de 6 caracteres.'),
                              ]),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            AppTextFormField(
                              label: 'Confirme senha',
                              obscureText: true,
                              validator: Validatorless.multiple(
                                [
                                  Validatorless.required(
                                      'Confirmação de senha obrigatória.'),
                                  Validatorless.min(
                                      6, 'Minimo de 6 caracteres.'),
                                  Validatorless.compare(_passwordTEC,
                                      'Senha diferente do informado anteriormente.')
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                                'Após clicar em CADASTRAR você receberá um email para validação deste cadastro. É necessário ir na caixa de entrada do email informado aqui e validar seu cadastro antes de tentar login.'),
                            const SizedBox(
                              height: 20,
                            ),
                            AppButton(
                              label: 'Cadastrar',
                              onPressed: () {
                                final formValid =
                                    _formKey.currentState?.validate() ?? false;
                                if (formValid) {
                                  context.read<UserRegisterEmailBloc>().add(
                                        UserRegisterEmailEventFormSubmitted(
                                          email: _emailTEC.text,
                                          password: _passwordTEC.text,
                                        ),
                                      );
                                }
                              },
                              // width: context.width,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
