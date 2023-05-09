import 'package:flutter/material.dart';

import '../../../../../core/models/phrase_model.dart';
import '../../../../utils/app_icon.dart';

class PhraseArchivedCard extends StatelessWidget {
  final PhraseModel phrase;
  final List<Widget>? widgetList;
  // final Widget? trailing;
  final bool isPublic;
  const PhraseArchivedCard({
    Key? key,
    required this.phrase,
    this.widgetList,
    this.isPublic = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ListTile(
            // tileColor: Colors.yellowAccent,
            title: Text(
              phrase.phrase,
              style: const TextStyle(fontSize: 18, color: Colors.cyan),
            ),
            subtitle: Text(
              phrase.font ?? '',
              // style: AppTextStyles.trailingBold,
            ),
            trailing: isPublic
                ? const Tooltip(
                    message: 'Esta frase é pública.',
                    child: Icon(AppIconData.public))
                : null,
          ),
          Wrap(
            children: widgetList ?? [],
          )
        ],
      ),
    );
  }
}
