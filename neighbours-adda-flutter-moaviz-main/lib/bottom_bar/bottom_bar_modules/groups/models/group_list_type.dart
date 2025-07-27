import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

enum GroupListType {
  groupsYouJoined(
    name: LocaleKeys.joinLocalGroups,
    description: LocaleKeys.connectWithYourCommunity,
    api: "groups/group_connections",
  ),
  managedByYou(
    name: LocaleKeys.manageYourGroups,
    description: LocaleKeys.connectWithYourCommunity,
    api: "groups/group_connections/managed_by_me",
  );

  final String name;
  final String description;
  final String api;
  const GroupListType({
    required this.name,
    required this.description,
    required this.api,
  });
}
