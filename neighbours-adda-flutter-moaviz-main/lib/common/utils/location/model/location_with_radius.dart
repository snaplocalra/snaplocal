// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';

class LocationWithPreferenceRadius {
  final LocationAddressWithLatLng location;
  final double preferredRadius;

  LocationWithPreferenceRadius({
    required this.location,
    required this.preferredRadius,
  });

  Map<String, dynamic> toMap() {
    return {
      'location': location.toJson(),
      'preference_radius': preferredRadius,
    };
  }

  factory LocationWithPreferenceRadius.fromMap(Map<String, dynamic> map) {
    return LocationWithPreferenceRadius(
      location: LocationAddressWithLatLng.fromMap(map['location']),
      preferredRadius: map['preference_radius'].toDouble(),
    );
  }

  LocationWithPreferenceRadius copyWith({
    LocationAddressWithLatLng? location,
    double? preferredRadius,
  }) {
    return LocationWithPreferenceRadius(
      location: location ?? this.location,
      preferredRadius: preferredRadius ?? this.preferredRadius,
    );
  }
}
