import 'package:designer/utility/theme_toast.dart';
import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../../../../../utility/constant/errors.dart';

class PageConnectionRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<void> sendAndRemovePageFollowRequest({required String pageId}) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _sendAndRemovePageFollowRequestIsolate(
            accessToken: accessToken,
            pageId: pageId,
          );
        },
        {'accessToken': await authPref.getAccessToken()},
      ).then((response) => ThemeToast.successToast(response));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String> _sendAndRemovePageFollowRequestIsolate({
    required String accessToken,
    required String pageId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'page_id': pageId,
      });
      final dio = dioClient();
      return await dio
          .post('pages/my_following_pages/add', data: data)
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

  Future<void> leavePage({required String pageId}) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _leavePageIsolate(
            accessToken: accessToken,
            pageId: pageId,
          );
        },
        {'accessToken': await authPref.getAccessToken()},
      ).then((response) => ThemeToast.successToast(response));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String> _leavePageIsolate({
    required String accessToken,
    required String pageId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'page_id': pageId,
      });

      final dio = dioClient();
      return await dio
          .post('page/page_connections/leave', data: data)
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
