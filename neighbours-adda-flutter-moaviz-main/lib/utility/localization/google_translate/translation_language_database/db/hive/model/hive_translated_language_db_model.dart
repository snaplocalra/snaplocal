import 'package:hive/hive.dart';

part 'hive_translated_language_db_model.g.dart';

@HiveType(typeId: 0)
class HiveTranslatedLanguageDbModel extends HiveObject {
  @HiveField(0)
  late String sourceText;

  @HiveField(1)
  late String translatedText;

  @HiveField(2)
  late String localeCode;

  HiveTranslatedLanguageDbModel(
      this.sourceText, this.translatedText, this.localeCode);
}
