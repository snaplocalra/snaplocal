import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

enum LocationType {
  socialMedia(
    updateLocationApi: "social_media_location",
    updateRadiusApi: "social_media_radius",
    displayName: LocaleKeys.socialMedia,
  ),
  marketPlace(
    updateLocationApi: "market_place_location",
    updateRadiusApi: "market_place_radius",
    displayName: LocaleKeys.marketPlace,
  );

  final String updateRadiusApi;
  final String updateLocationApi;
  final String displayName;
  const LocationType({
    required this.displayName,
    required this.updateLocationApi,
    required this.updateRadiusApi,
  });
}
