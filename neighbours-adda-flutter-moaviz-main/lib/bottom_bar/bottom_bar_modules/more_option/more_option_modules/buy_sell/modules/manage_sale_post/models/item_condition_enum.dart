import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

enum ItemCondition {
  all(json: "", displayName: (LocaleKeys.all)),
  brandNew(displayName: (LocaleKeys.newText), json: "brand_new"),
  likeNew(displayName: (LocaleKeys.likeNew), json: "like_new"),
  used(displayName: (LocaleKeys.used), json: "used"),
  fair(displayName: (LocaleKeys.fair), json: "fair");

  final String displayName;
  final String json;
  const ItemCondition({
    required this.displayName,
    required this.json,
  });

  factory ItemCondition.fromMap(String data) {
    switch (data) {
      case "brand_new":
        return brandNew;
      case "like_new":
        return likeNew;
      case "used":
        return used;
      case "fair":
        return fair;
      default:
        throw ("Invalid item condition type");
    }
  }
}
