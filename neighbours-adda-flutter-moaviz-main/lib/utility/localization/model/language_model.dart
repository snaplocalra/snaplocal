// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:snap_local/utility/localization/model/language_enum.dart';

class LanguageListModel {
  final List<LanguageModel> languages;
  LanguageListModel(this.languages);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'languages': languages.map((x) => x.toMap()).toList(),
    };
  }

  factory LanguageListModel.fromMap(Map<String, dynamic> map) {
    return LanguageListModel(List<LanguageModel>.from(map['languages']
        .map<LanguageModel>(
            (x) => LanguageModel.fromMap(x as Map<String, dynamic>))));
  }

  String toJson() => json.encode(toMap());

  factory LanguageListModel.fromJson(String source) =>
      LanguageListModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class LanguageModel {
  final LanguageEnum languageEnum;
  bool isSelected;
  LanguageModel({
    required this.languageEnum,
    this.isSelected = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'languageEnum': languageEnum.name,
      'isSelected': isSelected,
    };
  }

  factory LanguageModel.fromMap(Map<String, dynamic> map) {
    return LanguageModel(
      languageEnum: LanguageEnum.fromMap(map['languageEnum']),
      isSelected: (map['isSelected'] ?? false) as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory LanguageModel.fromJson(String source) =>
      LanguageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
