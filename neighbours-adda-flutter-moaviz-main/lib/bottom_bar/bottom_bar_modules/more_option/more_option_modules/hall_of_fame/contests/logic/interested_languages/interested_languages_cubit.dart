import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/contests/models/interested_languages_model.dart';
import 'package:snap_local/utility/localization/model/language_enum.dart';
import 'package:snap_local/utility/localization/model/language_model.dart';

part 'interested_languages_state.dart';

class InterestedLanguagesCubit extends Cubit<InterestedLanguagesState> {
  InterestedLanguagesCubit()
      : super(
          InterestedLanguagesState(
            interestedLanguagesModel: InterestedLanguagesModel(
              data: [
                LanguageModel(languageEnum: LanguageEnum.english),
                LanguageModel(languageEnum: LanguageEnum.hindi),
                LanguageModel(languageEnum: LanguageEnum.kannada),
                LanguageModel(languageEnum: LanguageEnum.malayalam),
                LanguageModel(languageEnum: LanguageEnum.tamil),
                LanguageModel(languageEnum: LanguageEnum.telugu),
              ],
            ),
          ),
        );

  Future<void> selectSingleLanguage(LanguageModel languageModel) async {
    emit(state.copyWith(dataLoading: true));
    await HapticFeedback.heavyImpact();
    List<LanguageModel>? multiSelectedData = [];
    for (var language in state.interestedLanguagesModel.data) {
      if (language == languageModel) {
        language.isSelected = !language.isSelected;
        if (language.isSelected) {
          multiSelectedData.add(language);
        }
      } else {
        language.isSelected = false;
      }
    }
    emit(
      state.copyWith(
          interestedLanguagesModel: state.interestedLanguagesModel.copyWith(
        multiSelectedData: multiSelectedData,
      )),
    );
  }
}
