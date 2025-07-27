import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

enum EventPostListType {
  localEvents(
    name: LocaleKeys.exploreLocalEvents,
    description: LocaleKeys.yourGuideToEventsAroundYou,
    api: "v2/users/events/all_events",
  ),
  myEvents(
    name: LocaleKeys.yourEvents,
    description: LocaleKeys.manageEvents,
    api: "v2/users/events/my_events",
  );

  final String name;
  final String description;
  final String api;
  const EventPostListType({
    required this.name,
    required this.description,
    required this.api,
  });
}
