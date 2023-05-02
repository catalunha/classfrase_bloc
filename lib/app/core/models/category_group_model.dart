import 'dart:convert';

import 'package:flutter/foundation.dart';

class ClassGroup {
  final String? id;
  final String title;
  final String? description;
  final List<String>? filter;
  final String? url;
  ClassGroup({
    this.id,
    required this.title,
    this.description,
    this.filter,
    this.url,
  });

  ClassGroup copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? filter,
    String? url,
  }) {
    return ClassGroup(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      filter: filter ?? this.filter,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'filter': filter,
      'url': url,
    };
  }

  factory ClassGroup.fromMap(Map<String, dynamic> map) {
    return ClassGroup(
      id: map['id'],
      title: map['title'] ?? '',
      description: map['description'],
      filter: List<String>.from(map['filter']),
      url: map['url'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassGroup.fromJson(String source) =>
      ClassGroup.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ClassGroup(id: $id, title: $title, description: $description, filter: $filter, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ClassGroup &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        listEquals(other.filter, filter) &&
        other.url == url;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        filter.hashCode ^
        url.hashCode;
  }
}
