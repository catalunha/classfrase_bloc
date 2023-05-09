import 'package:classfrase_bloc/app/feature/classifying/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';

import '../../core/category_classification/bloc/cat_class_bloc.dart';
import '../../core/category_classification/bloc/cat_class_event.dart';
import '../../core/category_classification/bloc/cat_class_state.dart';
import '../../core/models/catclass_model.dart';
import '../utils/app_icon.dart';
import 'bloc/classifying_bloc.dart';
import 'bloc/classifying_event.dart';
import 'bloc/classifying_state.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final TreeController _controller = TreeController(allNodesExpanded: false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolhendo a classificação'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 28, color: Colors.black),
                  children: buildPhrase(
                    context: context,
                    phraseList:
                        context.read<ClassifyingBloc>().state.model.phraseList!,
                    selectedPhrasePosList: context
                        .read<ClassifyingBloc>()
                        .state
                        .selectedPosPhraseList,
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Container(
              //   padding: const EdgeInsets.only(left: 10, right: 10),
              //   color: Colors.black12,
              //   child: const Text('Filtros e ações: '),
              // ),
              // const SizedBox(
              //   width: 10,
              // ),
              Tooltip(
                message: 'Classificações encontradas na NGB e outras',
                child: BlocBuilder<CatClassBloc, CatClassState>(
                  builder: (context, state) {
                    return TextButton(
                        onPressed: () {
                          setState(() {});
                          context
                              .read<CatClassBloc>()
                              .add(CatClassEventFilterBy('ngb'));
                        },
                        child: Text(
                          'NGB',
                          style: TextStyle(
                              color: state.selectedFilter == 'ngb'
                                  ? Colors.green
                                  : Colors.black),
                        ));
                  },
                ),
              ),
              Tooltip(
                message: 'Classificações mais comuns ao CC e outras',
                child: BlocBuilder<CatClassBloc, CatClassState>(
                  builder: (context, state) {
                    return TextButton(
                        onPressed: () {
                          setState(() {});
                          context
                              .read<CatClassBloc>()
                              .add(CatClassEventFilterBy('cc'));
                        },
                        child: Text(
                          'CC',
                          style: TextStyle(
                              color: state.selectedFilter == 'cc'
                                  ? Colors.green
                                  : Colors.black),
                        ));
                  },
                ),
              ),
              Tooltip(
                message: 'Classificações mais comuns em latin',
                child: BlocBuilder<CatClassBloc, CatClassState>(
                  builder: (context, state) {
                    return TextButton(
                        onPressed: () {
                          setState(() {});
                          context
                              .read<CatClassBloc>()
                              .add(CatClassEventFilterBy('latin'));
                        },
                        child: Text(
                          'LATIN',
                          style: TextStyle(
                              color: state.selectedFilter == 'latin'
                                  ? Colors.green
                                  : Colors.black),
                        ));
                  },
                ),
              ),
              Tooltip(
                message: 'Encolher toda a lista',
                child: SizedBox(
                  width: 30,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _controller.collapseAll();
                        const Key key = ValueKey(22);
                        _controller.expandNode(key);
                      });
                    },
                    icon: Icon(Icons.close_fullscreen_sharp,
                        size: 15,
                        color: _controller.allNodesExpanded
                            ? Colors.black
                            : Colors.green),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Tooltip(
                message: 'Expandir toda a lista',
                child: SizedBox(
                  // color: Colors.red,
                  width: 30,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _controller.expandAll();
                      });
                    },
                    icon: Icon(Icons.open_in_full,
                        size: 15,
                        color: !_controller.allNodesExpanded
                            ? Colors.black
                            : Colors.green),
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: BlocBuilder<ClassifyingBloc, ClassifyingState>(
                builder: (context, state) {
                  return SingleChildScrollView(child: buildTree(state));
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(AppIconData.saveInCloud),
        onPressed: () async {
          context
              .read<ClassifyingBloc>()
              .add(ClassifyingEventOnSaveClassification());
          context
              .read<ClassifyingBloc>()
              .add(ClassifyingEventOnSelectClearPhrase());
          // await widget._classifyingController.onSaveClassification();
          // widget._classifyingController.onSelectNonePhrase();
          Navigator.of(context).pop();
          // Get.back();
        },
      ),
    );
  }

  Widget buildTree(ClassifyingState state) {
    List<TreeNode> nodes = createTree(state);
    const Key key = ValueKey(22);
    _controller.expandNode(key);

    return TreeView(
      treeController: _controller,
      nodes: nodes,
    );
  }

  List<TreeNode> createTree(ClassifyingState state) {
    List<TreeNode> treeNodeList = [];
    treeNodeList.clear();
    treeNodeList.add(
      childrenNodes(null, state),
    );

    return treeNodeList;
  }

  TreeNode childrenNodes(CatClassModel? ngb, ClassifyingState state) {
    List<CatClassModel> sub = [];
    if (ngb == null) {
      sub = context
          .read<CatClassBloc>()
          .state
          .category
          .where((element) => element.parent == null)
          .toList();
    } else {
      sub = context
          .read<CatClassBloc>()
          .state
          .category
          .where((element) => element.parent == ngb.id)
          .toList();
    }
    CatClassModel ngbTemp =
        ngb ?? CatClassModel(id: '...', name: 'Classificações', filter: []);
    const Key key = ValueKey(22);

    if (sub.isNotEmpty) {
      return TreeNode(
          key: ngbTemp.id == '...' ? key : null,
          content: widgetForTree(ngbTemp, state),
          children: sub.map((e) => childrenNodes(e, state)).toList());
    }
    return TreeNode(
      content: widgetForTree(ngbTemp, state),
    );
  }

  Widget widgetForTree(CatClassModel ngbTemp, ClassifyingState state) {
    return InkWell(
        child: Text(
          ngbTemp.name,
          style: TextStyle(
              color: state.selectedCategoryIdList.contains(ngbTemp.id)
                  ? Colors.orange
                  : null),
        ),
        onTap: () => context
            .read<ClassifyingBloc>()
            .add(ClassifyingEventOnSelectCategory(ngbTemp.id)));
  }
}
