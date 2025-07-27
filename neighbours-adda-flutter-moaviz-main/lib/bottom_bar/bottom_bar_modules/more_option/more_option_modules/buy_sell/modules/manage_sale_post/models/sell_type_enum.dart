import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

enum SellType {
  sell(displayName: LocaleKeys.sell, json: "sell"),
  free(displayName: LocaleKeys.free, json: "free");

  final String displayName;
  final String json;
  const SellType({
    required this.displayName,
    required this.json,
  });

  factory SellType.fromMap(String data) {
    switch (data) {
      case "sell":
        return sell;
      case "free":
        return free;
      default:
        throw ("Invalid sell type");
    }
  }
}
