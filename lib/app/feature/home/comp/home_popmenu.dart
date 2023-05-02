import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/authentication/authentication.dart';
import '../../../core/models/user_model.dart';

class HomePopMenu extends StatelessWidget {
  const HomePopMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: Offset.fromDirection(120.0, 70.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            child: TextButton.icon(
              label: const Text('Editar perfil'),
              onPressed: () {
                Navigator.pop(context);
                UserModel user = context.read<AuthenticationBloc>().state.user!;
                Navigator.of(context)
                    .pushNamed('/userProfile/edit', arguments: user);
              },
              icon: const Icon(Icons.person_outline_outlined),
            ),
          ),
          PopupMenuItem(
            child: TextButton.icon(
              label: const Text('Sair'),
              onPressed: () {
                Navigator.pop(context);
                context
                    .read<AuthenticationBloc>()
                    .add(AuthenticationEventLogoutRequested());
              },
              icon: const Icon(Icons.exit_to_app),
            ),
          ),
        ];
      },
      child: Tooltip(
        message: 'Click para ver opções',
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                return UserPhoto(url: state.user?.profile?.photo);
              },
            )),
      ),
    );
  }
}

class UserPhoto extends StatelessWidget {
  final String? url;
  const UserPhoto({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return url != null
        ? Image.network(
            url!,
            height: 40,
            width: 40,
            errorBuilder: (_, __, ___) {
              return const Icon(
                Icons.person,
                // color: Colors.black,
              );
            },
          )
        : const Align(
            alignment: Alignment.center,
            child: Text(
              ':-) ',
              style: TextStyle(fontSize: 20),
            ),
          );
  }
}
