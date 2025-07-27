abstract class TranslationRepository {
  Future<String?> translate({
    required String text,
    required String targetLanguageCode,
  });
}

abstract class AddSourceLanguage {
  final String sourceLanguageCode;
  AddSourceLanguage(this.sourceLanguageCode);
}
