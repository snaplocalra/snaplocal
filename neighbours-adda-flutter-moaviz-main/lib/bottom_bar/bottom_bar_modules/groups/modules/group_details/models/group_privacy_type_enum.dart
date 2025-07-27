import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

enum GroupPrivacyStatus {
  public(dsiplayName: LocaleKeys.public, jsonValue: "public"),
  private(dsiplayName: LocaleKeys.private, jsonValue: "private");

  final String dsiplayName;
  final String jsonValue;
  const GroupPrivacyStatus({
    required this.dsiplayName,
    required this.jsonValue,
  });

  factory GroupPrivacyStatus.fromString(String data) {
    switch (data) {
      case "public":
        return public;
      case "private":
        return private;
      default:
        return public;
    }
  }
}
