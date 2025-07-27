import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/social_media/profile/language_known/model/language_known_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../utility/constant/errors.dart';

class LanguageKnownRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<LanguageKnownList> fetchLanguage() async {
    try {
      var accessToken= await authPref.getAccessToken();
      // return await makeIsolateApiCallWithInternetCheck(
      //   (Map<String, dynamic> params) {
      //     final accessToken = params['accessToken']! as String;
      //     return _fetchLanguageIsolate(accessToken: accessToken);
      //   },
      //   {
      //     'accessToken': await authPref.getAccessToken(),
      //   },
      // );
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _fetchLanguageIsolate(
          accessToken: accessToken,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<LanguageKnownList> _fetchLanguageIsolate({
    required String accessToken,
  }) async {
    try {
      FormData data = FormData.fromMap({'access_token': accessToken});
      final dio = dioClient();
      return await dio.post('common/languages', data: data).then((response) {
        if (response.data['status'] == "valid") {
          return LanguageKnownList.fromMap(response.data);
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
