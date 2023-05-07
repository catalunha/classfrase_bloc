import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/user_profile_model.dart';
import '../../../core/repositories/phrase_repository.dart';
import '../../utils/app_icon.dart';
import '../../utils/app_link.dart';
import 'bloc/learn_phrases_bloc.dart';
import 'bloc/learn_phrases_state.dart';
import 'comp/person_tile.dart';

class LearnPhrasesPage extends StatelessWidget {
  final UserProfileModel userProfile;
  const LearnPhrasesPage({
    Key? key,
    required this.userProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PhraseRepository(),
      child: BlocProvider(
        create: (context) => LearnPhrasesBloc(
          userProfile: userProfile,
          repository: RepositoryProvider.of<PhraseRepository>(context),
        ),
        child: const LearnPhrasesView(),
      ),
    );
  }
}

class LearnPhrasesView extends StatelessWidget {
  const LearnPhrasesView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frases compartilhadas'),
        // actions: [
        //   IconButton(
        //     tooltip: 'Filtrar frases desta pessoa.',
        //     icon: const Icon(AppIconData.search),
        //     onPressed: () async {
        //       await _learnController.onMarkCategoryIfAlreadyClassified();
        //       Get.toNamed(Routes.learnCategoriesByPerson);
        //     },
        //   ),
        //   IconButton(
        //     tooltip: 'Remover filtro',
        //     icon: const Icon(AppIconData.search_off),
        //     onPressed: () {
        //       _learnController.removeFilter();
        //     },
        //   ),
        // ],
      ),
      body: BlocListener<LearnPhrasesBloc, LearnPhrasesState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == LearnPhrasesStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == LearnPhrasesStateStatus.success) {
            Navigator.of(context).pop();
          }
          if (state.status == LearnPhrasesStateStatus.loading) {
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          }
        },
        child: Column(
          children: [
            BlocBuilder<LearnPhrasesBloc, LearnPhrasesState>(
              builder: (context, state) {
                return PersonTile(
                  community: state.person.community,
                  displayName: state.person.name,
                  photoURL: state.person.photo,
                  email: state.person.email,
                );
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: BlocBuilder<LearnPhrasesBloc, LearnPhrasesState>(
                  builder: (context, state) {
                    return Column(
                      children: buildItens(context, state),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildItens(context, LearnPhrasesState state) {
    List<Widget> list = [];

    for (var phrase in state.list) {
      list.add(
        Container(
          key: ValueKey(phrase),
          child: Card(
            elevation: 10,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  phrase.phrase,
                ),
                Text(
                  'Pasta: ${phrase.folder}',
                ),
                Text(
                  'Fonte: ${phrase.font ?? ""}',
                ),
                Wrap(
                  children: [
                    IconButton(
                      tooltip: 'Ver classificação desta frase.',
                      icon: const Icon(AppIconData.letter),
                      onPressed: () {
                        // state.selectPhrase(phrase.id!);
                        // Navigator.pushNamed(context, '/learn_phrase',
                        //     arguments: phrase.id);
                      },
                    ),
                    // SizedBox(
                    //   width: 50,
                    // ),
                    const IconButton(
                      tooltip: 'Imprimir a classificação desta frase.',
                      onPressed:
                          null, //() => Get.toNamed(Routes.pdf, arguments: phrase),
                      icon: Icon(Icons.print),
                    ),
                    AppLink(
                      url: phrase.diagramUrl,
                      icon: AppIconData.diagram,
                      tooltipMsg: 'Ver diagrama desta frase',
                    ),
                    IconButton(
                      tooltip: 'Copiar a frase para área de transferência.',
                      icon: const Icon(AppIconData.copy),
                      onPressed: () {
                        Future<void> _copyToClipboard() async {
                          await Clipboard.setData(
                              ClipboardData(text: phrase.phrase));
                        }

                        _copyToClipboard();
                        const snackBar =
                            SnackBar(content: Text('Ok. A frase foi copiada.'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
    if (list.isEmpty) {
      list.add(const ListTile(
        leading: Icon(AppIconData.smile),
        title: Text('Ops. Esta pessoa não tem frases públicas.'),
      ));
    }
    return list;
  }
}
