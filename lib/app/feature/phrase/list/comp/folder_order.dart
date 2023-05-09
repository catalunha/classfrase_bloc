import 'package:flutter/material.dart';

import '../../../../core/models/phrase_model.dart';
import '../../../utils/app_icon.dart';

class FolderOrder extends StatelessWidget {
  final List<PhraseModel> phraseList;
  final Widget Function(PhraseModel) cardOrder;
  FolderOrder({
    Key? key,
    required this.phraseList,
    required this.cardOrder,
  }) : super(key: key);
  List<Widget> listCard = [];
  List<Widget> listExpansionTile = [];
  List<PhraseModel> phraseTemp = [];
  String folder = '';

  ListTile listEmpty() {
    return const ListTile(
      leading: Icon(AppIconData.smile),
      title: Text('Ops. Vc ainda não criou nenhuma frase.'),
    );
  }

  @override
  Widget build(BuildContext context) {
    phraseList.sort((a, b) => a.folder!.compareTo(b.folder!));

    if (phraseList.isNotEmpty) {
      folder = phraseList.first.folder!;
    }
    for (var phrase1 in phraseList) {
      if (phrase1.folder != folder) {
        phraseTemp.sort((a, b) => a.phrase.compareTo(b.phrase));
        for (var phrase2 in phraseTemp) {
          listCard.add(cardOrder(phrase2));
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
        folder = phrase1.folder!;
      }
      phraseTemp.add(phrase1);
    }
    if (phraseTemp.isNotEmpty) {
      phraseTemp.sort((a, b) => a.phrase.compareTo(b.phrase));
      for (var phrase2 in phraseTemp) {
        listCard.add(cardOrder(phrase2));
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
    }
    if (listExpansionTile.isEmpty) {
      listCard.add(listEmpty());
    }
    return Column(
      children: listExpansionTile,
    );
  }
}
