part of 'language_change_controller_cubit.dart';

class LanguageChangeControllerState extends Equatable {
  final LanguageListModel languagesModel;
  const LanguageChangeControllerState({
    required this.languagesModel,
  });

  @override
  List<Object> get props => [languagesModel];

  LanguageModel get selectedLanguage {
    return languagesModel.languages.firstWhere(
      (element) => element.isSelected,
      orElse: () => languagesModel.languages.first,
    );
  }

  LanguageChangeControllerState copyWith({
    LanguageListModel? languagesModel,
  }) {
    return LanguageChangeControllerState(
      languagesModel: languagesModel ?? this.languagesModel,
    );
  }
}
