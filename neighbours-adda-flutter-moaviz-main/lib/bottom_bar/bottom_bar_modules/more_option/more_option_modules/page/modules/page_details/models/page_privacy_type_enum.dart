import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

enum PagePrivacyStatus {
  public(name: LocaleKeys.public),
  private(name: LocaleKeys.private);

  final String name;
  const PagePrivacyStatus({required this.name});

  factory PagePrivacyStatus.fromJson(String data) {
    switch (data) {
      case "Public":
        return public;
      case "Private":
        return private;
      default:
        return public;
    }
  }
}
