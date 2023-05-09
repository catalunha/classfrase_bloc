import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';

import '../../../core/category_classification/bloc/cat_class_bloc.dart';
import '../../../core/category_classification/bloc/cat_class_event.dart';
import '../../../core/category_classification/bloc/cat_class_state.dart';
import '../../../core/models/catclass_model.dart';
import 'bloc/learn_phrases_bloc.dart';
import 'bloc/learn_phrases_event.dart';
import 'bloc/learn_phrases_state.dart';

class CategoriesByPersonPage extends StatefulWidget {
  const CategoriesByPersonPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CategoriesByPersonPage> createState() => _CategoriesByPersonPageState();
}

class _CategoriesByPersonPageState extends State<CategoriesByPersonPage> {
  final TreeController _controller = TreeController(allNodesExpanded: false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classificações que usei'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              child: BlocBuilder<LearnPhrasesBloc, LearnPhrasesState>(
                builder: (context, state) {
                  return SingleChildScrollView(child: buildTree(state));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTree(LearnPhrasesState state) {
    List<TreeNode> nodes = createTree(state);
    const Key key = ValueKey(22);
    _controller.expandNode(key);

    return TreeView(
      treeController: _controller,
      nodes: nodes,
    );
  }

  List<TreeNode> createTree(LearnPhrasesState state) {
    List<TreeNode> treeNodeList = [];
    treeNodeList.clear();
    treeNodeList.add(
      childrenNodes(null, state),
    );

    return treeNodeList;
  }

  TreeNode childrenNodes(CatClassModel? ngb, LearnPhrasesState state) {
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

  Widget widgetForTree(CatClassModel ngbTemp, LearnPhrasesState state) {
    return InkWell(
        child: Text(
          ngbTemp.name,
          style: TextStyle(
              color: state.selectedCategoryIdList.contains(ngbTemp.id)
                  ? Colors.orange
                  : null),
        ),
        onTap: () {
          context
              .read<LearnPhrasesBloc>()
              .add(LearnPhrasesEventFilterPhasesByThisCategory(ngbTemp.id));
          Navigator.of(context).pop();
        });
  }
}
