import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/utility/localization/model/language_enum.dart';
import 'package:snap_local/utility/localization/model/language_model.dart';

part 'language_change_controller_state.dart';

class LanguageChangeControllerCubit
    extends Cubit<LanguageChangeControllerState> {
  LanguageChangeControllerCubit()
      : super(
          LanguageChangeControllerState(
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

  Future<void> selectLanguage(LanguageModel languageModel) async {
    final stateLanguages = state.languagesModel.languages;

    for (var language in stateLanguages) {
      if (language.languageEnum.locale == languageModel.languageEnum.locale) {
        language.isSelected = true;
      } else {
        language.isSelected = false;
      }
    }
    emit(state.copyWith(
      languagesModel: LanguageListModel(stateLanguages),
    ));
  }

  //set the saved language
  Future<void> setSavedLanguage(Locale savedLocale) async {
    final languageModel = LanguageModel(
      languageEnum: LanguageEnum.fromLocale(savedLocale),
    );
    await selectLanguage(languageModel);
  }
}
