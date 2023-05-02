import 'package:flutter/material.dart';

class AppLinearPercentIndicator extends StatelessWidget {
  final double percent;
  final double width;
  final double height;
  final Color progressColor;
  final Color backgroundColor;
  const AppLinearPercentIndicator({
    Key? key,
    required this.percent,
    this.width = 100,
    this.height = 20,
    this.progressColor = Colors.cyan,
    this.backgroundColor = Colors.cyanAccent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: backgroundColor,
          ),
        ),
        Container(
          width: width * percent,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: progressColor,
          ),
        ),
        SizedBox(
          width: width,
          height: height,
          child: Align(
              alignment: Alignment.center,
              child: Text(
                '${(percent * 100).toStringAsFixed(0)}%',
                style: const TextStyle(color: Colors.black),
              )),
        ),
      ],
    );
  }
}
