import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

enum FeedPostCategoryType {
  safety(
    displayName: LocaleKeys.safetyAndAlerts,
    heading: LocaleKeys.safetyHeading,
    subHeading: LocaleKeys.safetySubHeading,
    svgImagePath: SVGAssetsImages.safety,
    categoryId: "3", //This ID is also prefined in the server.
  ),
  lostFound(
    displayName: LocaleKeys.lostAndFound,
    heading: LocaleKeys.lostAndFound,
    subHeading: LocaleKeys.lostAndFoundSubHeading,
    svgImagePath: SVGAssetsImages.lostFound,
    categoryId: "2", //This ID is also prefined in the server.
  );

  final String displayName;
  final String heading;
  final String subHeading;
  final String svgImagePath;
  final String categoryId;

  const FeedPostCategoryType({
    required this.displayName,
    required this.heading,
    required this.subHeading,
    required this.svgImagePath,
    required this.categoryId,
  });
}
