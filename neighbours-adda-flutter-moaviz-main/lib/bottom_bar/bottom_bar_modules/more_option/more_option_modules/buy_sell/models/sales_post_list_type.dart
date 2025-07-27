import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

enum SalesPostListType {
  marketLocally(
    name: LocaleKeys.marketLocally,
    description: LocaleKeys.salesPostByNeighboursDescription,
    api: "v3/market/classified_by_neighbours",
  ),
  myListing(
    name: LocaleKeys.yourItemsListing,
    description: LocaleKeys.salesPostByYouDescription,
    api: "v3/market/classified_by_me",
  );

  final String name;
  final String description;
  final String api;
  const SalesPostListType({
    required this.name,
    required this.description,
    required this.api,
  });
}
