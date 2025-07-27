import 'package:snap_local/common/utils/location/model/location_helper_models/address_component_model.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class LocationByAddressSelectionModel {
  final List<LocationByAddressSelectionData> result;
  LocationByAddressSelectionModel({
    required this.result,
  });

  factory LocationByAddressSelectionModel.fromMap(Map<String, dynamic> map) {
    return LocationByAddressSelectionModel(
      result: List<LocationByAddressSelectionData>.from(
        map['results'].map((x) => LocationByAddressSelectionData.fromMap(x)) ??
            const [],
      ),
    );
  }
}

class LocationByAddressSelectionData {
  final String formatAddress;
  final double latitude;
  final double longitude;
  final AddressComponentModel addressComponentModel;
  LocationByAddressSelectionData({
    required this.formatAddress,
    required this.latitude,
    required this.longitude,
    required this.addressComponentModel,
  });

  factory LocationByAddressSelectionData.fromMap(Map<String, dynamic> map) {
    return LocationByAddressSelectionData(
      formatAddress: (map['formatted_address'] ?? '') as String,
      latitude: double.parse((map["geometry"]["location"]["lat"]).toString()),
      longitude: double.parse(map["geometry"]["location"]["lng"].toString()),
      addressComponentModel:
          AddressComponentModel.fromJson(map["address_components"]),
    );
  }
}
