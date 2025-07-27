import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';

abstract class LocationRepository {
  /// Fetch location based latitute and longitude
  Future<LocationAddressWithLatLng?> addressfromPosition({
    required double latitude,
    required double longitude,
  });

  /// Fetch location based on place id
  Future<LocationAddressWithLatLng?> addressfromPlaceId(String placeId);
}
