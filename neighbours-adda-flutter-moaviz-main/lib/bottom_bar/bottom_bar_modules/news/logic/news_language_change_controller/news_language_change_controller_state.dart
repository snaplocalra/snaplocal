part of 'news_language_change_controller_cubit.dart';

class NewsLanguageChangeControllerState extends Equatable {
  final bool loading;
  final LanguageListModel languagesModel;
  final bool enableTranslation;
  const NewsLanguageChangeControllerState({
    required this.languagesModel,
    this.loading = false,
    this.enableTranslation = false,
  });

  @override
  List<Object> get props => [languagesModel, loading, enableTranslation];

  //selected language
  LanguageModel get selectedLanguage {
    return languagesModel.languages.firstWhere(
      (element) => element.isSelected,
      orElse: () => languagesModel.languages.first,
    );
  }

  NewsLanguageChangeControllerState copyWith({
    LanguageListModel? languagesModel,
    bool? loading,
    bool? enableTranslation,
  }) {
    return NewsLanguageChangeControllerState(
      languagesModel: languagesModel ?? this.languagesModel,
      loading: loading ?? false,
      enableTranslation: enableTranslation ?? false,
    );
  }
}
