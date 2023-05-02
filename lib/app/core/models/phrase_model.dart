import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'phrase_classification_model.dart';
import 'user_profile_model.dart';

class PhraseModel {
  final String? id;
  final UserProfileModel userProfile;
  final String phrase;
  List<String> phraseList;

  final Map<String, Classification> classifications;
  final List<String> classOrder;

  final List<String>? allCategoryList;
  final String folder;
  final String? font;
  final String? diagramUrl;
  final String? note;

  final bool isArchived;
  final bool isPublic;
  PhraseModel({
    this.id,
    required this.userProfile,
    required this.phrase,
    required this.phraseList,
    required this.classifications,
    required this.classOrder,
    this.allCategoryList,
    this.folder = '/',
    this.font,
    this.diagramUrl,
    this.note,
    this.isArchived = false,
    this.isPublic = false,
  });

  PhraseModel copyWith({
    String? id,
    UserProfileModel? userProfile,
    String? phrase,
    List<String>? phraseList,
    Map<String, Classification>? classifications,
    List<String>? classOrder,
    List<String>? allCategoryList,
    String? folder,
    String? font,
    String? diagramUrl,
    String? note,
    bool? isArchived,
    bool? isPublic,
  }) {
    return PhraseModel(
      id: id ?? this.id,
      userProfile: userProfile ?? this.userProfile,
      phrase: phrase ?? this.phrase,
      phraseList: phraseList ?? this.phraseList,
      classifications: classifications ?? this.classifications,
      classOrder: classOrder ?? this.classOrder,
      allCategoryList: allCategoryList ?? this.allCategoryList,
      folder: folder ?? this.folder,
      font: font ?? this.font,
      diagramUrl: diagramUrl ?? this.diagramUrl,
      note: note ?? this.note,
      isArchived: isArchived ?? this.isArchived,
      isPublic: isPublic ?? this.isPublic,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    result.addAll({'userProfile': userProfile.toMap()});
    result.addAll({'phrase': phrase});
    result.addAll({'phraseList': phraseList});
    result.addAll({'classifications': classifications});
    result.addAll({'classOrder': classOrder});
    if (allCategoryList != null) {
      result.addAll({'allCategoryList': allCategoryList});
    }
    result.addAll({'folder': folder});
    if (font != null) {
      result.addAll({'font': font});
    }
    if (diagramUrl != null) {
      result.addAll({'diagramUrl': diagramUrl});
    }
    if (note != null) {
      result.addAll({'note': note});
    }
    result.addAll({'isArchived': isArchived});
    result.addAll({'isPublic': isPublic});

    return result;
  }

  factory PhraseModel.fromMap(Map<String, dynamic> map) {
    return PhraseModel(
      id: map['id'],
      userProfile: UserProfileModel.fromMap(map['userProfile']),
      phrase: map['phrase'] ?? '',
      phraseList: List<String>.from(map['phraseList']),
      classifications: Map<String, Classification>.from(map['classifications']),
      classOrder: List<String>.from(map['classOrder']),
      allCategoryList: List<String>.from(map['allCategoryList']),
      folder: map['folder'] ?? '',
      font: map['font'],
      diagramUrl: map['diagramUrl'],
      note: map['note'],
      isArchived: map['isArchived'] ?? false,
      isPublic: map['isPublic'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory PhraseModel.fromJson(String id, String source) =>
      PhraseModel.fromMap(json.decode(source));

  static List<String> setPhraseList(String phrase) {
    String word = '';
    List<String> phraseList = [];
    for (var i = 0; i < phrase.length; i++) {
      if (phrase[i].contains(RegExp(
          r"[A-Za-záàãâäāăÁÀÃÂÄĀĂéèêëẽēĕÉÈÊËẼĒĔíìîïĩīĭÍÌÎÏĨĪĬóòõôöōŏÓÒÕÖÔŌŎúùûüũūŭŨÚÙÛÜŪŬçÇñÑ0123456789]"))) {
        word += phrase[i];
      } else {
        if (word.isNotEmpty) {
          phraseList.add(word);
          word = '';
        }
        phraseList.add(phrase[i]);
      }
    }
    if (word.isNotEmpty) {
      phraseList.add(word);
      word = '';
    }
    return phraseList;
  }

  static List<String> setAllCategoryList(
      Map<String, Classification> classifications) {
    List<String> allCategoryList = [];
    for (var item in classifications.entries) {
      allCategoryList.addAll(item.value.categoryIdList);
    }
    return allCategoryList;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PhraseModel &&
        other.id == id &&
        other.userProfile == userProfile &&
        other.phrase == phrase &&
        listEquals(other.phraseList, phraseList) &&
        mapEquals(other.classifications, classifications) &&
        listEquals(other.classOrder, classOrder) &&
        listEquals(other.allCategoryList, allCategoryList) &&
        other.folder == folder &&
        other.font == font &&
        other.diagramUrl == diagramUrl &&
        other.note == note &&
        other.isArchived == isArchived &&
        other.isPublic == isPublic;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userProfile.hashCode ^
        phrase.hashCode ^
        phraseList.hashCode ^
        classifications.hashCode ^
        classOrder.hashCode ^
        allCategoryList.hashCode ^
        folder.hashCode ^
        font.hashCode ^
        diagramUrl.hashCode ^
        note.hashCode ^
        isArchived.hashCode ^
        isPublic.hashCode;
  }

  @override
  String toString() {
    return 'PhraseModel(id: $id, userProfile: $userProfile, phrase: $phrase, phraseList: $phraseList, classifications: $classifications, classOrder: $classOrder, allCategoryList: $allCategoryList, folder: $folder, font: $font, diagramUrl: $diagramUrl, note: $note, isArchived: $isArchived, isPublic: $isPublic)';
  }
}
