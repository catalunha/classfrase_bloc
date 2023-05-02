import 'package:flutter/material.dart';

class AppTextTitleValue extends StatelessWidget {
  final String title;
  final String? value;
  final bool inColumn;
  const AppTextTitleValue({
    Key? key,
    required this.title,
    required this.value,
    this.inColumn = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (inColumn) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              title,
              style: const TextStyle(color: Colors.blueGrey),
            ),
          ),
          Text(
            // value ?? '...',
            value != null && value!.isNotEmpty ? value! : '...',
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else {
      // return Row(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   children: [
      //     Text(
      //       title,
      //       style: const TextStyle(color: Colors.blueGrey),
      //     ),
      //     Text(
      //       // value ?? '...',
      //       value != null && value!.isNotEmpty ? value! : '...',
      //       style: const TextStyle(color: Colors.white),
      //       textAlign: TextAlign.center,
      //       softWrap: true,
      //     ),
      //   ],
      // );

      return RichText(
        text: TextSpan(
          text: title,
          style: const TextStyle(color: Colors.blueGrey),
          children: <InlineSpan>[
            TextSpan(
                text: value ?? '...',
                style: const TextStyle(color: Colors.white))
          ],
        ),
      );
    }
  }
}
