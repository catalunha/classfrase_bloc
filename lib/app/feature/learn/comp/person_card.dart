import 'package:flutter/material.dart';

import '../../utils/app_icon.dart';

class PersonCard extends StatelessWidget {
  final String? community;
  final String? displayName;
  final String? photoURL;
  final String email;
  final String? id;
  final String? uid;
  final Widget? trailing;
  VoidCallback? onTap;

  PersonCard({
    Key? key,
    required this.email,
    this.community,
    this.displayName,
    this.photoURL,
    this.id,
    this.uid,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            photoURL ?? '',
            height: 58,
            width: 58,
            errorBuilder: (_, a, b) {
              return const SizedBox(
                  height: 58, width: 58, child: Icon(AppIconData.undefined));
            },
          ),
        ),
        title: Text(
          displayName ?? 'Nome não informado',
        ),
        subtitle: Text(
          '$email\n${community ?? "..."}',
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
