import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/models/phrase_model.dart';
import '../../core/repositories/phrase_repository.dart';
import 'bloc/classifying_bloc.dart';
import 'bloc/classifying_event.dart';
import 'bloc/classifying_state.dart';
import 'utils/utils.dart';

class ClassifyingPage extends StatelessWidget {
  final PhraseModel model;

  const ClassifyingPage({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PhraseRepository(),
      child: BlocProvider(
        create: (context) => ClassifyingBloc(
          model: model,
          repository: RepositoryProvider.of<PhraseRepository>(context),
        ),
        child: const ClassifyingView(),
      ),
    );
  }
}

class ClassifyingView extends StatefulWidget {
  const ClassifyingView({
    Key? key,
  }) : super(key: key);

  @override
  State<ClassifyingView> createState() => _ClassifyingViewState();
}

class _ClassifyingViewState extends State<ClassifyingView> {
  bool isHorizontal = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classificando esta frase'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Container(
                  color: Colors.black12,
                  child: const Center(
                    child: Text('Click em partes da frase.'),
                  ),
                ),
              ),
              IconButton(
                tooltip: 'ou clique aqui para selecionar a frase toda.',
                icon: const Icon(Icons.check_circle_outline),
                onPressed: () {
                  context
                      .read<ClassifyingBloc>()
                      .add(ClassifyingEventOnSelectAllPhrase());
                  // widget._classifyingController.onSelectAllPhrase();
                },
              ),
              IconButton(
                tooltip: 'ou clique aqui para limpar toda seleção.',
                icon: const Icon(Icons.highlight_off),
                onPressed: () {
                  context
                      .read<ClassifyingBloc>()
                      .add(ClassifyingEventOnSelectClearPhrase());
                  // widget._classifyingController.onSelectNonePhrase();
                },
              ),
              IconButton(
                tooltip: 'ou clique aqui para inverter seleção.',
                icon: const Icon(Icons.change_circle_outlined),
                onPressed: () {
                  context
                      .read<ClassifyingBloc>()
                      .add(ClassifyingEventOnSelectInversePhrase());
                  // widget._classifyingController.onSelectInversePhrase();
                },
              ),
            ],
          ),
          BlocBuilder<ClassifyingBloc, ClassifyingState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 28, color: Colors.black),
                      children: buildPhrase(
                        context: context,
                        phraseList: state.model.phraseList,
                        selectedPhrasePosList: state.selectedPosPhraseList,
                        onSelectPhrase:
                            widget._classifyingController.onSelectPhrase,
                        setState: setStateLocal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          ElevatedButton(
            onPressed: () async {
              if (widget
                  ._classifyingController.selectedPosPhraseList.isNotEmpty) {
                await widget._classifyingController
                    .onMarkCategoryIfAlreadyClassifiedInPos();
                Get.toNamed(Routes.phraseCategoryGroup);
              } else {
                const snackBar = SnackBar(
                  content: Text('Oops. Selecione um trecho da frase.'),
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              backgroundColor: Colors.orangeAccent,
            ),
            child: const Text(
              'Clique aqui para escolher classificações.',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          Container(
              color: Colors.black12,
              child: const Center(
                  child: Text('Você pode reordenar as partes já classificadas.',
                      style: TextStyle(fontSize: 12)))),
          Expanded(
            child: Obx(() => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ReorderableListView(
                    onReorder: _onReorder,
                    children: showClassifications(
                      phraseClassifications:
                          widget._classifyingController.phrase.classifications,
                      classOrder:
                          widget._classifyingController.phrase.classOrder,
                      phraseList:
                          widget._classifyingController.phrase.phraseList,
                      onSelectPhrase:
                          widget._classifyingController.onSelectPhrase,
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
    });
    List<String> classOrderTemp =
        widget._classifyingController.phrase.classOrder;
    String resourceId = classOrderTemp[oldIndex];
    classOrderTemp.removeAt(oldIndex);
    classOrderTemp.insert(newIndex, resourceId);
    widget._classifyingController.onChangeClassOrder(classOrderTemp);
  }

  void setStateLocal() {
    setState(() {});
  }
}
