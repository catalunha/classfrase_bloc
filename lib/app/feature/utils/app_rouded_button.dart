import 'package:flutter/material.dart';

class AppRoudedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final double fontSize;
  const AppRoudedButton(
      {Key? key,
      required this.onPressed,
      required this.label,
      this.fontSize = 25})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(), backgroundColor: Colors.white,
      ),
      child: Text(
        label,
        style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: fontSize),
      ),
    );
  }
}
