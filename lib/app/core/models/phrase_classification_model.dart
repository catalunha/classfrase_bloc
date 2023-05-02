import 'dart:convert';

import 'package:flutter/foundation.dart';

class Classification {
  final List<int> posPhraseList;
  final List<String> categoryIdList;
  Classification({
    required this.posPhraseList,
    required this.categoryIdList,
  });

  Classification copyWith({
    List<int>? posPhraseList,
    List<String>? categoryIdList,
  }) {
    return Classification(
      posPhraseList: posPhraseList ?? this.posPhraseList,
      categoryIdList: categoryIdList ?? this.categoryIdList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'posPhraseList': posPhraseList,
      'categoryIdList': categoryIdList,
    };
  }

  factory Classification.fromMap(Map<String, dynamic> map) {
    return Classification(
      posPhraseList: List<int>.from(map['posPhraseList']),
      categoryIdList: List<String>.from(map['categoryIdList']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Classification.fromJson(String source) =>
      Classification.fromMap(json.decode(source));

  @override
  String toString() =>
      'Classification(posPhraseList: $posPhraseList, categoryIdList: $categoryIdList)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Classification &&
        listEquals(other.posPhraseList, posPhraseList) &&
        listEquals(other.categoryIdList, categoryIdList);
  }

  @override
  int get hashCode => posPhraseList.hashCode ^ categoryIdList.hashCode;
}
