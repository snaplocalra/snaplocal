import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:snap_local/utility/google_gemini/google_gemini_model.dart';
import 'package:snap_local/utility/localization/google_translate/repository/translation_repository.dart';

class GoogleGeminiTranslator implements TranslationRepository {
  @override
  Future<String?> translate({
    required String text,
    required String targetLanguageCode,
  }) async {
    try {
      final prompt = '''
  Convert the following text language to $targetLanguageCode: "$text", do not translate the meaning of the original text.
  Output Format: {"translated_text": "<translation>"}.
  Example: {"translated_text": "हलो"} for "Hello" to "hi".
  do not include the quotes in the output.
  ''';
      final content = [Content.text(prompt)];
      final response =
          await GoogleGeminiModel.instance.generateContent(content);

      if (response.text == null) {
        return null;
      } else {
        final responseJson = jsonDecode(response.text!);
        return responseJson['translated_text'];
      }
    } catch (error) {
      return null;
    }
  }
}
