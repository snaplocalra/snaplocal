import 'package:designer/utility/theme_toast.dart';
import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/profile/manage_profile_details/model/edit_profile_details_model.dart';
import 'package:snap_local/profile/manage_profile_details/model/profile_details_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../utility/constant/errors.dart';

class ProfileRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<ProfileDetailsModel> fetchProfileDetails() async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        _fetchProfileDetailsIsolate,
        await authPref.getAccessToken(),
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<ProfileDetailsModel> _fetchProfileDetailsIsolate(
      String accessToken) async {
    try {
      FormData data = FormData.fromMap({'access_token': accessToken});
      final dio = dioClient();
      return await dio.post('v2/my_profile_data', data: data).then((response) {
        if (response.data['status'] == "valid") {
          return ProfileDetailsModel.fromJson(
            response.data['data'],
            isOwnProfile: true,
          );
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

  Future<void> updateProfileDetails(
    EditProfileDetailsModel editProfileDetailsModel, {
    ///When the user picked a profile image, then after upload to server,
    ///will return the server image that need to re-assign in the editProfileDetailsModel.
    String? profileImageServerName,
    String? coverImageServerName,
  }) async {
    try {
      final editProfileDetailsMap = editProfileDetailsModel.toMap();
      editProfileDetailsMap.addAll({
        'access_token': await authPref.getAccessToken(),

        if(profileImageServerName != null)
        'image': profileImageServerName,

        if(coverImageServerName != null)
        'cover_image': coverImageServerName,
      });

      await makeIsolateApiCallWithInternetCheck(
              _updateProfileDetailsIsolate, editProfileDetailsMap)
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

  Future<String?> _updateProfileDetailsIsolate(
      Map<String, dynamic> editProfileDetailsMap) async {
    try {
      FormData data = FormData.fromMap(editProfileDetailsMap);
      final dio = dioClient();
      return await dio.post('myprofile/update', data: data).then((response) {
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

//Set the showCompleteProfile to true
  Future<void> setShowProfileComplete() async {
    try {
      final accessToken = await authPref.getAccessToken();
      await makeIsolateApiCallWithInternetCheck(
        _setShowProfileCompleteIsolate,
        accessToken,
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<void> _setShowProfileCompleteIsolate(String accessToken) async {
    try {
      FormData data = FormData.fromMap({'access_token': accessToken});
      final dio = dioClient();
      await dio
          .post('v2/myprofile/set_complete_profile', data: data)
          .then((response) {
        if (response.data['status'] != "valid") {
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
