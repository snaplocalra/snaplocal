import 'package:designer/utility/theme_toast.dart';
import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/profile/profile_privacy/models/profile_privacy_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../utility/constant/errors.dart';

class ProfilePrivacyRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<ProfilePrivacyModel> fetchProfilePrivacySettings() async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        _fetchProfilePrivacySettingsIsolate,
        await authPref.getAccessToken(),
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<ProfilePrivacyModel> _fetchProfilePrivacySettingsIsolate(
      String accessToken) async {
    try {
      FormData data = FormData.fromMap({'access_token': accessToken});
      final dio = dioClient();
      return await dio
          .post('myprofile/user_privacy', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return ProfilePrivacyModel.fromMap(response.data['data']);
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

  Future<void> updateProfilePrivacy(
      ProfilePrivacyModel editedProfilePrivacyModel) async {
    try {
      final editedProfilePrivacyMap = editedProfilePrivacyModel.toMap();
      editedProfilePrivacyMap.addAll({
        'access_token': await authPref.getAccessToken(),
      });
      await makeIsolateApiCallWithInternetCheck(
              _updateProfilePrivacyIsolate, editedProfilePrivacyMap)
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

  Future<String?> _updateProfilePrivacyIsolate(
      Map<String, dynamic> editProfileDetailsMap) async {
    try {
      FormData data = FormData.fromMap(editProfileDetailsMap);
      final dio = dioClient();
      return await dio
          .post('myprofile/update_user_privacy', data: data)
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
