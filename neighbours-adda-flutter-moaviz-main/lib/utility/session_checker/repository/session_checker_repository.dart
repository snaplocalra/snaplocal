import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../constant/errors.dart';

class SessionCheckerRepository extends BaseApi {
  Future<bool> checkSession() async {
    try {
      final accessToken =
          await AuthenticationTokenSharedPref().getAccessToken();
      return await makeIsolateApiCallWithInternetCheck(
        _checkSessionIsolate,
        accessToken,
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<bool> _checkSessionIsolate(String accessToken) async {
    try {
      final dio = dioClient();
      final data = FormData.fromMap({'access_token': accessToken});
      return await dio.post('session_check', data: data).then((response) {
        if (response.data['status'] == "valid") {
          return response.data['data']['session_status'];
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
