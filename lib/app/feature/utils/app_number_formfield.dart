import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppNumberFormField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  const AppNumberFormField({
    Key? key,
    required this.label,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        onChanged: onChanged,
        // onChanged: (value) {
        //   controller!.text = '${double.parse(controller!.text) + 1}';
        //   ////print(value);
        // },
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[+-\d+\.]+')),
          // FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        ],
        // cursorColor: context.theme.primaryColor,
        decoration: InputDecoration(
          isDense: true,
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.black,
          ),
          errorStyle: const TextStyle(
            color: Colors.redAccent,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(23),
            borderSide: const BorderSide(
              color: Color(0xFFBDBDBD),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(23),
            borderSide: const BorderSide(
              color: Color(0xFFBDBDBD),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(23),
            borderSide: const BorderSide(
              color: Color(0xFFBDBDBD),
            ),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
