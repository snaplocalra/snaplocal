import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/profile/profile_details/model/post_view_type.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../utility/constant/errors.dart';

class ProfilePostsRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<SocialPostsList> fetchProfilePosts({
    int page = 1,
    required String userId,
    required PostViewType postViewType,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _fetchProfilePostsIsolate(
          accessToken: accessToken,
          page: page,
          userId: userId,
          postViewType: postViewType,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<SocialPostsList> _fetchProfilePostsIsolate({
    required String accessToken,
    required int page,
    required String userId,
    required PostViewType postViewType,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'page': page,
        'user_id': userId,
        'type': postViewType.jsonValue,
      });
      final dio = dioClient();
      return await dio
          .post('v2/users/posts/profile_posts', data: data)
          .then((response) {
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
