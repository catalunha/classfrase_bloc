import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'category_group_model.dart';

class ClassCategory {
  final String? id;
  final String title;
  final String? description;
  final List<String>? filter;
  final String? url;
  final ClassGroup group;
  ClassCategory({
    this.id,
    required this.title,
    this.description,
    this.filter,
    this.url,
    required this.group,
  });

  ClassCategory copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? filter,
    String? url,
    ClassGroup? group,
  }) {
    return ClassCategory(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      filter: filter ?? this.filter,
      url: url ?? this.url,
      group: group ?? this.group,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'filter': filter,
      'url': url,
      'group': group.toMap(),
    };
  }

  factory ClassCategory.fromMap(Map<String, dynamic> map) {
    return ClassCategory(
      id: map['id'],
      title: map['title'] ?? '',
      description: map['description'],
      filter: List<String>.from(map['filter']),
      url: map['url'],
      group: ClassGroup.fromMap(map['group']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassCategory.fromJson(String source) =>
      ClassCategory.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ClassCategory(id: $id, title: $title, description: $description, filter: $filter, url: $url, group: $group)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ClassCategory &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        listEquals(other.filter, filter) &&
        other.url == url &&
        other.group == group;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        filter.hashCode ^
        url.hashCode ^
        group.hashCode;
  }
}
