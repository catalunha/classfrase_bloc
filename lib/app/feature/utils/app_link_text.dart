import 'package:flutter/material.dart';

import 'app_launch.dart';

class AppLinkText extends StatelessWidget {
  final String? url;
  final String? text;
  const AppLinkText({
    Key? key,
    required this.url,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return url != null && url!.isNotEmpty
        ? InkWell(
            onTap: () async {
              AppLaunch.launchLink(url!);
            },
            child: Text(
              text ?? 'Clique aqui.',
              style: const TextStyle(color: Colors.blue),
            ),
          )
        : const Text('Link Indisponível');
  }
}
