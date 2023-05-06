import 'package:classfrase_bloc/app/feature/classifying/classifying_page.dart';
import 'package:classfrase_bloc/app/feature/phrase/save/phrase_save_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/category_classification/bloc/cat_class_bloc.dart';
import '../../../../core/models/phrase_model.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/app_link.dart';
import '../bloc/phrase_list_bloc.dart';
import '../bloc/phrase_list_event.dart';
import '../bloc/phrase_list_state.dart';
import 'phrase_card.dart';

class PhraseList extends StatelessWidget {
  const PhraseList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<CatClassBloc>().state.categoryAll;

    return BlocListener<PhraseListBloc, PhraseListState>(
      listenWhen: (previous, current) {
        return previous.status != current.status;
      },
      listener: (context, state) async {
        if (state.status == PhraseListStateStatus.error) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
        }
        if (state.status == PhraseListStateStatus.success) {
          Navigator.of(context).pop();
        }
        if (state.status == PhraseListStateStatus.loading) {
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return const Center(child: CircularProgressIndicator());
            },
          );
        }
      },
      child: SingleChildScrollView(
        child: BlocBuilder<PhraseListBloc, PhraseListState>(
          builder: (context, state) {
            return Column(
              children: state.isSortedByFolder
                  ? buildPhraseListOrderedByFolder(context, state.list)
                  : buildPhraseListOrderedByAlpha(context, state.list),
            );
          },
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
    return PhraseCard(
      key: ValueKey(phrase),
      phrase: phrase,
      isPublic: phrase.isPublic,
      widgetList: [
        IconButton(
            tooltip: 'Classificar esta frase',
            icon: const Icon(AppIconData.letter),
            onPressed: () {
              // Navigator.of(context)
              //     .pushNamed('/classifying', arguments: phrase);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: BlocProvider.of<CatClassBloc>(context),
                    child: ClassifyingPage(model: phrase),
                  ),
                ),
              );
            }),
        IconButton(
          tooltip: 'PDF da classificação desta frase.',
          icon: const Icon(AppIconData.print),
          onPressed: () {
            Navigator.of(context).pushNamed('/pdf', arguments: {
              'phrase': phrase,
              'categoryAll': context.read<CatClassBloc>().state.categoryAll,
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
              await Clipboard.setData(ClipboardData(text: phrase.phrase));
            }

            _copyToClipboard();
            const snackBar =
                SnackBar(content: Text('Ok. A frase foi copiada.'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
        ),
        IconButton(
            tooltip: 'Editar esta frase',
            icon: const Icon(AppIconData.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: BlocProvider.of<PhraseListBloc>(context),
                    child: PhraseSavePage(model: phrase),
                  ),
                ),
              );

              // Navigator.of(context)
              //     .pushNamed('/phrase/save', arguments: phrase);
            }),
        IconButton(
            tooltip: 'Arquivar esta frase',
            icon: const Icon(AppIconData.inbox),
            onPressed: () {
              context.read<PhraseListBloc>().add(PhraseListEventIsArchived(
                  phraseId: phrase.id!, isArchived: true));
            }),
      ],
    );
  }
}
