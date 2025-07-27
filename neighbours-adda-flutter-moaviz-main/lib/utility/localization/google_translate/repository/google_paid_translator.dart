import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/config/env/env.dart';
import 'package:snap_local/utility/localization/google_translate/repository/translation_repository.dart';

class GooglePaidTranslator extends BaseApi
    implements TranslationRepository, AddSourceLanguage {
  @override
  final String sourceLanguageCode;
  GooglePaidTranslator(this.sourceLanguageCode);

  @override
  Future<String?> translate({
    required String text,
    required String targetLanguageCode,
  }) async {
    final String url =
        "https://translation.googleapis.com/language/translate/v2?q=$text&key=$googleTranslateAPIKey&source=$sourceLanguageCode&target=$targetLanguageCode";

    try {
      final dio = dioClient();
      final res = await dio.post(url);
      final body = res.data;
      final result = body["data"]["translations"][0]['translatedText'];
      return result;
    } catch (error) {
      return null;
    }
  }
}
