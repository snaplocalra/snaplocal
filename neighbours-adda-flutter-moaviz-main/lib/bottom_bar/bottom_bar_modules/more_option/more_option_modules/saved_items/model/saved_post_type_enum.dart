import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

enum SavedPostTypeEnum {
  all(displayName: LocaleKeys.all),
  posts(displayName: LocaleKeys.posts),
  market(displayName: LocaleKeys.marketAdda),
  job(displayName: LocaleKeys.jobs);

  final String displayName;
  const SavedPostTypeEnum({required this.displayName});
}
