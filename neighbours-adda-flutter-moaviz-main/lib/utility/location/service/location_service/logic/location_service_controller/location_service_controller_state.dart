// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'location_service_controller_cubit.dart';

abstract class LocationServiceControllerState extends Equatable {
  const LocationServiceControllerState();

  @override
  List<Object> get props => [];
}

class InitialLocation extends LocationServiceControllerState {}

class LoadingLocation extends LocationServiceControllerState {}

class LocationFetched extends LocationServiceControllerState {
  final LocationAddressWithLatLng location;
  const LocationFetched({
    required this.location,
  });
  @override
  List<Object> get props => [location];
}

class LocationError extends LocationServiceControllerState {
  final String error;
  final bool locationPermanentDenied;
  const LocationError({
    required this.error,
    this.locationPermanentDenied = false,
  });
  @override
  List<Object> get props => [error, locationPermanentDenied];
}
