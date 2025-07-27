abstract class TranslationLanguageDatabase {
  //save text
  Future<void> saveText(
    String sourceText,
    String translatedText,
    String localeCode,
  );

  //fetch text
  Future<String?> fetchText(
    String sourceText,
    String localeCode,
  );
}
