import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../utility/constant/errors.dart';

class LocationAddressWithLatLng extends Equatable {
  final String address;
  final double latitude;
  final double longitude;

  const LocationAddressWithLatLng({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [address, latitude, longitude];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory LocationAddressWithLatLng.fromMap(Map<String, dynamic> map) {
    if (isDebug) {
      try {
        return _buildLocation(map);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildLocation(map);
    }
  }

  static LocationAddressWithLatLng _buildLocation(Map<String, dynamic> map) {
    return LocationAddressWithLatLng(
      address: map['address'],
      latitude: double.parse(map['latitude'].toString()),
      longitude: double.parse(map['longitude'].toString()),
    );
  }

  factory LocationAddressWithLatLng.fromJson(String source) {
    return LocationAddressWithLatLng.fromMap(jsonDecode(source));
  }

  //to LatLng
  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }
}
