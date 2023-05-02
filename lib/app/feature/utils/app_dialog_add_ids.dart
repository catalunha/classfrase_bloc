import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';

import 'app_textformfield.dart';

class AppDialogAddIds extends StatefulWidget {
  final String title;
  final String formFieldLabel;
  const AppDialogAddIds({
    Key? key,
    required this.title,
    this.formFieldLabel = '',
  }) : super(key: key);

  @override
  State<AppDialogAddIds> createState() => _AppDialogAddIdsState();
}

class _AppDialogAddIdsState extends State<AppDialogAddIds> {
  final _formKey = GlobalKey<FormState>();
  final _objectIdTEC = TextEditingController();
  @override
  void initState() {
    super.initState();
    _objectIdTEC.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.title),
                AppTextFormField(
                  label: widget.formFieldLabel,
                  controller: _objectIdTEC,
                  validator: Validatorless.required('Informação obrigatória'),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancelar')),
                    const SizedBox(
                      width: 50,
                    ),
                    TextButton(
                        onPressed: () async {
                          // Get.back(result: _objectIdTEC.text);
                        },
                        child: const Text('Buscar')),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
