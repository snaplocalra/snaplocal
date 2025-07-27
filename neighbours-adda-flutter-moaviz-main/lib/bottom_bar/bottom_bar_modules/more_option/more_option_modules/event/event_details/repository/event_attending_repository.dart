import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_details/models/event_attending_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../../utility/constant/errors.dart';

class EventAttendingRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<EventAttendingListModel> fetchEventAttedning({
    int page = 1,
    required String eventId,
    String? query,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();

      return await makeIsolateApiCallWithInternetCheck((_) {
        return _fetchEventDetailsIsolate(
          accessToken: accessToken,
          page: page,
          eventId: eventId,
          query: query,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<EventAttendingListModel> _fetchEventDetailsIsolate({
    required int page,
    required String accessToken,
    required String eventId,
    String? query,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'event_id': eventId,
        'keyword': query,
        'page': page,
      });
      final dio = dioClient();
      return await dio
          .post("v2/users/events/attendees", data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return EventAttendingListModel.fromJson(response.data);
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
