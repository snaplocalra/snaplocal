class LanguageKnownList {
  final List<LanguageKnownModel> languages;
  LanguageKnownList({required this.languages});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'languages': languages.map((x) => x.toMap()).toList(),
    };
  }

  factory LanguageKnownList.fromMap(Map<String, dynamic> map) {
    return LanguageKnownList(
      languages: List<LanguageKnownModel>.from(
        (map['data'] ?? map['languages']).map<LanguageKnownModel>(
          (x) => LanguageKnownModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}

class LanguageKnownModel {
  final String id;
  final String name;
  bool isSelected;
  LanguageKnownModel({
    required this.id,
    required this.name,
    this.isSelected = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory LanguageKnownModel.fromMap(Map<String, dynamic> map) {
    return LanguageKnownModel(
      id: (map['id']) as String,
      name: (map['name']) as String,
    );
  }
}
