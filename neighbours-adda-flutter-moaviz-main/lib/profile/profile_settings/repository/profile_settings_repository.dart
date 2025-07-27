import 'package:designer/utility/theme_toast.dart';
import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/profile/profile_settings/models/profile_settings_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../utility/constant/errors.dart';

class ProfileSettingsRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<ProfileSettingsModel> fetchProfileSettings() async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        _fetchProfileSettingsIsolate,
        await authPref.getAccessToken(),
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<ProfileSettingsModel> _fetchProfileSettingsIsolate(
      String accessToken) async {
    try {
      FormData data = FormData.fromMap({'access_token': accessToken});
      final dio = dioClient();
      return await dio.post('myprofile/settings', data: data).then((response) {
        if (response.data['status'] == "valid") {
          return ProfileSettingsModel.fromMap(response.data['data']);
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

  Future<void> updateFeedRadius({
    required double feedRadius,
    required LocationType locationType,
  }) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> body) {
          final accessToken = body['accessToken']! as String;
          return _updateFeedRadiusIsolate(
            accessToken: accessToken,
            locationType: locationType,
            feedRadius: feedRadius,
          );
        },
        {'accessToken': await authPref.getAccessToken()},
      ).then((response) async {
        if (response != null) {
          await ThemeToast.successToast(response);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _updateFeedRadiusIsolate({
    required String accessToken,
    required double feedRadius,
    required LocationType locationType,
  }) async {
    try {
      final body = {
        'access_token': accessToken,
        'feed_radius': feedRadius,
      };
      FormData data = FormData.fromMap(body);
      final dio = dioClient();
      return await dio
          .post('v2/myprofile/${locationType.updateRadiusApi}', data: data)
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

  Future<void> updateLocation({
    required LocationAddressWithLatLng locationAddressWithLatLng,
    required LocationType locationType,
  }) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> body) {
          final accessToken = body['accessToken']! as String;
          return _updateLocationIsolate(
            accessToken: accessToken,
            locationType: locationType,
            locationAddressWithLatLng: locationAddressWithLatLng,
          );
        },
        {'accessToken': await authPref.getAccessToken()},
      ).then((response) async {
        if (response != null) {
          // await ThemeToast.successToast(response);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _updateLocationIsolate({
    required String accessToken,
    required LocationType locationType,
    required LocationAddressWithLatLng locationAddressWithLatLng,
  }) async {
    try {
      final body = <String, dynamic>{'access_token': accessToken};
      body.addAll(locationAddressWithLatLng.toMap());

      FormData data = FormData.fromMap(body);
      final dio = dioClient();
      return await dio
          .post('v2/myprofile/${locationType.updateLocationApi}', data: data)
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

  //Remove account
  Future<void> removeAccount({required String removeReason}) async {
    try {
      final body = {
        'access_token': await authPref.getAccessToken(),
        'remove_reason': removeReason,
      };
      return await makeIsolateApiCallWithInternetCheck(
        _removeAccountIsolate,
        body,
      ).then((response) async {
        if (response != null) {
          await ThemeToast.successToast(response);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _removeAccountIsolate(Map<String, String> body) async {
    try {
      FormData data = FormData.fromMap(body);
      final dio = dioClient();
      return await dio
          .post('myprofile/close_account', data: data)
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

  Future<void> removeAccountOTPVerification({required String otp}) async {
    try {
      final body = {
        'access_token': await authPref.getAccessToken(),
        'otp': otp,
      };
      return await makeIsolateApiCallWithInternetCheck(
              _removeAccountOTPVerificationIsolate, body)
          .then((response) async {
        if (response != null) {
          await ThemeToast.successToast(response);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _removeAccountOTPVerificationIsolate(
      Map<String, String> body) async {
    try {
      FormData data = FormData.fromMap(body);

      final dio = dioClient();
      return await dio
          .post('myprofile/close_account/verify_otp', data: data)
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

  Future<void> removeAccountResendOTP({required String phoneNumber}) async {
    try {
      final body = {
        'access_token': await authPref.getAccessToken(),
        'mobile': phoneNumber,
      };
      return await makeIsolateApiCallWithInternetCheck(
              _removeAccountResendOTPIsolate, body)
          .then((response) async {
        if (response != null) {
          await ThemeToast.successToast(response);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _removeAccountResendOTPIsolate(
      Map<String, String> body) async {
    try {
      FormData data = FormData.fromMap(body);
      final dio = dioClient();
      return await dio
          .post('myprofile/close_account/resend_otp', data: data)
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
