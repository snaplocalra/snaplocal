import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';

//Benagluru, India
const LatLng defaultLocation = LatLng(12.9716, 77.5946);

LocationAddressWithLatLng defaultLocationAddressWithLatLng =
    LocationAddressWithLatLng(
  latitude: defaultLocation.latitude,
  longitude: defaultLocation.longitude,
  address: 'Benagluru, India',
);
