import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

enum ListMapViewType {
  list(displayName: LocaleKeys.list),
  map(displayName: LocaleKeys.map);

  final String displayName;
  const ListMapViewType({required this.displayName});
}
