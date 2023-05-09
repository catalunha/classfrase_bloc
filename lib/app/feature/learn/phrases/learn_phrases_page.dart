import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/phrase_model.dart';
import '../../../core/models/user_profile_model.dart';
import '../../../core/repositories/phrase_repository.dart';
import '../../phrase/list/comp/alphabetic_order.dart';
import '../../phrase/list/comp/folder_order.dart';
import '../../utils/app_icon.dart';
import 'bloc/learn_phrases_bloc.dart';
import 'bloc/learn_phrases_event.dart';
import 'bloc/learn_phrases_state.dart';
import 'categories_byperson_page.dart';
import '../comp/person_card.dart';
import 'comp/card_order.dart';

class LearnPhrasesPage extends StatelessWidget {
  final UserProfileModel person;
  const LearnPhrasesPage({
    Key? key,
    required this.person,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PhraseRepository(),
      child: BlocProvider(
        create: (context) => LearnPhrasesBloc(
          userProfile: person,
          repository: RepositoryProvider.of<PhraseRepository>(context),
        ),
        child: LearnPhrasesView(person: person),
      ),
    );
  }
}

class LearnPhrasesView extends StatelessWidget {
  final UserProfileModel person;

  const LearnPhrasesView({
    Key? key,
    required this.person,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<LearnPhrasesBloc, LearnPhrasesState>(
          builder: (context, state) {
            return Text(
                '${state.listOriginal.length} frases compartilhadas por');
          },
        ),
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
                return PersonCard(
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
                BlocBuilder<LearnPhrasesBloc, LearnPhrasesState>(
                  builder: (context, state) {
                    return IconButton(
                      tooltip: 'Filtre por categoria.',
                      icon: Icon(
                        AppIconData.search,
                        color: state.isFiltered ? Colors.green : Colors.black,
                      ),
                      onPressed: () {
                        context.read<LearnPhrasesBloc>().add(
                            LearnPhrasesEventOnMarkCategoryIfAlreadyClassifiedInPos());

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: BlocProvider.of<LearnPhrasesBloc>(context),
                              child: const CategoriesByPersonPage(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                BlocBuilder<LearnPhrasesBloc, LearnPhrasesState>(
                  builder: (context, state) {
                    return IconButton(
                      tooltip: 'Remover filtre por categoria.',
                      icon: Icon(
                        AppIconData.searchOff,
                        color: !state.isFiltered ? Colors.green : Colors.black,
                      ),
                      onPressed: () {
                        context
                            .read<LearnPhrasesBloc>()
                            .add(LearnPhrasesEventFilterRemoved());
                      },
                    );
                  },
                ),
                BlocBuilder<LearnPhrasesBloc, LearnPhrasesState>(
                  builder: (context, state) {
                    return IconButton(
                      tooltip: 'Ordem alfabética das frases',
                      icon: Icon(
                        AppIconData.sortAlpha,
                        color: !state.isSortedByFolder
                            ? Colors.green
                            : Colors.black,
                      ),
                      onPressed: () {
                        context
                            .read<LearnPhrasesBloc>()
                            .add(LearnPhrasesEventSortAlpha());
                      },
                    );
                  },
                ),
                BlocBuilder<LearnPhrasesBloc, LearnPhrasesState>(
                  builder: (context, state) {
                    return IconButton(
                      tooltip: 'Ordem por folder das frases',
                      icon: Icon(AppIconData.sortFolder,
                          color: state.isSortedByFolder
                              ? Colors.green
                              : Colors.black),
                      onPressed: () {
                        context
                            .read<LearnPhrasesBloc>()
                            .add(LearnPhrasesEventSortFolder());
                      },
                    );
                  },
                ),
                IconButton(
                  tooltip: 'PDF de todas as frases',
                  icon: const Icon(AppIconData.print),
                  onPressed: () {
                    List<PhraseModel> list =
                        context.read<LearnPhrasesBloc>().state.list;

                    Navigator.of(context).pushNamed('/pdf/all', arguments: {
                      'userProfile': person,
                      'phrases': list,
                    });
                  },
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: BlocBuilder<LearnPhrasesBloc, LearnPhrasesState>(
                  builder: (context, state) {
                    if (state.isSortedByFolder) {
                      return FolderOrder(
                          phraseList: state.list,
                          cardOrder: (value) {
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
            ),
          ],
        ),
      ),
    );
  }
}
