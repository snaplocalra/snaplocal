import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/utility/helper/custom_exception.dart';
import 'package:snap_local/utility/location/service/location_service/repository/location_service_repository.dart';

part 'location_service_controller_state.dart';

class LocationServiceControllerCubit
    extends Cubit<LocationServiceControllerState> {
  final LocationServiceRepository _locationServiceRepository;

  LocationServiceControllerCubit(this._locationServiceRepository)
      : super(InitialLocation());

  Future<LocationAddressWithLatLng?> locationFetchByDeviceGPS() async {
    try {
      await HapticFeedback.lightImpact();
      emit(LoadingLocation());

      // Fetch the location
      final location =
          await _locationServiceRepository.fetchAddressByGPSPosition();

      // Render the location
      if (location == null) {
        return null;
      } else {
        renderLocation(location: location);
      }
      return location;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (e is LocationPermissionDeniedForeverException) {
        emit(LocationError(
            error: e.message.toString(), locationPermanentDenied: true));
      } else {
        Fluttertoast.showToast(msg: e.toString());
        emit(LocationError(error: e.toString()));
      }
    }
    return null;
  }

  Future<LocationAddressWithLatLng?> locationFetchByLatLng(
      LatLng latLng) async {
    try {
      emit(LoadingLocation());

      // Fetch the location
      final location = await _locationServiceRepository.locationRepository
          .addressfromPosition(
        latitude: latLng.latitude,
        longitude: latLng.longitude,
      );

      if (location != null) {
        renderLocation(location: location);
      }

      return location;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (e is LocationPermissionDeniedForeverException) {
        emit(LocationError(error: e.toString(), locationPermanentDenied: true));
      } else {
        Fluttertoast.showToast(msg: e.toString());
        emit(LocationError(error: e.toString()));
      }
    }
    return null;
  }

  Future<LocationAddressWithLatLng?> getLocationByPlaceId({
    required String placeId,
    bool emitLocation = true,
  }) async {
    try {
      if (emitLocation) {
        emit(LoadingLocation());
      }

      // Fetch the location by place id
      final location = await _locationServiceRepository.locationRepository
          .addressfromPlaceId(placeId);

      if (emitLocation && location != null) {
        renderLocation(location: location);
      }
      return location;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      Fluttertoast.showToast(msg: e.toString());
      emit(LocationError(error: e.toString()));

      return null;
    }
  }

  void renderLocation({required LocationAddressWithLatLng location}) {
    emit(LoadingLocation());
    emit(LocationFetched(location: location));
  }
}
