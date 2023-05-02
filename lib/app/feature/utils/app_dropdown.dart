import 'package:flutter/material.dart';

class AppDropDown extends StatelessWidget {
  final String? title;
  final bool enabled;
  final List<dynamic> options;
  final dynamic selected;
  final Function(dynamic) execute;
  final double height;
  final double width;
  const AppDropDown({
    Key? key,
    this.title,
    this.enabled = true,
    required this.options,
    this.selected,
    required this.execute,
    this.height = 30,
    this.width = 170,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        title != null ? Text(title!) : const SizedBox(),
        enabled
            ? Container(
                height: height,
                width: width,
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(style: BorderStyle.solid, width: 0.80),
                ),
                child: Center(
                  child: DropdownButton<dynamic>(
                    value: selected,
                    icon: const Icon(Icons.arrow_downward),
                    underline: Container(
                      height: 0,
                      color: Colors.deepPurpleAccent,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    onChanged: (dynamic newValue) {
                      execute(newValue);
                    },
                    items:
                        options.map<DropdownMenuItem<dynamic>>((dynamic value) {
                      return DropdownMenuItem<dynamic>(
                        value: value,
                        child: Text('${value?.name}'),
                        // child: Text('${value!.name} - ${value.description}'),
                      );
                    }).toList(),
                  ),
                ),
              )
            : const SizedBox(width: 50, height: 60),
      ],
    );
  }
}
