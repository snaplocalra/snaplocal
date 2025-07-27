import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../utility/constant/errors.dart';

class NewsRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  //Fetch news
  Future<SocialPostsList> fetchNews({
    int page = 1,
    String? filterJson,
    String? searchKeyword,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _fetchNewsIsolate(
          accessToken: accessToken,
          page: page,
          filterJson: filterJson,
          searchKeyword: searchKeyword,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<SocialPostsList> _fetchNewsIsolate({
    required String accessToken,
    required int page,
    String? filterJson,
    String? searchKeyword,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'page': page,
        'search_keyword': searchKeyword,
        'filter': filterJson,
      });
      final dio = dioClient();
      return await dio.post("channels/news", data: data).then((response) {
        if (response.data['status'] == "valid") {
          return SocialPostsList.fromMap(response.data);
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
