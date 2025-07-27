import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';

abstract class LocationStorage {
  /// Store location based on place id
  Future<bool> storeLocationByPlaceId({
    required String placeId,
    required LocationAddressWithLatLng location,
  });

  /// Fetch location based on place id
  Future<LocationAddressWithLatLng?> fetchLocationByPlaceId(String palceId);

  /// Store location based on latitute and longitude
  Future<bool> storeLocationByLatLng(LocationAddressWithLatLng location);

  /// Fetch location based on latitute and longitude
  Future<LocationAddressWithLatLng?> fetchLocationByLatLng(
      double latitude, double longitude);
}
