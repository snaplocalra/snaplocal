part of 'location_render_cubit.dart';

class LocationRenderState extends Equatable {
  final bool isDataLoaded;
  final LocationAddressWithLatLng? socialMediaLocation;
  final LocationAddressWithLatLng? marketPlaceLocation;

  const LocationRenderState({
    this.isDataLoaded = false,
    this.socialMediaLocation,
    this.marketPlaceLocation,
  });

  @override
  List<Object?> get props =>
      [isDataLoaded, socialMediaLocation, marketPlaceLocation];

  bool get socialMediaLocationRenderStateAvailable =>
      socialMediaLocation != null;

  bool get marketPlaceLocationRenderStateAvailable =>
      marketPlaceLocation != null;

  LocationRenderState copyWith({
    required bool isDataLoaded,
    LocationAddressWithLatLng? socialMediaLocation,
    LocationAddressWithLatLng? marketPlaceLocation,
  }) {
    return LocationRenderState(
      isDataLoaded: isDataLoaded,
      socialMediaLocation: socialMediaLocation ?? this.socialMediaLocation,
      marketPlaceLocation: marketPlaceLocation ?? this.marketPlaceLocation,
    );
  }
}
