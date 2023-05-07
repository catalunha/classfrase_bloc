import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/authentication/authentication.dart';
import '../utils/app_assets.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SplashPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) {
          if (state.status == AuthenticationStatus.unauthenticated) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error)));
            context
                .read<AuthenticationBloc>()
                .add(AuthenticationEventLogoutRequested());
          }
        },
        child: Center(
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state.status == AuthenticationStatus.databaseError) {
                return Text(state.error);
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppAssets.splash,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Analisando seus dados...'),
                  const SizedBox(
                    height: 20,
                  ),
                  const CircularProgressIndicator(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
