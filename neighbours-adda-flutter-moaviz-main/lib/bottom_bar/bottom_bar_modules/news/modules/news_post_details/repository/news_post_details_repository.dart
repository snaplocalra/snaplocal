import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/news_post_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../utility/constant/errors.dart';

class NewsPostDetailsRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  //Fetch news
  Future<NewsPostModel> fetchNewsPostDetails(String postId) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _fetchNewsPostDetailsIsolate(
          accessToken: accessToken,
          postId: postId,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<NewsPostModel> _fetchNewsPostDetailsIsolate({
    required String accessToken,
    required String postId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'post_id': postId,
      });
      final dio = dioClient();
      return await dio.post("channels/news/view", data: data).then((response) {
        if (response.data['status'] == "valid") {
          return NewsPostModel.fromMap(response.data['data']);
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
