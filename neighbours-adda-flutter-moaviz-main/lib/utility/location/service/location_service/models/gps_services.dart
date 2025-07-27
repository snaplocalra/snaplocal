import 'package:geolocator/geolocator.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';

abstract class GPSServices {
  /// Fetch location based on GPS position
  Future<LocationAddressWithLatLng?> fetchAddressByGPSPosition();

  /// Check if GPS permission is granted
  Future<bool> checkGPSPermission();

  /// Fetch device GPS position
  Future<Position?> fetchDeviceGPSPosition();
}
