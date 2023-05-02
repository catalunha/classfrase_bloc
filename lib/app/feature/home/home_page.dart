import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/authentication/bloc/authentication_bloc.dart';
import 'comp/home_popmenu.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }

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
        body: Container());
  }
}
