import 'package:designer/utility/theme_toast.dart';
import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

class ResetPasswordRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<void> resetPassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          return _resetPasswordIsolate(
            accessToken: params['accessToken']! as String,
            oldPassword: oldPassword,
            newPassword: newPassword,
          );
        },
        {"accessToken": await authPref.getAccessToken()},
      ).then((response) {
        ThemeToast.successToast(response);
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String> _resetPasswordIsolate({
    required String accessToken,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      FormData data = FormData.fromMap({
        "access_token": accessToken,
        "old_password": oldPassword,
        "new_password": newPassword,
        "confirm_password": newPassword,
      });
      final dio = dioClient();
      return await dio
          .post('users/reset_password', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return response.data['message'];
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }
}
