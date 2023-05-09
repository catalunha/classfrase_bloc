import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/category_classification/bloc/cat_class_bloc.dart';
import '../../../../core/models/phrase_model.dart';
import '../../../classifying/classifying_page.dart';
import '../../../utils/app_icon.dart';
import '../../../utils/app_link.dart';
import '../../save/phrase_save_page.dart';
import '../bloc/phrase_list_bloc.dart';
import '../bloc/phrase_list_event.dart';

class CardOrder extends StatelessWidget {
  PhraseModel phrase;
  CardOrder({
    Key? key,
    required this.phrase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: Card(
          key: ValueKey(phrase),
          color: phrase.isPublic! ? Colors.black : null,
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
                        tooltip: 'Classificar esta frase',
                        icon: const Icon(AppIconData.letter),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: BlocProvider.of<PhraseListBloc>(context),
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
                          context.read<PhraseListBloc>().add(
                              PhraseListEventIsArchived(
                                  phraseId: phrase.id!, isArchived: true));
                        }),
                  ],
                ),
              ])),
    );
  }
}
