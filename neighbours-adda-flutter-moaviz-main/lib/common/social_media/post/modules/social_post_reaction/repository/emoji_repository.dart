import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/model/post_reaction_details_model.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_from_enum.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../utility/constant/errors.dart';

class ReactionRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<void> givePostReaction({
    required String postId,
    required String reactionId,
    required PostFrom postFrom,
    required PostType postType,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) async {
        return _givePostReactionIsolate(
          accessToken: accessToken,
          postId: postId,
          reactionId: reactionId,
          postFrom: postFrom,
          postType: postType,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<void> _givePostReactionIsolate({
    required String accessToken,
    required String postId,
    required String reactionId,
    required PostFrom postFrom,
    required PostType postType,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'post_id': postId,
        'emoji_id': reactionId,
        'post_type': postType.param,
        'post_from': postFrom.jsonName,
      });
      final dio = dioClient();
      return await dio
          .post("v2/users/post_reactions", data: data)
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

  Future<void> givePostCommentReaction({
    required String postId,
    required String reactionId,
    required PostFrom postFrom,
    required PostType postType,
    required String parentCommentId,
    required String? childCommentId,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) async {
        return _givePostCommentReactionIsolate(
          accessToken: accessToken,
          postId: postId,
          reactionId: reactionId,
          postFrom: postFrom,
          postType: postType,
          parentCommentId: parentCommentId,
          childCommentId: childCommentId,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<void> _givePostCommentReactionIsolate({
    required String accessToken,
    required String postId,
    required String reactionId,
    required PostFrom postFrom,
    required PostType postType,
    required String parentCommentId,
    required String? childCommentId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'post_id': postId,
        'emoji_id': reactionId,
        'post_from': postFrom.jsonName,
        'post_type': postType.param,
        'parent_comment_id': parentCommentId,
        'child_comment_id': childCommentId,
      });
      final dio = dioClient();
      return await dio
          .post("v2/users/comment_reactions/add", data: data)
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

  Future<PostReactionDetails> getPostReactionDetails({
    required String postId,
    required PostFrom postFrom,
    required PostType postType,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) async {
        return _getPostReactionDetailsIsolate(
          accessToken: accessToken,
          postId: postId,
          postFrom: postFrom,
          postType: postType,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<PostReactionDetails> _getPostReactionDetailsIsolate({
    required String accessToken,
    required String postId,
    required PostFrom postFrom,
    required PostType postType,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'post_id': postId,
        'post_from': postFrom.jsonName,
        'post_type': postType.param,
      });
      final dio = dioClient();
      return await dio
          .post("v2/users/post_reactions_details", data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          if (response.data.containsKey('data') && response.data['data'].isNotEmpty) {
            return PostReactionDetails.fromJson(response.data['data']);
          } else {
            throw ("No one reacted to this post");
          }
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
