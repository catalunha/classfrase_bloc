import 'package:flutter/material.dart';

import '../../../../core/models/phrase_model.dart';
import '../../../utils/app_icon.dart';

class AlphabeticOrder extends StatelessWidget {
  final List<PhraseModel> phraseList;
  final Widget Function(PhraseModel) cardOrder;
  AlphabeticOrder({
    Key? key,
    required this.phraseList,
    required this.cardOrder,
  }) : super(key: key);
  List<Widget> widgetList = [];
  List<PhraseModel> phraseListTemp = [];

  String folder = '';

  ListTile listEmpty() {
    return const ListTile(
      leading: Icon(AppIconData.smile),
      title: Text('Ops. Vc ainda não criou nenhuma frase.'),
    );
  }

  @override
  Widget build(BuildContext context) {
    phraseListTemp = [...phraseList];
    phraseListTemp.sort((a, b) => a.phrase.compareTo(b.phrase));
    for (var phrase in phraseListTemp) {
      widgetList.add(cardOrder(phrase));
    }

    if (widgetList.isEmpty) {
      widgetList.add(listEmpty());
    }
    return Column(
      children: widgetList,
    );
  }
}
