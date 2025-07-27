import 'package:equatable/equatable.dart';
import 'package:snap_local/common/social_media/profile/language_known/model/language_known_model.dart';

class LanguageKnownState extends Equatable {
  final bool dataLoading;
  final LanguageKnownList languageList;
  const LanguageKnownState({
    this.dataLoading = false,
    required this.languageList,
  });

  @override
  List<Object> get props => [dataLoading, languageList];

  LanguageKnownState copyWith({
    bool? dataLoading,
    LanguageKnownList? languageList,
  }) {
    return LanguageKnownState(
      dataLoading: dataLoading ?? false,
      languageList: languageList ?? this.languageList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'languageKnownList': languageList.toMap(),
    };
  }

  factory LanguageKnownState.fromMap(Map<String, dynamic> map) {
    return LanguageKnownState(
      languageList: LanguageKnownList.fromMap(
          map['languageKnownList'] as Map<String, dynamic>),
    );
  }
}
