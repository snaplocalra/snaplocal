import 'package:designer/utility/theme_toast.dart';
import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/modules/favorite_location/model/favorite_location_model.dart';
import 'package:snap_local/common/utils/location/model/location_with_radius.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../utility/constant/errors.dart';

class FavoriteLocationRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<FavoriteLocationModel> fetchFavLocationList() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      return await makeIsolateApiCallWithInternetCheck(
        _fetchFavLocationListIsolate,
        await authPref.getAccessToken(),
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<FavoriteLocationModel> _fetchFavLocationListIsolate(
      String accessToken) async {
    try {
      //Static data

      FormData data = FormData.fromMap({'access_token': accessToken});
      final dio = dioClient();
      return await dio
          .post('v2/favourite_locations', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return FavoriteLocationModel.fromMap(response.data);
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw (ErrorConstants.serverError);
        }
      }
      rethrow;
    }
  }

//Add favorite location
  Future<void> addFavLocation(
      LocationWithPreferenceRadius locationWithPreferenceRadius) async {
    try {
      final accessToken = await authPref.getAccessToken();
      await makeIsolateApiCallWithInternetCheck(
          (_) => _addFavLocationIsolate(
                accessToken,
                locationWithPreferenceRadius,
              ),
          {}).then((value) {
        if (value != null) {
          ThemeToast.successToast(value);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _addFavLocationIsolate(
    String accessToken,
    LocationWithPreferenceRadius locationWithPreferenceRadius,
  ) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'location': locationWithPreferenceRadius.location.toJson(),
        'preference_radius': locationWithPreferenceRadius.preferredRadius,
      });
      final dio = dioClient();
      return await dio
          .post('v2/favourite_locations/add', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return response.data['message'];
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw (ErrorConstants.serverError);
        }
      }
      rethrow;
    }
  }

//Update favorite location
  Future<void> updateFavLocation(
    FavLocationInfoModel favLocationInfoModel,
  ) async {
    try {
      final accessToken = await authPref.getAccessToken();
      await makeIsolateApiCallWithInternetCheck(
          (_) => _updateFavLocationIsolate(
                accessToken,
                favLocationInfoModel,
              ),
          {}).then((value) {
        if (value != null) {
          ThemeToast.successToast(value);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _updateFavLocationIsolate(
    String accessToken,
    FavLocationInfoModel favLocationInfoModel,
  ) async {
    try {
      final location =
          favLocationInfoModel.locationWithPreferenceRadius.location.toJson();

      final preferenceRadius =
          favLocationInfoModel.locationWithPreferenceRadius.preferredRadius;

      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'location_id': favLocationInfoModel.id,
        'location': location,
        'preference_radius': preferenceRadius,
      });
      final dio = dioClient();
      return await dio
          .post('v2/favourite_locations/update', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return response.data['message'];
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw (ErrorConstants.serverError);
        }
      }
      rethrow;
    }
  }

//Delete favorite location
  Future<void> deleteFavLocation(String locationId) async {
    try {
      final accessToken = await authPref.getAccessToken();
      await makeIsolateApiCallWithInternetCheck(
              (_) => _deleteFavLocationIsolate(accessToken, locationId), {})
          .then((value) {
        if (value != null) {
          ThemeToast.successToast(value);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _deleteFavLocationIsolate(
    String accessToken,
    String locationId,
  ) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'location_id': locationId,
      });
      final dio = dioClient();
      return await dio
          .post('v2/favourite_locations/delete', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return response.data['message'];
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw (ErrorConstants.serverError);
        }
      }
      rethrow;
    }
  }

  //Set favorite location
  Future<void> setFavLocation(String locationId) async {
    try {
      final accessToken = await authPref.getAccessToken();
      await makeIsolateApiCallWithInternetCheck(
              (_) => _setFavLocationIsolate(accessToken, locationId), {})
          .then((value) {
        if (value != null) {
          ThemeToast.successToast(value);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _setFavLocationIsolate(
    String accessToken,
    String locationId,
  ) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'location_id': locationId,
      });
      final dio = dioClient();
      return await dio
          .post('v2/favourite_locations/set_location', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return response.data['message'];
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw (ErrorConstants.serverError);
        }
      }
      rethrow;
    }
  }
}
