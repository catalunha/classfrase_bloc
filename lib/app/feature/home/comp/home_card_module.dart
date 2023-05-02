import 'package:flutter/material.dart';

import '../../../core/utils/allowed_access.dart';

class HomeCardModule extends StatelessWidget {
  final List<String> access;
  final Function()? onAction;
  final String title;
  final IconData icon;
  final Color color;
  final List<Widget>? actions;
  const HomeCardModule({
    Key? key,
    required this.access,
    this.onAction,
    required this.title,
    required this.icon,
    required this.color,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (GetModuleAllowedAccess.consultFor(access, context)) {
      return InkWell(
        onTap: onAction,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            width: 150,
            height: 150,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: color,
            ),
            child: Column(children: [
              Icon(
                icon,
                size: 50,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
              ),
              Wrap(
                children: actions ?? [],
              )
            ]),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
