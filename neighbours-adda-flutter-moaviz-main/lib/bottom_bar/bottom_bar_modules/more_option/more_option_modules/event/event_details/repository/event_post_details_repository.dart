import 'package:designer/utility/theme_toast.dart';
import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_details/models/event_details_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../../utility/constant/errors.dart';

class EventDetailsRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<EventDetailsModel> fetchEventDetails(String eventId) async {
    try {
      final accessToken = await authPref.getAccessToken();

      return await makeIsolateApiCallWithInternetCheck((_) {
        return _fetchEventDetailsIsolate(
          accessToken: accessToken,
          eventId: eventId,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<EventDetailsModel> _fetchEventDetailsIsolate({
    required String accessToken,
    required String eventId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'post_id': eventId,
      });
      final dio = dioClient();
      return await dio
          .post("v2/users/events/view", data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return EventDetailsModel.fromJson(response.data['data']);
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

  Future<void> toggleAttending(String eventId) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _toggleAttendingIsolate(
          accessToken: accessToken,
          eventId: eventId,
        );
      }, {}).then((message) {
        if (message != null) {
          ThemeToast.successToast(message);
          return;
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _toggleAttendingIsolate({
    required String accessToken,
    required String eventId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'event_id': eventId,
      });
      final dio = dioClient();
      return await dio
          .post("v2/users/events/attend", data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return response.data['message'];
        } else {
          throw response.data['message'];
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

  Future<void> cancelEvent(String eventId) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _cancelEventIsolate(
          accessToken: accessToken,
          eventId: eventId,
        );
      }, {}).then((message) {
        if (message != null) {
          ThemeToast.successToast(message);
          return;
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _cancelEventIsolate({
    required String accessToken,
    required String eventId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'event_id': eventId,
      });
      final dio = dioClient();
      return await dio
          .post("v2/users/events/cancel", data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return response.data['message'];
        } else {
          throw response.data['message'];
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
