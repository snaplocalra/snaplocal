import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/check_news_post/model/check_news_post_limit_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../utility/constant/errors.dart';

class CheckNewsPostLimitRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<CheckNewsPostLimitModel> checkNewsPostLimit(
      String newsChannelId) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _checkNewsPostLimitIsolate(
          accessToken: accessToken,
          newsChannelId: newsChannelId,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<CheckNewsPostLimitModel> _checkNewsPostLimitIsolate({
    required String accessToken,
    required String newsChannelId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'news_channel_id': newsChannelId,
      });
      final dio = dioClient();
      return await dio
          .post("channels/check_news_post_limit", data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return CheckNewsPostLimitModel.fromJson(response.data);
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
