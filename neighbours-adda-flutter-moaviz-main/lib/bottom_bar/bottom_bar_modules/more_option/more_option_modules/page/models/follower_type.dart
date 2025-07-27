

import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

enum FollowerType {
  pageFollower(
    name: LocaleKeys.pageFollowers,
    json:'page'
  ),
  groupMember(
    name: LocaleKeys.groupMembers,
    json:'group'
  );

  final String name;
  final String json;
  const FollowerType({
    required this.name,
    required this.json,
  });
}