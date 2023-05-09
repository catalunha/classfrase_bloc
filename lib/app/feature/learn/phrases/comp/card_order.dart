import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/category_classification/bloc/cat_class_bloc.dart';
import '../../../../core/models/phrase_model.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/app_link.dart';

class CardOrder extends StatelessWidget {
  PhraseModel phrase;
  CardOrder({
    Key? key,
    required this.phrase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        key: ValueKey(phrase),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                phrase.phrase,
                style: const TextStyle(fontSize: 18, color: Colors.cyan),
              ),
              Text(
                'Fonte: ${phrase.font}',
              ),
              Wrap(
                children: [
                  IconButton(
                    tooltip: 'PDF da classificação desta frase.',
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
            ]));
  }
}
