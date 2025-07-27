import 'package:designer/utility/theme_toast.dart';
import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/market_places/models/market_place_type.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_comment_control/post_comment_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/logic/post_share_control/post_share_control_cubit.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_from_enum.dart';
import 'package:snap_local/common/utils/post_action/models/post_action_type_enum.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../utility/constant/errors.dart';

class PostActionRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<void> saveUnSavePost({
    required String postId,
    required PostActionType postActionType,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      await makeIsolateApiCallWithInternetCheck((_) async {
        return _saveUnSavePostIsolate(
          accessToken: accessToken,
          postId: postId,
          postActionType: postActionType,
        );
      }, {}).then((response) {
        if (response != null) {
          ThemeToast.successToast(response);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _saveUnSavePostIsolate({
    required String accessToken,
    required String postId,
    required PostActionType postActionType,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'post_id': postId,
        'post_type': postActionType.jsonName,
      });
      final dio = dioClient();
      return await dio
          .post('v2/users/saved_items/add', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return response.data['message'];
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

  //delete market place post
  Future<void> deleteMarketPlacePost({
    required String postId,
    required MarketPlaceType marketPlaceType,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      await makeIsolateApiCallWithInternetCheck((_) {
        return _deleteMarketPlacePostIsolate(
          accessToken: accessToken,
          postId: postId,
          marketPlaceType: marketPlaceType,
        );
      }, {}).then((response) {
        if (response != null) {
          ThemeToast.successToast(response);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _deleteMarketPlacePostIsolate({
    required String accessToken,
    required String postId,
    required MarketPlaceType marketPlaceType,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'post_id': postId,
        'market_place_type': marketPlaceType.jsonName,
      });
      final dio = dioClient();
      return await dio
          .post('v2/users/market_place_post_delete', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return response.data['message'];
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

//delete social post
  Future<void> deleteSocialPost({
    required String postId,
    required PostFrom postFrom,
    required PostType postType,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      await makeIsolateApiCallWithInternetCheck(
          (_) => _deleteSocialPostIsolate(
                accessToken: accessToken,
                postId: postId,
                postFrom: postFrom,
                postType: postType,
              ),
          {}).then((response) {
        if (response != null) {
          ThemeToast.successToast(response);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _deleteSocialPostIsolate({
    required String accessToken,
    required String postId,
    required PostFrom postFrom,
    required PostType postType,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'post_id': postId,
        'post_type': postType.param,
        'post_from': postFrom.jsonName,
      });
      final dio = dioClient();
      return await dio
          .post('v2/users/post_delete', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return response.data['message'];
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

  //Social media
  Future<void> saveUnSaveSocialPost({
    required String postId,
    required PostFrom postFrom,
    required PostType postType,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      await makeIsolateApiCallWithInternetCheck(
          (_) async => _saveUnSaveSocialPostIsolate(
                accessToken: accessToken,
                postId: postId,
                postFrom: postFrom,
                postType: postType,
              ),
          {}).then((response) {
        if (response != null) {
          ThemeToast.successToast(response);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _saveUnSaveSocialPostIsolate({
    required String accessToken,
    required String postId,
    required PostFrom postFrom,
    required PostType postType,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'post_id': postId,
        'post_type': postType.param,
        'post_from': postFrom.jsonName,
      });

      final dio = dioClient();
      return await dio
          .post('v2/users/saved_items/add', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return response.data['message'];
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

  // view video post
  Future<void> viewSocialPost({
    required String postId,
    required PostType postType,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      await makeIsolateApiCallWithInternetCheck(
              (_) async => _viewSocialPostIsolate(
            accessToken: accessToken,
            postId: postId,
            postType: postType,
          ),
          {}).then((response) {
        if (response != null) {
          //ThemeToast.successToast(response);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _viewSocialPostIsolate({
    required String accessToken,
    required String postId,
    required PostType postType,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'post_id': postId,
        'post_type': postType.param,
      });

      final dio = dioClient();
      return await dio
          .post('common/log_video_view', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return response.data['message'];
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

  //Update comment permission
  Future<void> changePostCommentPermission({
    required String postId,
    required PostType postType,
    required PostFrom postFrom,
    required PostCommentPermission postCommentControlEnum,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      await makeIsolateApiCallWithInternetCheck(
          (_) async => _changePostCommentPermissionIsolate(
                accessToken: accessToken,
                postId: postId,
                postType: postType,
                postFrom: postFrom,
                postCommentControlEnum: postCommentControlEnum,
              ),
          {}).then((response) {
        if (response != null) {
          ThemeToast.successToast(response);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _changePostCommentPermissionIsolate({
    required String accessToken,
    required String postId,
    required PostType postType,
    required PostFrom postFrom,
    required PostCommentPermission postCommentControlEnum,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'post_id': postId,
        'access_token': accessToken,
        'post_type': postType.param,
        'post_from': postFrom.jsonName,
        'is_commenting_allowed': postCommentControlEnum.allowComment,
      });

      final dio = dioClient();
      return await dio
          .post('v2/users/posts/update_comment_permission', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return response.data['message'];
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

  //Update post share permission
  Future<void> changePostSharePermission({
    required String postId,
    required PostType postType,
    required PostFrom postFrom,
    required PostSharePermission postShareControlEnum,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      await makeIsolateApiCallWithInternetCheck(
          (_) async => _changePostSharePermissionIsolate(
                accessToken: accessToken,
                postId: postId,
                postType: postType,
                postFrom: postFrom,
                postShareControlEnum: postShareControlEnum,
              ),
          {}).then((response) {
        if (response != null) {
          ThemeToast.successToast(response);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _changePostSharePermissionIsolate({
    required String accessToken,
    required String postId,
    required PostType postType,
    required PostFrom postFrom,
    required PostSharePermission postShareControlEnum,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'post_id': postId,
        'access_token': accessToken,
        'post_type': postType.param,
        'post_from': postFrom.jsonName,
        'is_sharing_allowed': postShareControlEnum.allowShare,
      });

      final dio = dioClient();
      return await dio
          .post('v2/users/posts/update_share_permission', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return response.data['message'];
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

  //close poll
  Future<void> closePoll({
    required String postId,
    required PostFrom postFrom,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      await makeIsolateApiCallWithInternetCheck(
          (_) async => _closePollIsolate(
                accessToken: accessToken,
                postId: postId,
                postFrom: postFrom,
              ),
          {}).then((response) {
        if (response != null) {
          ThemeToast.successToast(response);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _closePollIsolate({
    required String accessToken,
    required String postId,
    required PostFrom postFrom,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'post_id': postId,
        'access_token': accessToken,
        'post_from': postFrom.jsonName,
      });

      final dio = dioClient();
      return await dio
          .post('v2/polls/polls/close_poll', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return response.data['message'];
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

  //news channel follow toggle
  Future<void> newsChannelToggleFollow(String channelId) async {
    try {
      final accessToken = await authPref.getAccessToken();
      await makeIsolateApiCallWithInternetCheck(
          (_) async => _newsChannelToggleFollowIsolate(
                accessToken: accessToken,
                channelId: channelId,
              ),
          {}).then((response) {
        if (response != null) {
          ThemeToast.successToast(response);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _newsChannelToggleFollowIsolate({
    required String accessToken,
    required String channelId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'channel_id': channelId,
        'access_token': accessToken,
      });

      final dio = dioClient();
      return await dio
          .post('channels/channel/toggleFollow', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return response.data['message'];
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
