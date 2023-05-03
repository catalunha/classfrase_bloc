import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/authentication/bloc/authentication_bloc.dart';
import '../../core/category_classification/bloc/cat_class_bloc.dart';
import '../../core/models/phrase_model.dart';
import '../../core/models/user_profile_model.dart';
import '../../core/repositories/phrase_repository.dart';
import '../phrase/list/bloc/phrase_list_bloc.dart';
import '../phrase/list/bloc/phrase_list_event.dart';
import '../phrase/list/comp/phrase_list.dart';
import '../utils/app_icon.dart';
import 'comp/home_popmenu.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PhraseRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) {
              UserProfileModel userProfile =
                  context.read<AuthenticationBloc>().state.user!.profile!;
              return PhraseListBloc(
                repository: RepositoryProvider.of<PhraseRepository>(context),
                userProfile: userProfile,
              );
            },
          ),
          BlocProvider(
            create: (context) => CatClassBloc(),
          ),
        ],
        child: const HomeView(),
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            return Text(
                "Olá, ${state.user?.profile?.name ?? 'Atualize seu perfil.'}.");
          },
        ),
        actions: const [
          HomePopMenu(),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Tooltip(
                  message:
                      'Clique aqui para criar uma frase e depois classificá-la.',
                  child: SizedBox(
                    width: 170,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        //=> widget._phraseController.add(),
                      },
                      icon: const Icon(AppIconData.phrase),
                      label: const Text('Criar frase.'),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const SizedBox(width: 10),
                Tooltip(
                  message:
                      'Clique aqui para aprender com a classificação de outras pessoas.',
                  child: SizedBox(
                    width: 170,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // => Get.toNamed(Routes.learnList),
                      },
                      icon: const Icon(AppIconData.learn),
                      label: const Text('Aprender.'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              IconButton(
                tooltip: 'Ordem alfabética das frases',
                icon: const Icon(AppIconData.sortAlpha),
                onPressed: () {
                  context
                      .read<PhraseListBloc>()
                      .add(PhraseListEventSortAlpha());
                },
              ),
              IconButton(
                tooltip: 'Ordem por folder das frases',
                icon: const Icon(AppIconData.sortFolder),
                onPressed: () {
                  context
                      .read<PhraseListBloc>()
                      .add(PhraseListEventSortFolder());
                },
              ),
              IconButton(
                tooltip: 'PDF de todas as frases',
                icon: const Icon(AppIconData.print),
                onPressed: () {
                  List<PhraseModel> phraseList =
                      context.read<PhraseListBloc>().state.list;
                  Navigator.of(context)
                      .pushNamed('/pdf/all', arguments: phraseList);
                },
              ),
              IconButton(
                tooltip: 'Minhas frases arquivadas',
                icon: const Icon(AppIconData.box),
                onPressed: () {},
              ),
            ],
          ),
          const Expanded(
            child: PhraseList(),
          ),
        ],
      ),
    );
  }
}
