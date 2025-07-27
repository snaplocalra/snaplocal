import 'package:snap_local/utility/localization/google_translate/repository/translation_repository.dart';
import 'package:translator/translator.dart';

class GoogleFreeTranslator implements TranslationRepository {
  @override
  Future<String?> translate({
    required String text,
    required String targetLanguageCode,
  }) async {
    try {
      return await GoogleTranslator()
          .translate(text, to: targetLanguageCode)
          .then((value) => value.text);
    } catch (error) {
      return null;
    }
  }
}
