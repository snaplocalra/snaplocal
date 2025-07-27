import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/utility/localization/model/language_enum.dart';
import 'package:snap_local/utility/localization/model/language_model.dart';

part 'news_language_change_controller_state.dart';

class NewsLanguageChangeControllerCubit
    extends Cubit<NewsLanguageChangeControllerState> {
  NewsLanguageChangeControllerCubit()
      : super(
          NewsLanguageChangeControllerState(
            languagesModel: LanguageListModel(
              [
                LanguageModel(
                  languageEnum: LanguageEnum.english,
                  isSelected: true,
                ),
                LanguageModel(languageEnum: LanguageEnum.hindi),
                LanguageModel(languageEnum: LanguageEnum.kannada),
                LanguageModel(languageEnum: LanguageEnum.malayalam),
                LanguageModel(languageEnum: LanguageEnum.tamil),
                LanguageModel(languageEnum: LanguageEnum.telugu),
              ],
            ),
          ),
        );

  Future<void> selectLanguage(LanguageEnum languageEnum) async {
    final stateLanguages = state.languagesModel.languages;
    // emit(state.copyWith(loading: true));
    for (var language in stateLanguages) {
      if (language.languageEnum.locale == languageEnum.locale) {
        language.isSelected = true;
      } else {
        language.isSelected = false;
      }
    }

    emit(state.copyWith(
      languagesModel: LanguageListModel(stateLanguages),
      enableTranslation: true,
    ));
  }

  //Set dynamic news language
  // take the application language and location language as input
  Future<void> setDynamicNewsLanguage(
    LanguageEnum applicationLanguage,
    Locale locationLocale,
  ) async {
    // case 1: Their application language is in English, then both local news and global news will show to them in the location based language.
    // case 2: Their application language is in Hindi or any other except English, then both local news and global news will show to them in the application based language, mean the news content will translate from the original text to Hindi.

    if (applicationLanguage == LanguageEnum.english) {
      // case 1
      selectLanguage(LanguageEnum.fromLocale(locationLocale));
    } else if (applicationLanguage != LanguageEnum.english) {
      // case 2
      selectLanguage(applicationLanguage);
    }
  }
}
