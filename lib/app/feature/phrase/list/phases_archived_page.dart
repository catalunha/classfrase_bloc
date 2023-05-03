import 'package:classfrase_bloc/app/feature/phrase/list/bloc/phrase_list_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/phrase_model.dart';
import '../../utils/app_icon.dart';
import 'bloc/phrase_list_bloc.dart';
import 'bloc/phrase_list_state.dart';
import 'comp/phrase_card.dart';

class PhrasesArchivedPage extends StatelessWidget {
  const PhrasesArchivedPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frases arquivadas'),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_return),
          onPressed: () {
            context.read<PhraseListBloc>().add(PhraseListEventStartList());
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlocBuilder<PhraseListBloc, PhraseListState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: buildItens(context),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> buildItens(BuildContext context) {
    List<PhraseModel> phraseArchivedList = [
      ...context.read<PhraseListBloc>().state.list
    ];

    List<Widget> list = [];
    for (var phrase in phraseArchivedList) {
      list.add(Container(
        key: ValueKey(phrase),
        child: PhraseCard(
          phrase: phrase,
          widgetList: [
            IconButton(
                tooltip: 'Desarquivar esta frase',
                icon: const Icon(AppIconData.outbox),
                onPressed: () {
                  context.read<PhraseListBloc>().add(PhraseListEventIsArchived(
                      phraseId: phrase.id!, isArchived: false));
                  Navigator.of(context).pop();
                }),
          ],
        ),
      ));
    }
    if (list.isEmpty) {
      list.add(const ListTile(
        leading: Icon(AppIconData.smile),
        title: Text('Ops. Vc não tem frases arquivadas.'),
      ));
    }
    return list;
  }
}
