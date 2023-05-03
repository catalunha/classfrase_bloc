import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';

import '../../../feature/utils/app_assets.dart';
import '../../models/catclass_model.dart';
import 'cat_class_event.dart';
import 'cat_class_state.dart';

class CatClassBloc extends Bloc<CatClassEvent, CatClassState> {
  CatClassBloc() : super(CatClassState.initial()) {
    on<CatClassEventStart>(_onCatClassEventStart);
    on<CatClassEventFilterBy>(_onCatClassEventFilterBy);
    add(CatClassEventStart());
  }

  FutureOr<void> _onCatClassEventStart(
      CatClassEventStart event, Emitter<CatClassState> emit) async {
    dynamic data = await _loadJsonCategory();
    List<CatClassModel> temp = [];

    for (var element in data) {
      temp.add(CatClassModel.fromMap(element));
    }
    _categoryAll = [...temp];
    for (var i = 0; i < temp.length; i++) {
      temp[i].ordem = getParent(ngb: temp[i]);
    }
    emit(state.copyWith(categoryAll: temp));

    add(CatClassEventFilterBy(filter: 'ngb'));
  }

  Future<dynamic> _loadJsonCategory() async {
    var jsonData = await rootBundle.loadString(AppAssets.catclass);
    final data = json.decode(jsonData);
    return data;
  }

  final List<String> _categoryParentList = [];
  List<CatClassModel> _categoryAll = [];

  String getParent({required CatClassModel ngb, String delimiter = ' - '}) {
    _categoryParentList.clear();
    List<String> ordemList = _getParents(ngb);
    String ordem = ordemList.reversed.join(delimiter);
    return ordem;
  }

  List<String> _getParents(CatClassModel ngb) {
    _categoryParentList.add(ngb.name);
    CatClassModel? ngbParent =
        _categoryAll.firstWhereOrNull((element) => element.id == ngb.parent);

    if (ngbParent != null) {
      _getParents(ngbParent);
    }
    return _categoryParentList;
  }

  FutureOr<void> _onCatClassEventFilterBy(
      CatClassEventFilterBy event, Emitter<CatClassState> emit) {
    emit(state.copyWith(selectedFilter: event.filter));
    List<CatClassModel> categoryTemp = state.categoryAll
        .where((element) => element.filter.contains(event.filter))
        .toList();
    emit(state.copyWith(category: categoryTemp));
  }
}
