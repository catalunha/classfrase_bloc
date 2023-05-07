import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/category_classification/bloc/cat_class_bloc.dart';
import '../../../core/models/phrase_model.dart';
import '../../../core/models/user_profile_model.dart';
import '../../../core/repositories/phrase_repository.dart';
import '../../utils/app_icon.dart';
import '../../utils/app_link.dart';
import 'bloc/learn_phrases_bloc.dart';
import 'bloc/learn_phrases_event.dart';
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
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                IconButton(
                  tooltip: 'Ordem alfabética das frases',
                  icon: const Icon(AppIconData.sortAlpha),
                  onPressed: () {
                    context
                        .read<LearnPhrasesBloc>()
                        .add(LearnPhrasesEventSortAlpha());
                  },
                ),
                IconButton(
                  tooltip: 'Ordem por folder das frases',
                  icon: const Icon(AppIconData.sortFolder),
                  onPressed: () {
                    context
                        .read<LearnPhrasesBloc>()
                        .add(LearnPhrasesEventSortFolder());
                  },
                ),
                IconButton(
                  tooltip: 'PDF de todas as frases',
                  icon: const Icon(AppIconData.print),
                  onPressed: () {
                    List<PhraseModel> list =
                        context.read<LearnPhrasesBloc>().state.list;
                    Navigator.of(context)
                        .pushNamed('/pdf/all', arguments: list);
                  },
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: BlocBuilder<LearnPhrasesBloc, LearnPhrasesState>(
                  builder: (context, state) {
                    return Column(
                      children: state.isSortedByFolder
                          ? buildPhraseListOrderedByFolder(context, state.list)
                          : buildPhraseListOrderedByAlpha(context, state.list),
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

  List<Widget> buildPhraseListOrderedByFolder(
      BuildContext context, List<PhraseModel> phraseList) {
    List<Widget> listCard = [];
    List<Widget> listExpansionTile = [];
    List<PhraseModel> phraseTemp = [];
    String folder = '';
    if (phraseList.isNotEmpty) {
      folder = phraseList.first.folder;
    }
    for (var phrase1 in phraseList) {
      if (phrase1.folder != folder) {
        phraseTemp.sort((a, b) => a.phrase.compareTo(b.phrase));
        for (var phrase2 in phraseTemp) {
          listCard.add(phraseCardWidget(phrase2, context));
        }

        listExpansionTile.add(
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.black),
            ),
            child: ExpansionTile(
              title: Text(folder),
              children: [
                ...listCard,
              ],
            ),
          ),
        );
        listCard.clear();
        phraseTemp.clear();
        folder = phrase1.folder;
      }
      // listCard.add(phraseCardWidget(phrase, context));
      phraseTemp.add(phrase1);
    }
    if (phraseList.isNotEmpty) {
      listExpansionTile.add(
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.black),
          ),
          child: ExpansionTile(
            title: Text(folder),
            children: [
              ...listCard,
            ],
          ),
        ),
      );
    }
    if (listExpansionTile.isEmpty) {
      listCard.add(listEmpty());
    }
    return listExpansionTile;
  }

  ListTile listEmpty() {
    return const ListTile(
      leading: Icon(AppIconData.smile),
      title: Text('Ops. Vc ainda não criou nenhuma frase.'),
    );
  }

  List<Widget> buildPhraseListOrderedByAlpha(
      BuildContext context, List<PhraseModel> phraseList) {
    List<Widget> list = [];
    List<PhraseModel> tem = [...phraseList];
    tem.sort((a, b) => a.phrase.compareTo(b.phrase));
    for (var phrase in tem) {
      list.add(phraseCardWidget(phrase, context));
    }

    if (list.isEmpty) {
      list.add(listEmpty());
    }
    return list;
  }

  Widget phraseCardWidget(PhraseModel phrase, BuildContext context) {
    return Card(
        key: ValueKey(phrase),
        child: Column(
          children: [
            Text(
              phrase.phrase,
            ),
            Text(
              phrase.font ?? '',
            ),
            Wrap(
              children: [
                // IconButton(
                //     tooltip: 'Ver classificação desta frase.',
                //     icon: const Icon(AppIconData.letter),
                //     onPressed: () {
                //       // Navigator.of(context)
                //       //     .pushNamed('/classifying', arguments: phrase);
                //       // Navigator.of(context).push(
                //       //   MaterialPageRoute(
                //       //     builder: (_) => BlocProvider.value(
                //       //       value: BlocProvider.of<PhraseListBloc>(context),
                //       //       child: BlocProvider.value(
                //       //         value: BlocProvider.of<CatClassBloc>(context),
                //       //         child: ClassifyingPage(model: phrase),
                //       //       ),
                //       //     ),
                //       //   ),
                //       // );
                //     }),
                IconButton(
                  tooltip: 'Ver PDF da classificação desta frase.',
                  icon: const Icon(AppIconData.print),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/pdf', arguments: {
                      'phrase': phrase,
                      'categoryAll':
                          context.read<CatClassBloc>().state.categoryAll,
                    });
                  },
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
        ));
  }
}
