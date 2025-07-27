import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/location/storage/location_storage.dart';

class PHPServerLocationStorage extends BaseApi implements LocationStorage {
  @override
  Future<LocationAddressWithLatLng?> fetchLocationByLatLng(
    double latitude,
    double longitude,
  ) async {
    final accessToken = await AuthenticationTokenSharedPref().getAccessToken();

    final data = FormData.fromMap({
      'access_token': accessToken,
      'latitude': latitude,
      'longitude': longitude,
    });

    return await dioClient()
        .post('common/fetch_location_by_lat_lng', data: data)
        .then((response) {
      if (response.data['status'] == "valid") {
        if (response.data['data'] == null) {
          return null;
        } else {
          return LocationAddressWithLatLng.fromMap(response.data['data']);
        }
      } else {
        return null;
      }
    });
  }

  @override
  Future<LocationAddressWithLatLng?> fetchLocationByPlaceId(
      String palceId) async {
    try {
      final accessToken =
          await AuthenticationTokenSharedPref().getAccessToken();

      final data = FormData.fromMap({
        'access_token': accessToken,
        'place_id': palceId,
      });

      return await dioClient()
          .post('common/fetch_location_by_place_id', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          if (response.data['data'] == null) {
            return null;
          } else {
            return LocationAddressWithLatLng.fromMap(response.data['data']);
          }
        } else {
          return null;
        }
      });
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> storeLocationByLatLng(LocationAddressWithLatLng location) async {
    try {
      final accessToken =
          await AuthenticationTokenSharedPref().getAccessToken();

      final data = FormData.fromMap({
        'access_token': accessToken,
        'location': location.toJson(),
      });

      return await dioClient()
          .post('common/save_location_by_lat_lng', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return true;
        } else {
          return false;
        }
      });
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> storeLocationByPlaceId({
    required String placeId,
    required LocationAddressWithLatLng location,
  }) async {
    try {
      final accessToken =
          await AuthenticationTokenSharedPref().getAccessToken();

      final data = FormData.fromMap({
        'access_token': accessToken,
        'place_id': placeId,
        'location': location.toJson(),
      });

      return await dioClient()
          .post('common/save_location_by_place_id', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return true;
        } else {
          return false;
        }
      });
    } catch (e) {
      return false;
    }
  }
}
