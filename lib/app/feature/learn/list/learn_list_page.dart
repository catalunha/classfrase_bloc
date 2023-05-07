import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/authentication/bloc/authentication_bloc.dart';
import '../../../core/models/user_profile_model.dart';
import '../../../core/repositories/learn_repository.dart';
import '../save/learn_save_page.dart';
import 'bloc/learn_list_bloc.dart';
import 'bloc/learn_list_event.dart';
import 'bloc/learn_list_state.dart';

class LearnListPage extends StatelessWidget {
  const LearnListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => LearnRepository(),
      child: BlocProvider(
        create: (context) {
          UserProfileModel userProfile =
              context.read<AuthenticationBloc>().state.user!.profile!;
          return LearnListBloc(
            userProfile: userProfile,
            repository: RepositoryProvider.of<LearnRepository>(context),
          );
        },
        child: const LearnListView(),
      ),
    );
  }
}

class LearnListView extends StatelessWidget {
  const LearnListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aprendendo com'),
      ),
      body: BlocListener<LearnListBloc, LearnListState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == LearnListStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == LearnListStateStatus.success) {
            Navigator.of(context).pop();
          }
          if (state.status == LearnListStateStatus.loading) {
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
            Expanded(
              child: BlocBuilder<LearnListBloc, LearnListState>(
                builder: (context, state) {
                  var list = state.list;

                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final item = list[index];
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).pushNamed('/learn/phrases',
                                arguments: item.person);
                          },
                          title: Text(item.person.email),
                          subtitle: Text('${item.person.name}'),
                          trailing: IconButton(
                            onPressed: () {
                              print('trailing');
                              context
                                  .read<LearnListBloc>()
                                  .add(LearnListEventDelete(item.id!));
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => BlocProvider.value(
                value: BlocProvider.of<LearnListBloc>(context),
                child: const LearnSavePage(),
              ),
            );
          },
          child: const Icon(Icons.add)),
    );
  }
}
