import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_from_enum.dart';
import 'package:snap_local/common/utils/report/model/report_type.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../utility/constant/errors.dart';

class HidePostRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();
  Future<void> hideGeneralPost({
    required String postId,
    required ReportType reportType,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      await makeIsolateApiCallWithInternetCheck((_) {
        return _hideGeneralPostIsolate(
          accessToken: accessToken,
          postId: postId,
          reportType: reportType,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  void _hideGeneralPostIsolate({
    required String postId,
    required String accessToken,
    required ReportType reportType,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'post_id': postId,
        'report_type': reportType.jsonName,
      });
      final dio = dioClient();
      return await dio
          .post("v2/common/hide_general_post", data: data)
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

  Future<void> hideSocialPost({
    required String postId,
    required PostFrom postFrom,
    required PostType postType,
    required ReportType reportType,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      await makeIsolateApiCallWithInternetCheck((_) {
        return _hideSocialPostIsolate(
          accessToken: accessToken,
          postId: postId,
          postFrom: postFrom,
          postType: postType,
          reportType: reportType,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  void _hideSocialPostIsolate({
    required String postId,
    required String accessToken,
    required PostFrom postFrom,
    required PostType postType,
    required ReportType reportType,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'post_id': postId,
        'post_type': postType.param,
        'post_from': postFrom.jsonName,
        'report_type': reportType.jsonName,
      });
      final dio = dioClient();
      await dio.post("v2/common/hide_social_post", data: data).then((response) {
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
