import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/category_wise_feed_post/model/feed_post_category_type_enum.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../utility/constant/errors.dart';

class CateegoryWiseFeedPostRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<SocialPostsList> fetchCategoryWiseFeedPosts({
    int page = 1,
    required FeedPostCategoryType categoryType,
    String? filterJson,
    String? searchKeyword,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _fetchCategoryWiseFeedPostsIsolate(
          accessToken: accessToken,
          page: page,
          categoryType: categoryType,
          filterJson: filterJson,
          searchKeyword: searchKeyword,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<SocialPostsList> _fetchCategoryWiseFeedPostsIsolate({
    required String accessToken,
    required int page,
    required FeedPostCategoryType categoryType,
    String? filterJson,
    String? searchKeyword,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'page': page,
        'filter': filterJson,
        'search_keyword': searchKeyword,
        'category_id': categoryType.categoryId,
      });
      final dio = dioClient();
      return await dio
          .post('v2/users/category_wise_post', data: data)
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
