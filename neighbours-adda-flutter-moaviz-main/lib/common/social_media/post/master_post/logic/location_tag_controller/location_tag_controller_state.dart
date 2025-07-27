part of 'location_tag_controller_cubit.dart';

class LocationTagControllerState extends Equatable {
  final LocationAddressWithLatLng? taggedLocation;
  const LocationTagControllerState({this.taggedLocation});

  @override
  List<Object?> get props => [taggedLocation];

  LocationTagControllerState copyWith({
    LocationAddressWithLatLng? taggedLocation,
  }) {
    return LocationTagControllerState(taggedLocation: taggedLocation);
  }
}
