import 'package:flutter/material.dart';
import 'package:snap_local/utility/localization/model/locale_model.dart';

enum LanguageEnum {
  english(
    englishName: "English",
    nativeName: "English",
    locale: LocaleManager.english,
  ),
  hindi(
    englishName: "Hindi",
    nativeName: "हिन्दी",
    locale: LocaleManager.hindi,
  ),
  kannada(
    englishName: "Kannada",
    nativeName: "ಕನ್ನಡ",
    locale: LocaleManager.kannada,
  ),
  malayalam(
    englishName: "Malayalam",
    nativeName: "മലയാളം",
    locale: LocaleManager.malayalam,
  ),
  tamil(
    englishName: "Tamil",
    nativeName: "தமிழ்",
    locale: LocaleManager.tamil,
  ),
  telugu(
    englishName: "Telugu",
    nativeName: "తెలుగు",
    locale: LocaleManager.telugu,
  );

  final String englishName;
  final String nativeName;
  final Locale locale;

  const LanguageEnum({
    required this.englishName,
    required this.nativeName,
    required this.locale,
  });

  factory LanguageEnum.fromMap(String data) {
    switch (data) {
      case "english":
        return english;
      case "hindi":
        return hindi;
      case "kannada":
        return kannada;
      case "malayalam":
        return malayalam;
      case "tamil":
        return tamil;
      case "telugu":
        return telugu;
      default:
        return english;
    }
  }

  //from locale
  factory LanguageEnum.fromLocale(Locale locale) {
    switch (locale.languageCode) {
      case "en":
        return english;
      case "hi":
        return hindi;
      case "kn":
        return kannada;
      case "ml":
        return malayalam;
      case "ta":
        return tamil;
      case "te":
        return telugu;
      default:
        return english;
    }
  }

  //from language code
  factory LanguageEnum.fromLanguageCode(String languageCode) {
    switch (languageCode) {
      case "en":
        return english;
      case "hi":
        return hindi;
      case "kn":
        return kannada;
      case "ml":
        return malayalam;
      case "ta":
        return tamil;
      case "te":
        return telugu;
      default:
        return english;
    }
  }
}
