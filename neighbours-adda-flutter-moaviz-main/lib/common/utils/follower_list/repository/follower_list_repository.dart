import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/utils/follower_list/model/follower_type.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../utility/constant/errors.dart';
import '../model/follower_list_model.dart';

class FollowerListRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<FollowerListModel> fetchFollowerList({
    int page = 1,
    required String postId,
    required FollowersFrom followersFrom,
    String? query,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _fetchFollowerListIsolate(
          accessToken: accessToken,
          page: page,
          postId: postId,
          followersFrom: followersFrom,
          query: query,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<FollowerListModel> _fetchFollowerListIsolate({
    required int page,
    required String accessToken,
    required String postId,
    required FollowersFrom followersFrom,
    String? query,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'followers_from_id': postId,
        'followers_from': followersFrom.jsonName,
        'keyword': query,
        'page': page,
      });
      final dio = dioClient();
      return await dio
          .post("common/followers_list", data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return FollowerListModel.fromJson(response.data);
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

  Future<FollowerListModel> fetchInfluencerFollowerList({
    int page = 1,
    required String userId,
    String? query,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _fetchInfluencerFollowerListIsolate(
          accessToken: accessToken,
          page: page,
          userId: userId,
          query: query,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<FollowerListModel> _fetchInfluencerFollowerListIsolate({
    required int page,
    required String accessToken,
    required String userId,
    String? query,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'user_id': userId,
        'keyword': query,
        'page': page,
      });
      final dio = dioClient();
      return await dio
          .post("influencers/followers_list", data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return FollowerListModel.fromJson(response.data);
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

  //block user
  Future<void> toggleBlockUser({
    required String userId,
    required String postId,
    required FollowersFrom followersFrom,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _toggleBlockUserIsolate(
          userId: userId,
          blockFromPostId: postId,
          accessToken: accessToken,
          followersFrom: followersFrom,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<void> _toggleBlockUserIsolate({
    required String userId,
    required String accessToken,
    required String blockFromPostId,
    required FollowersFrom followersFrom,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'user_id': userId,
        'block_from': followersFrom.jsonName,
        'block_from_post_id': blockFromPostId,
      });
      final dio = dioClient();
      return await dio
          .post("common/block_member_by_admin", data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return;
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
