import 'package:flutter/material.dart';

import '../../../utils/app_icon.dart';

class PersonTile extends StatelessWidget {
  final String? community;
  final String? displayName;
  final String? photoURL;
  final String email;
  final String? id;
  final String? uid;
  final Widget? trailingIconButton;

  const PersonTile({
    Key? key,
    required this.community,
    required this.displayName,
    required this.photoURL,
    required this.email,
    this.id,
    this.uid,
    this.trailingIconButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: photoURL == null
          ? const SizedBox(
              height: 58, width: 58, child: Icon(AppIconData.undefined))
          : ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                photoURL!,
                height: 58,
                width: 58,
              ),
            ),
      title: Text(
        displayName ?? 'Nome não informado',
      ),
      subtitle: Text(
        '$email\n${community ?? "..."}',
      ),
      // trailing: trailingIconButton,
    );
  }
}
