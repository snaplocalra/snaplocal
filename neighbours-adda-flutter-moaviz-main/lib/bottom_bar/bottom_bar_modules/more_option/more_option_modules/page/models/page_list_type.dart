import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

enum PageListType {
  pagesYouFollow(
    name: LocaleKeys.localPages,
    description: LocaleKeys.beTheStarOfYourLocalArea,
    api: "pages/pages_you_follow",
  ),
  managedByYou(
    name: LocaleKeys.manageYourPages,
    description: LocaleKeys.beTheStarOfYourLocalArea,
    api: "pages/my_pages",
  );

  final String name;
  final String description;
  final String api;
  const PageListType({
    required this.name,
    required this.description,
    required this.api,
  });
}
