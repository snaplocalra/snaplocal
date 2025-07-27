import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/utils/local_notification/model/local_notification_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../utility/constant/errors.dart';

class LocalNotificationRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<int> fetchNotificationCount() async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        _fetchNotificationCountIsolate,
        await authPref.getAccessToken(),
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<int> _fetchNotificationCountIsolate(String accessToken) async {
    try {
      FormData data = FormData.fromMap({'access_token': accessToken});
      final dio = dioClient();
      return await dio.post("notification_count", data: data).then((response) {
        if (response.data['status'] == "valid") {
          return response.data['data']['notification_count'];
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

  Future<LocalNotificationList> fetchNotifications({int page = 1}) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          final page = params['page']! as int;
          return _fetchNotificationsIsolate(
            accessToken: accessToken,
            page: page,
          );
        },
        {
          'accessToken': await authPref.getAccessToken(),
          'page': page,
        },
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<LocalNotificationList> _fetchNotificationsIsolate({
    required String accessToken,
    required int page,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'page': page,
      });
      final dio = dioClient();

      return await dio.post("notifications", data: data).then((response) {
        if (response.data['status'] == "valid") {
          return LocalNotificationList.fromMap(response.data);
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
