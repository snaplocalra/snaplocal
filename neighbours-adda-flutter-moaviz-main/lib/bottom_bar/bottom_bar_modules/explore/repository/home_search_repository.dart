import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/explore/model/neighbours_list_model.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../utility/constant/errors.dart';

class ExploreRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<NeighboursListModel> searchNeighbours({
    int page = 1,
    required String query,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _fetchNeighboursIsolate(
          accessToken: accessToken,
          page: page,
          query: query,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<NeighboursListModel> _fetchNeighboursIsolate({
    required String accessToken,
    required int page,
    required String query,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'page': page,
        'keyword': query,
      });
      final dio = dioClient();
      return await dio
          .post("users/search/neighbours", data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return NeighboursListModel.fromJson(response.data);
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

  Future<SocialPostsList> searchPosts({
    int page = 1,
    required String query,
    PostType? postType,
    String? filterJson,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _searchPostsIsolate(
          page: page,
          query: query,
          accessToken: accessToken,
          postType: postType,
          filterJson: filterJson,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<SocialPostsList> _searchPostsIsolate({
    required String query,
    required int page,
    required String accessToken,
    PostType? postType,
    String? filterJson,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'page': page,
        'keyword': query,
        'access_token': accessToken,
        'type': postType?.param,
        'filter': filterJson,
      });

      final dio = dioClient();
      return await dio
          .post("v2/users/search/posts", data: data)
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

  Future<SocialPostsList> searchConnectionPosts({
    int page = 1,
    required String query,
    String? filterJson,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      final userId = await authPref.getUserId();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _searchConnectionPostsIsolate(
          page: page,
          query: query,
          accessToken: accessToken,
          userId: userId,
          filterJson: filterJson,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<SocialPostsList> _searchConnectionPostsIsolate({
    required String query,
    required String userId,
    required int page,
    required String accessToken,
    String? filterJson,
  }) async {
    try {

      FormData data = FormData.fromMap({
        'page': page,
        'keyword': query,
        'access_token': accessToken,
        'user_id': userId,
        'filter': filterJson,
      });

      final dio = dioClient();
      return await dio
          .post("v2/users/search/connection_posts", data: data)
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
