import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_icon.dart';

class AppLink extends StatelessWidget {
  final String? url;
  final String? tooltipMsg;
  final IconData? icon;
  const AppLink({
    Key? key,
    required this.url,
    this.icon = AppIconData.linkOn,
    this.tooltipMsg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return url != null && url!.isNotEmpty
        ? IconButton(
            tooltip: tooltipMsg,
            onPressed: () async {
              try {
                final Uri uri = Uri.parse(url!);
                await launchUrl(uri);
              } catch (e) {
                //
              }
            },
            icon: Icon(icon))
        : Container(
            width: 1,
          );
  }
}
