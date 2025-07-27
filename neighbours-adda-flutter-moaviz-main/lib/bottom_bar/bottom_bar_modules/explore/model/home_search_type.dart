import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

enum ExploreCategoryTypeEnum {
  //neighbours(displayName: LocaleKeys.neighbours),
  neighbours(displayName: LocaleKeys.locals),
  connections(displayName: "Local Connections"),
  // findLocally(displayName: LocaleKeys.findLocally),
  posts(displayName: LocaleKeys.posts),
  business(displayName: LocaleKeys.businesses),
  buyAndsell(displayName: LocaleKeys.buyAndsell),
  jobs(displayName: LocaleKeys.jobs),
  safetyAndAlerts(displayName: LocaleKeys.safetyAndAlerts),
  lostAndFound(displayName: LocaleKeys.lostAndFound),
  event(displayName: LocaleKeys.event),
  pages(displayName: LocaleKeys.pages),
  groups(displayName: LocaleKeys.groups);

  final String displayName;

  const ExploreCategoryTypeEnum({required this.displayName});

  //market place category
  bool get isMarketPlace =>
      this == ExploreCategoryTypeEnum.buyAndsell ||
      this == ExploreCategoryTypeEnum.jobs ||
      this == ExploreCategoryTypeEnum.business;

  //is find locally c

  bool get isFindLocally =>
      this == ExploreCategoryTypeEnum.business ||
      this == ExploreCategoryTypeEnum.buyAndsell ||
      this == ExploreCategoryTypeEnum.jobs ||
      this == ExploreCategoryTypeEnum.event ||
      this == ExploreCategoryTypeEnum.lostAndFound ||
      this == ExploreCategoryTypeEnum.safetyAndAlerts ||
      this == ExploreCategoryTypeEnum.buyAndsell;
}
