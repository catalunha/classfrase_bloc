import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'category_group_model.dart';
import 'category_model.dart';

class ClassificationModel {
  final Map<String, ClassGroup> group;
  final Map<String, ClassCategory> category;

  ClassificationModel({
    required this.group,
    required this.category,
  });

  List<ClassGroup> selectGroupListSorted() {
    // ClassificationService classificationService = Get.find();
    // Map<String, ClassGroup> group = classificationService.classification.group;
    List<ClassGroup> groupListTemp = group.entries.map((e) => e.value).toList();
    groupListTemp.sort((a, b) => a.title.compareTo(b.title));
    return groupListTemp;
  }

  ClassificationModel copyWith({
    Map<String, ClassGroup>? group,
    Map<String, ClassCategory>? category,
  }) {
    return ClassificationModel(
      group: group ?? this.group,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["group"] = <String, dynamic>{};
    for (var item in group.entries) {
      data["group"][item.key] = item.value.toMap();
    }
    data["category"] = <String, dynamic>{};
    for (var item in category.entries) {
      data["category"][item.key] = item.value.toMap();
    }
    return data;
  }

  factory ClassificationModel.fromMap(Map<String, dynamic> map) {
    var groupMapTemp = <String, ClassGroup>{};
    if (map["group"] is Map && map["group"] != null) {
      for (var item in map["group"].entries) {
        groupMapTemp[item.key] =
            ClassGroup.fromMap(item.value).copyWith(id: item.key);
      }
    }
    var categoryTemp = <String, ClassCategory>{};
    if (map["category"] is Map && map["category"] != null) {
      for (var item in map["category"].entries) {
        categoryTemp[item.key] =
            ClassCategory.fromMap(item.value).copyWith(id: item.key);
      }
    }
    var temp = ClassificationModel(
      group: groupMapTemp,
      category: categoryTemp,
    );
    return temp;
  }

  String toJson() => json.encode(toMap());

  factory ClassificationModel.fromJson(String source) =>
      ClassificationModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ClassificationModel(group: $group, category: $category)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ClassificationModel &&
        mapEquals(other.group, group) &&
        mapEquals(other.category, category);
  }

  @override
  int get hashCode => group.hashCode ^ category.hashCode;
}
