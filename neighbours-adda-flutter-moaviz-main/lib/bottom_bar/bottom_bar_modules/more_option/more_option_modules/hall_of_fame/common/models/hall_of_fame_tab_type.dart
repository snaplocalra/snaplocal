import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

enum HallOfFameTabType {
  contests(name: LocaleKeys.contests),
  winners(name: LocaleKeys.winners);

  final String name;
  const HallOfFameTabType({required this.name});
}
