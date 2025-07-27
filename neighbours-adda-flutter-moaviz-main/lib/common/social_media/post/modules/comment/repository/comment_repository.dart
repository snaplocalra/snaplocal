import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/modules/comment/models/comment_model.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_from_enum.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../utility/constant/errors.dart';

class CommentRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<CommentListModel> fetchComments({
    int page = 1,
    required String postId,
    required PostFrom postFrom,
    required PostType postType,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck(
        (_) {
          return _fetchCommentsIsolate(
            page: page,
            accessToken: accessToken,
            postId: postId,
            postFrom: postFrom,
            postType: postType,
          );
        },
        {},
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<CommentListModel> _fetchCommentsIsolate({
    required int page,
    required String accessToken,
    required String postId,
    required PostFrom postFrom,
    required PostType postType,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'page': page,
        'post_id': postId,
        'post_from': postFrom.jsonName,
        'post_type': postType.param,
      });
      final dio = dioClient();
      return await dio.post("v2/users/comment", data: data).then((response) {
        if (response.data['status'] == "valid") {
          return CommentListModel.fromMap(response.data);
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

  Future<String> postComment({
    required String postId,
    String? parentCommentId,
    required String comment,
    required PostFrom postFrom,
    required PostType postType,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) async {
        return _postCommentIsolate(
          accessToken: accessToken,
          postId: postId,
          parentCommentId: parentCommentId,
          comment: comment,
          postFrom: postFrom,
          postType: postType,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String> _postCommentIsolate({
    required String accessToken,
    required String postId,
    String? parentCommentId,
    required String comment,
    required PostFrom postFrom,
    required PostType postType,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'post_id': postId,
        'parent_comment_id': parentCommentId,
        'comment': comment,
        'post_type': postType.param,
        'post_from': postFrom.jsonName,
      });
      final dio = dioClient();
      return await dio
          .post("v2/users/comment/add", data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return response.data['comment_id'];
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

  Future<void> deleteComment({
    required String postId,
    required String parentCommentId,
    String? childCommentId,
    required PostFrom postFrom,
    required PostType postType,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck(
        (_) async {
          return _deleteCommentIsolate(
            accessToken: accessToken,
            postId: postId,
            parentCommentId: parentCommentId,
            childCommentId: childCommentId,
            postFrom: postFrom,
            postType: postType,
          );
        },
        {},
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<void> _deleteCommentIsolate({
    required String accessToken,
    required String postId,
    required String parentCommentId,
    String? childCommentId,
    required PostFrom postFrom,
    required PostType postType,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'post_id': postId,
        'parent_comment_id': parentCommentId,
        'child_comment_id': childCommentId,
        'post_type': postType.param,
        'post_from': postFrom.jsonName,
      });
      final dio = dioClient();
      return await dio
          .post("v2/users/comment/delete", data: data)
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

//edit comment
  Future<void> editComment({
    required String postId,
    required String parentCommentId,
    required String? childCommentId,
    required String comment,
    required PostType postType,
    required PostFrom postFrom,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck(
        (_) async {
          return _editCommentIsolate(
            accessToken: accessToken,
            postId: postId,
            comment: comment,
            postFrom: postFrom,
            postType: postType,
            childCommentId: childCommentId,
            parentCommentId: parentCommentId,
          );
        },
        {},
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<void> _editCommentIsolate({
    required String accessToken,
    required String postId,
    required String parentCommentId,
    required String? childCommentId,
    required String comment,
    required PostFrom postFrom,
    required PostType postType,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'post_id': postId,
        'parent_comment_id': parentCommentId,
        'child_comment_id': childCommentId,
        'comment': comment,
        'post_type': postType.param,
        'post_from': postFrom.jsonName,
      });
      final dio = dioClient();
      return await dio
          .post("v2/users/comment/edit", data: data)
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


//hide comment
  Future<void> hideComment({
    required String postId,
    required String parentCommentId,
    String? childCommentId,
    required PostFrom postFrom,
    required PostType postType,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck(
        (_) async {
          return _hideCommentIsolate(
            accessToken: accessToken,
            postId: postId,
            parentCommentId: parentCommentId,
            childCommentId: childCommentId,
            postFrom: postFrom,
            postType: postType,
          );
        },
        {},
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<void> _hideCommentIsolate({
    required String accessToken,
    required String postId,
    required String parentCommentId,
    String? childCommentId,
    required PostFrom postFrom,
    required PostType postType,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'post_id': postId,
        'parent_comment_id': parentCommentId,
        'child_comment_id': childCommentId,
        'post_type': postType.param,
        'post_from': postFrom.jsonName,
      });
      final dio = dioClient();
      return await dio
          .post("v2/users/comment/hide", data: data)
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
