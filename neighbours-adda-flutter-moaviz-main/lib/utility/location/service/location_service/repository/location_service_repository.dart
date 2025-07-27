import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/common/utils/location/model/location_helper_models/location_by_address.dart';
import 'package:snap_local/utility/api_manager/config/env/env.dart';
import 'package:snap_local/utility/api_manager/config/env/google_map_security_headers.dart';
import 'package:snap_local/utility/helper/custom_exception.dart';
import 'package:snap_local/utility/location/repository/location_repository.dart';
import 'package:snap_local/utility/location/service/location_service/models/gps_services.dart';
import 'package:snap_local/utility/location/service/location_service/models/query_search.dart';
import 'package:uuid/uuid.dart';

import '../../../../constant/errors.dart';

class LocationServiceRepository implements QuerySearch, GPSServices {
  final LocationRepository locationRepository;

  LocationServiceRepository(this.locationRepository);

  final dio = Dio(BaseOptions(headers: googleMapSecurityHeaders()));

  @override
  Future<LocationAddressWithLatLng?> fetchAddressByGPSPosition() async {
    try {
      final position = await fetchDeviceGPSPosition();
      if (position == null) {
        return null;
      } else {
        return await locationRepository.addressfromPosition(
          latitude: position.latitude,
          longitude: position.longitude,
        );
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  @override
  Future<Position?> fetchDeviceGPSPosition() async {
    try {
      if (await checkGPSPermission()) {
        return await Geolocator.getCurrentPosition();
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> checkGPSPermission() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        throw ("Retry after enabling GPS service");
      }
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw ('Location permissions are denied');
      } else if (permission == LocationPermission.deniedForever) {
        throw LocationPermissionDeniedForeverException(
          'Location permission has been permanently denied. Please open the settings to grant the necessary permission.',
        );
      } else if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<LocationByAddressModel>> fetchAddressByQuery(String input) async {
    try {
      // generate a new token here
      final sessionToken = const Uuid().v4();

      return await dio
          .get(
              "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&language=en&components=country:in&key=$googleAPIKey&sessiontoken=$sessionToken")
          .then((response) {
        if (response.data['error_message'] != null) {
          throw (response.data['error_message']);
        } else {
          return LocationByAddress.fromJson(response.data)
              .predictedLocationList;
        }
      });
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
