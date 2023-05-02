import 'dart:convert';

class CatClassModel {
  final String id;
  final String name;
  final String? parent;
  final List<String> filter;

  String ordem = '';
  bool isSelected = false;

  CatClassModel({
    required this.id,
    required this.name,
    this.parent,
    required this.filter,
  });

  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'parent': parent,
  //     'filter': filter,
  //   };
  // }

  factory CatClassModel.fromMap(Map<String, dynamic> map) {
    return CatClassModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      parent: map['parent'],
      filter: List<String>.from(map['filter']),
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    if (parent != null) {
      result.addAll({'parent': parent});
    }
    result.addAll({'filter': filter});
    // result.addAll({'ordem': ordem});

    return result;
  }

  // factory CatClassModel.fromMap(Map<String, dynamic> map) {
  //   return CatClassModel(
  //     id: map['id'] ?? '',
  //     name: map['name'] ?? '',
  //     parent: map['parent'],
  //     filter: List<String>.from(map['filter']),
  //     ordem: map['ordem'] ?? '',
  //     isSelected: map['isSelected'] ?? false,
  //   );
  // }

  String toJson() => json.encode(toMap());

  // factory CatClassModel.fromJson(String source) => CatClassModel.fromMap(json.decode(source));
}
