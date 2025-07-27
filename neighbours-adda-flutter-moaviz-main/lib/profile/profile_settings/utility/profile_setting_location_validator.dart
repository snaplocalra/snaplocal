import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';

bool? isProfileSettingLocationNotAvailable(
  ProfileSettingsState profileSettingsState, {
  required LocationType locationType,
}) {
  if (profileSettingsState.isProfileSettingModelAvailable) {
    final profileSettingModule = profileSettingsState.profileSettingsModel!;
    LocationAddressWithLatLng? location;
    if (locationType == LocationType.socialMedia) {
      location = profileSettingModule.socialMediaLocation;
    } else {
      location = profileSettingModule.marketPlaceLocation;
    }
    if (location != null) {
      return false;
    } else {
      return true;
    }
  } else {
    return null;
  }
}
