import 'package:classfrase/app/domain/models/catclass_model.dart';
import 'package:classfrase/app/domain/models/phrase_classification_model.dart';
import 'package:classfrase/app/presentation/services/classification/classification_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

List<InlineSpan> buildPhrase({
  required BuildContext context,
  required List<String> phraseList,
  required List<int> selectedPhrasePosList,
  Function(int)? onSelectPhrase,
  VoidCallback? setState,
}) {
  List<InlineSpan> list = [];
  for (var wordPos = 0; wordPos < phraseList.length; wordPos++) {
    if (phraseList[wordPos] != ' ') {
      list.add(TextSpan(
        text: phraseList[wordPos],
        style: selectedPhrasePosList.contains(wordPos)
            ? TextStyle(
                color: Colors.orange.shade900,
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.solid,
              )
            : null,
        recognizer: onSelectPhrase == null
            ? null
            : (TapGestureRecognizer()
              ..onTap = () {
                setState!();
                onSelectPhrase(wordPos);
              }),
      ));
    } else {
      list.add(TextSpan(
        text: phraseList[wordPos],
      ));
    }
  }

  return list;
}

List<Widget> showClassifications({
  required Map<String, Classification> phraseClassifications,
  required List<String> classOrder,
  required List<String> phraseList,
  Function(int)? onSelectPhrase,
}) {
  List<Widget> lineList = [];

  for (var classId in classOrder) {
    Classification classification = phraseClassifications[classId]!;
    List<int> posPhraseList = classification.posPhraseList;
    List<InlineSpan> listSpan = [];
    //+++ escrevendo a frase destacando a parte classificada
    for (var i = 0; i < phraseList.length; i++) {
      listSpan.add(
        TextSpan(
          text: phraseList[i],
          style: phraseList[i] != ' ' && posPhraseList.contains(i)
              ? TextStyle(
                  color: Colors.orange.shade900,
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.solid,
                )
              : null,
        ),
      );
    }
    RichText richText = RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 28, color: Colors.black),
        children: listSpan,
      ),
    );

    List<String> categoryIdList = classification.categoryIdList;
    List<String> classOrdemList = [];
    ClassificationService classificationService = Get.find();
    for (var id in categoryIdList) {
      CatClassModel? catClassModel = classificationService.categoryAll
          .firstWhereOrNull((catClass) => catClass.id == id);
      if (catClassModel != null) {
        classOrdemList.add(catClassModel.ordem);
      }
    }
    classOrdemList.sort();

    List<Widget> classOrdemWidgetList = [];
    for (var categoryTitle in classOrdemList) {
      classOrdemWidgetList.add(Text(
        categoryTitle,
      ));
    }

    lineList.add(
      Container(
        alignment: Alignment.topCenter,
        key: ValueKey(classId),
        child: Card(
          elevation: 25,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: GestureDetector(
                    onTap: onSelectPhrase != null
                        ? () {
                            // widget._classifyingController
                            //     .onSelectNonePhrase();
                            for (var index in posPhraseList) {
                              onSelectPhrase(index);
                            }
                          }
                        : null,
                    child: Row(
                      children: [richText],
                    ),
                  ),
                ),
                ...classOrdemWidgetList,
              ],
            ),
          ),
        ),
      ),
    );
  }
  return lineList;
}
