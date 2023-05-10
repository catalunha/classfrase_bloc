import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/category_classification/bloc/cat_class_bloc.dart';
import '../../../core/models/phrase_model.dart';
import 'bloc/phrase_list_bloc.dart';
import 'bloc/phrase_list_state.dart';
import 'comp/alphabetic_order.dart';
import 'comp/card_order.dart';
import 'comp/folder_order.dart';

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
            if (state.isSortedByFolder) {
              return FolderOrder(
                  phraseList: state.list,
                  cardOrder: (PhraseModel value) {
                    return CardOrder(
                      phrase: value,
                    );
                  });
            } else {
              return AlphabeticOrder(
                  phraseList: state.list,
                  cardOrder: (value) {
                    return CardOrder(
                      phrase: value,
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}
