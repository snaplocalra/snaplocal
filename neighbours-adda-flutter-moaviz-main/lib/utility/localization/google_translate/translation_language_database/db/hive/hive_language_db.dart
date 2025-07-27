import 'package:collection/collection.dart';
import 'package:hive/hive.dart';
import 'package:snap_local/utility/localization/google_translate/translation_language_database/db/hive/model/hive_translated_language_db_model.dart';
import 'package:snap_local/utility/localization/google_translate/translation_language_database/db/translation_language_database.dart';

class HiveLanguageDatabase implements TranslationLanguageDatabase {
  static const String _collectionName = 'translated_text_list';

  //save translated text to local db, with the english text and locale code

  @override
  Future<void> saveText(
    String sourceText,
    String translatedText,
    String localeCode,
  ) async {
    //open the box
    await Hive.openBox<HiveTranslatedLanguageDbModel>(_collectionName);
    final languageCollection =
        Hive.box<HiveTranslatedLanguageDbModel>(_collectionName);
    languageCollection.add(
        HiveTranslatedLanguageDbModel(sourceText, translatedText, localeCode));
  }

  //fetch translated text from local db by comparing locale code and english
  @override
  Future<String?> fetchText(
    String sourceText,
    String localeCode,
  ) async {
    //open the box
    await Hive.openBox<HiveTranslatedLanguageDbModel>(_collectionName);

    final languageCollection =
        Hive.box<HiveTranslatedLanguageDbModel>(_collectionName);
    final List<HiveTranslatedLanguageDbModel> translatedTextList =
        languageCollection.values.toList();
    final HiveTranslatedLanguageDbModel? translatedText =
        translatedTextList.firstWhereOrNull(
      (element) =>
          element.sourceText == sourceText && element.localeCode == localeCode,
    );

    return translatedText?.translatedText;
  }
}
