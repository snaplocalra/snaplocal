import 'package:flutter/material.dart';

abstract class LocaleManager {
  static const Locale english = Locale('en');
  static const Locale hindi = Locale('hi');
  static const Locale kannada = Locale('kn');
  static const Locale malayalam = Locale('ml');
  static const Locale tamil = Locale('ta');
  static const Locale telugu = Locale('te');

  static Locale localeFromJson(String data) {
    switch (data) {
      case "en":
        return english;
      case "hi":
        return hindi;
      case "kn":
        return kannada;
      case "ml":
        return malayalam;
      case "te":
        return telugu;
      case "ta":
        return tamil;
      default:
        return english;
    }
  }
}
