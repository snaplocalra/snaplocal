import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

enum BusinessViewType {
  business(
    svgPath: SVGAssetsImages.business,
    heading: LocaleKeys.bussinessHeading,
    description: LocaleKeys.exploreyourneighbourhoodbusinessesandservices,
  ),
  offers(
    svgPath: SVGAssetsImages.offersAndCoupons,
    heading: LocaleKeys.offersHeading,
    description: LocaleKeys.offersDescription,
  );

  final String svgPath;
  final String heading;
  final String description;

  const BusinessViewType({
    required this.svgPath,
    required this.heading,
    required this.description,
  });
}
