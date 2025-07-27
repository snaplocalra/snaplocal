import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

enum EmptyDataType {
  post(
    heading: LocaleKeys.nopostsavailable,
    svgImagePath: SVGAssetsImages.noPosts,
  ),
  event(
    heading: LocaleKeys.noeventsavailable,
    svgImagePath: SVGAssetsImages.noPosts,
  ),
  group(
    heading: LocaleKeys.searchForGroupsInYourLocality,
    svgImagePath: SVGAssetsImages.noGroups,
  ),
  page(
    heading: LocaleKeys.searchForPagesInYourLocality,
    svgImagePath: SVGAssetsImages.noPages,
  ),
  poll(
    heading: LocaleKeys.nopollsavailable,
    svgImagePath: SVGAssetsImages.noPolls,
  ),
  job(
    heading: LocaleKeys.nojobsavailable,
    svgImagePath: SVGAssetsImages.noJobs,
  ),
  business(
    heading: LocaleKeys.nobusinessesavailable,
    svgImagePath: SVGAssetsImages.noBusiness,
  ),
  buysell(
    heading: LocaleKeys.noitemsavailable,
    svgImagePath: SVGAssetsImages.noBusiness,
  ),
  notification(
    heading: LocaleKeys.nonotificationsavailable,
    svgImagePath: SVGAssetsImages.noNotifications,
  ),
  comingSoon(
    heading: LocaleKeys.comingSoon,
    svgImagePath: SVGAssetsImages.comingSoon,
  ),
  internet(
    heading: LocaleKeys.noInternet,
    svgImagePath: SVGAssetsImages.noInternet,
  );

  final String heading;
  final String svgImagePath;
  const EmptyDataType({
    required this.heading,
    required this.svgImagePath,
  });
}
