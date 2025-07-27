import 'package:snap_local/common/utils/location/model/location_helper_models/address_component_model.dart';

class LocationByGeocode {
  final String address;
  final AddressComponentModel addressComponentModel;

  LocationByGeocode({
    required this.address,
    required this.addressComponentModel,
  });

  factory LocationByGeocode.fromMap(Map<String, dynamic> map) {
    return LocationByGeocode(
      address: map['formatted_address'],
      addressComponentModel:
          AddressComponentModel.fromJson(map['address_components']),
    );
  }

  factory LocationByGeocode.fromJson(dynamic source) =>
      LocationByGeocode.fromMap(source['results'][0]);
}
