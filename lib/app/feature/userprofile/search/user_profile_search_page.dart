import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/repositories/user_profile_repository.dart';
import '../../utils/app_icon.dart';
import '../../utils/app_textformfield.dart';
import 'bloc/user_profile_search_bloc.dart';
import 'bloc/user_profile_search_event.dart';
import 'bloc/user_profile_search_state.dart';
import 'list/user_profile_search_list_page.dart';

class UserProfileSearchPage extends StatelessWidget {
  const UserProfileSearchPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => UserProfileRepository(),
      child: BlocProvider(
        create: (context) => UserProfileSearchBloc(
            userProfileRepository:
                RepositoryProvider.of<UserProfileRepository>(context)),
        child: const UserProfileSearchView(),
      ),
    );
  }
}

class UserProfileSearchView extends StatefulWidget {
  const UserProfileSearchView({Key? key}) : super(key: key);

  @override
  State<UserProfileSearchView> createState() => _SearchPageState();
}

class _SearchPageState extends State<UserProfileSearchView> {
  final _formKey = GlobalKey<FormState>();
  bool _nameContains = false;
  bool _cpfEqualTo = false;
  bool _phoneEqualTo = false;
  final _nameContainsTEC = TextEditingController();
  final _cpfEqualToTEC = TextEditingController();
  final _phoneEqualToTEC = TextEditingController();

  @override
  void initState() {
    _nameContainsTEC.text = '';
    _cpfEqualToTEC.text = '';
    _phoneEqualToTEC.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscando usuário'),
      ),
      body: BlocListener<UserProfileSearchBloc, UserProfileSearchState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          //print('++++++++++++++++ search -------------------');

          if (state.status == UserProfileSearchStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == UserProfileSearchStateStatus.success) {
            //print('success');
            Navigator.of(context).pop();
          }
          if (state.status == UserProfileSearchStateStatus.loading) {
            //print('loading');

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
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Card(
                      child: Column(
                        children: [
                          const Text('por Nome'),
                          Row(
                            children: [
                              Checkbox(
                                value: _nameContains,
                                onChanged: (value) {
                                  setState(() {
                                    _nameContains = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: AppTextFormField(
                                  label: 'que contém',
                                  controller: _nameContainsTEC,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          const Text('por CPF'),
                          Row(
                            children: [
                              Checkbox(
                                value: _cpfEqualTo,
                                onChanged: (value) {
                                  setState(() {
                                    _cpfEqualTo = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: AppTextFormField(
                                  label: 'igual a',
                                  controller: _cpfEqualToTEC,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          const Text('por Telefone'),
                          Row(
                            children: [
                              Checkbox(
                                value: _phoneEqualTo,
                                onChanged: (value) {
                                  setState(() {
                                    _phoneEqualTo = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: AppTextFormField(
                                  label: 'igual a',
                                  controller: _phoneEqualToTEC,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 70)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Executar busca',
        child: const Icon(AppIconData.search),
        onPressed: () async {
          final formValid = _formKey.currentState?.validate() ?? false;
          if (formValid) {
            context.read<UserProfileSearchBloc>().add(
                  UserProfileSearchEventFormSubmitted(
                    nameContainsBool: _nameContains,
                    nameContainsString: _nameContainsTEC.text,
                    cpfEqualToBool: _cpfEqualTo,
                    cpfEqualToString: _cpfEqualToTEC.text,
                    phoneEqualToBool: _phoneEqualTo,
                    phoneEqualToString: _phoneEqualToTEC.text,
                  ),
                );
            // Navigator.of(context).pushNamed('/userProfile/list');

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<UserProfileSearchBloc>(context),
                  child: const UserProfileSearchListPage(),
                ),
              ),
            );

            /*
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<UserProfileSearchBloc>(context),
                  child: const UserProfileSearchListPage(),
                ),
              ),
            );
            */
            /*
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const UserProfileSearchListPage(),
              ),
            );
            */
          }
        },
      ),
    );
  }
}
