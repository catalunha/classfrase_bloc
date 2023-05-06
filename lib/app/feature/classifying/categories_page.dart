import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';

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
        title: const Text('Escolhendo classificação'),
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
                    phraseList: widget._classifyingController.phrase.phraseList,
                    selectedPhrasePosList:
                        widget._classifyingController.selectedPosPhraseList,
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                color: Colors.black12,
                child: const Text('Filtros e ações: '),
              ),
              const SizedBox(
                width: 10,
              ),
              Tooltip(
                message: 'Classificações encontradas na NGB e outras',
                child: SizedBox(
                  // color: Colors.red,
                  width: 30,
                  child: Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      child: Text(
                        'NGB',
                        style: TextStyle(
                            color:
                                widget._classificationService.selectedFilter ==
                                        'ngb'
                                    ? Colors.green
                                    : Colors.black),
                      ),
                      onTap: () {
                        widget._classificationService.categoryFilteredBy('ngb');
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Tooltip(
                message: 'Classificações mais comuns ao CC e outras',
                child: SizedBox(
                  // color: Colors.red,
                  width: 30,
                  child: Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      child: Text(
                        'CC',
                        style: TextStyle(
                            color:
                                widget._classificationService.selectedFilter ==
                                        'cc'
                                    ? Colors.green
                                    : Colors.black),
                      ),
                      onTap: () {
                        widget._classificationService.categoryFilteredBy('cc');
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Tooltip(
                message: 'Classificações mais comuns em latin',
                child: SizedBox(
                  // color: Colors.red,
                  width: 35,
                  child: Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      child: Text(
                        'Latin',
                        style: TextStyle(
                            color:
                                widget._classificationService.selectedFilter ==
                                        'latin'
                                    ? Colors.green
                                    : Colors.black),
                      ),
                      onTap: () {
                        widget._classificationService
                            .categoryFilteredBy('latin');
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Tooltip(
                message: 'Encolher toda a lista',
                child: SizedBox(
                  // color: Colors.red,
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
            child: Obx(() => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(child: buildTree()))),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(AppIconData.saveInCloud),
        onPressed: () async {
          await widget._classifyingController.onSaveClassification();
          widget._classifyingController.onSelectNonePhrase();

          Get.back();
        },
      ),
    );
  }

  Widget buildTree() {
    List<TreeNode> nodes = widget._classifyingController.createTree();
    const Key key = ValueKey(22);
    _controller.expandNode(key);

    return TreeView(
      treeController: _controller,
      nodes: nodes,
    );
  }
}
