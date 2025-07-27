import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_from_enum.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../utility/constant/errors.dart';
import '../../../../utils/share/model/share_type.dart';

class SharePostDetailsRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<SocialPostModel> fetchSocialPostDetails({
    required String postId,
    required PostType postType,
    required PostFrom postFrom,
    required ShareType shareType,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _fetchSocialPostDetailsIsolate(
          accessToken: accessToken,
          postId: postId,
          postType: postType,
          postFrom: postFrom,
          shareType: shareType,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<SocialPostModel> _fetchSocialPostDetailsIsolate({
    required String accessToken,
    required String postId,
    required PostType postType,
    required PostFrom postFrom,
    required ShareType shareType,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'post_id': postId,
        'share_type': shareType.param,
        'post_type': postType.param,
        'post_from': postFrom.jsonName,
        'access_token': accessToken,
      });
      final dio = dioClient();
      return await dio
          .post('v2/users/posts/shared_social_post_details', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return SocialPostModel.getModelByType(response.data['data']);
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
