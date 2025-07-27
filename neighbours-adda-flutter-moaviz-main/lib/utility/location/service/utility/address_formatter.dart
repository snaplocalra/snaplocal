import 'package:snap_local/common/utils/location/model/location_helper_models/address_component_model.dart';

String? _getAddresByType(
  List<AddressComponent> addressComponents,
  String type, {
  bool longName = false,
}) {
  for (var componentModel in addressComponents) {
    if (componentModel.types.contains(type)) {
      if (longName) {
        return componentModel.longName;
      } else {
        return componentModel.shortName;
      }
    }
  }
  // return addressModel.isEmpty ? null : addressModel.join(',');
  return null;
}

String? extractDesiredAddress(List<AddressComponent> addressComponents) {
  final List<String?> addressModel = [];

  final route = _getAddresByType(addressComponents, "route");
  addressModel.add(route);

  final subLocality = _getAddresByType(addressComponents, "sublocality");
  addressModel.add(subLocality);

//If the sublocality is empty then, take the locality
  if (subLocality == null) {
    final locality =
        _getAddresByType(addressComponents, "locality", longName: true);
    addressModel.add(locality);
  }

  final administrativeAreaLevel3 =
      _getAddresByType(addressComponents, "administrative_area_level_3");
  addressModel.add(administrativeAreaLevel3);

  final administrativeAreaLevel1 =
      _getAddresByType(addressComponents, "administrative_area_level_1");

  addressModel.add(administrativeAreaLevel1);

//Filter the null data from the list and combine the list string in one string
  final nullFilteredAddress =
      addressModel.where((address) => address != null).join(",");

  if (nullFilteredAddress.isNotEmpty) {
    return nullFilteredAddress;
  } else {
    return null;
  }
}
