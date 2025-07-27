import 'package:dio/dio.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/common/utils/location/model/location_helper_models/location_by_address_selection_model.dart';
import 'package:snap_local/common/utils/location/model/location_helper_models/location_by_geocode.dart';
import 'package:snap_local/utility/api_manager/config/env/env.dart';
import 'package:snap_local/utility/api_manager/config/env/google_map_security_headers.dart';
import 'package:snap_local/utility/location/repository/location_repository.dart';
import 'package:snap_local/utility/location/service/utility/address_formatter.dart';
import 'package:snap_local/utility/location/storage/location_storage.dart';

import '../../constant/errors.dart';

class GoogleLocationRepository implements LocationRepository {
  final LocationStorage locationStorage;

  GoogleLocationRepository(this.locationStorage);

  final dio = Dio(BaseOptions(headers: googleMapSecurityHeaders()));

  @override
  Future<LocationAddressWithLatLng?> addressfromPlaceId(String placeId) async {
    try {
      LocationAddressWithLatLng? location;

      // Fetch location from local storage
      location = await locationStorage.fetchLocationByPlaceId(placeId);

      // If location is not found in local storage, fetch it from the server
      if (location == null) {
        location = await dio
            .get(
                'https://maps.googleapis.com/maps/api/geocode/json?place_id=$placeId&key=$googleAPIKey')
            .then((response) {
          if (response.data['error_message'] != null) {
            throw (response.data['error_message']);
          } else {
            final data = LocationByAddressSelectionModel.fromMap(response.data)
                .result
                .first;

            final desiredLocation = extractDesiredAddress(
                data.addressComponentModel.addressComponents);

            return LocationAddressWithLatLng(
              address: desiredLocation ?? data.formatAddress,
              latitude: data.latitude,
              longitude: data.longitude,
            );
          }
        });

        if (location != null) {
          // Save the location in local storage
          await locationStorage.storeLocationByPlaceId(
              placeId: placeId, location: location);
        }
      }

      // Return the location
      return location;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw (ErrorConstants.serverError);
        } else {
          throw ("Unable to fetch data");
        }
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<LocationAddressWithLatLng?> addressfromPosition({
    required double latitude,
    required double longitude,
  }) async {
    try {
      LocationAddressWithLatLng? location;

      // Fetch location from local storage
      location =
          await locationStorage.fetchLocationByLatLng(latitude, longitude);

      if (location == null) {
        location = await dio
            .get(
                'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$googleAPIKey')
            .then((response) {
          if (response.data['error_message'] != null) {
            throw (response.data['error_message']);
          } else {
            // Parse the response to get the
            final locationByGeoCode = LocationByGeocode.fromJson(response.data);

            // Extract the desired location from the address components
            final desiredLocation = extractDesiredAddress(
                locationByGeoCode.addressComponentModel.addressComponents);

            // Return the location
            return LocationAddressWithLatLng(
              address: desiredLocation ?? locationByGeoCode.address,
              latitude: latitude,
              longitude: longitude,
            );
          }
        });

        if (location != null) {
          // Save the location in local storagerepository
          await locationStorage.storeLocationByLatLng(location);
        }
      }

      // Return the location
      return location;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw (ErrorConstants.serverError);
        } else {
          throw ("Unable to fetch data");
        }
      } else {
        rethrow;
      }
    }
  }
}
