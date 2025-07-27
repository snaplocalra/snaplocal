import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/utility/localization/google_translate/repository/translation_repository.dart';
import 'package:snap_local/utility/localization/google_translate/translation_language_database/db/hive/hive_language_db.dart';
import 'package:snap_local/utility/localization/google_translate/translation_language_database/db/translation_language_database.dart';

part 'google_translate_state.dart';

class GoogleTranslateCubit extends Cubit<GoogleTranslateState> {
  String sourceText;
  GoogleTranslateCubit({
    required this.sourceText,
  }) : super(GoogleTranslateState(translatedText: sourceText));

  //translate text
  void translateText(
    String languageCode, {
    String? sourceText,
    required TranslationRepository translationRepository,
  }) async {
    //if the source text is not null, then update the source text
    if (sourceText != null) {
      this.sourceText = sourceText;
    }

    TranslationLanguageDatabase translationLanguageDb = HiveLanguageDatabase();

    //fetching the translated text from database
    String? translatedText = await translationLanguageDb.fetchText(
      this.sourceText,
      languageCode,
    );

    //if the translated text is not available in the database, then fetch it from the API
    translatedText ??= await translationRepository.translate(
      text: this.sourceText,
      targetLanguageCode: languageCode,
    );

    if (translatedText != null) {
      //store the translated text to database
      await translationLanguageDb.saveText(
        this.sourceText,
        translatedText,
        languageCode,
      );
    }
    emit(state.copyWith(translatedText: translatedText));
  }
}
