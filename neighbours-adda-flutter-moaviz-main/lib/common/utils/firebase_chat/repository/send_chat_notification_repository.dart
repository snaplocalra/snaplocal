import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/utils/models/route_navigation_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../utility/constant/errors.dart';

class SendChatNotificationRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<void> sendChatNotification({
    required String message,
    required String receiverUserId,
    required OtherCommunicationChatNavigationDetailsModel?
        otherCommunicationChatNavigationDetailsModel,
  }) async {
    try {
      await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;

          return _sendChatNotificationIsolate(
            accessToken: accessToken,
            receiverUserId: receiverUserId,
            message: message,
            otherCommunicationChatNavigationDetailsModel:
                otherCommunicationChatNavigationDetailsModel,
          );
        },
        {'accessToken': await authPref.getAccessToken()},
      ).then((value) {
        if (value != null) {
          //Suceess
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      return;
    }
  }

  Future<String?> _sendChatNotificationIsolate({
    required String accessToken,
    required String message,
    required String receiverUserId,
    required OtherCommunicationChatNavigationDetailsModel?
        otherCommunicationChatNavigationDetailsModel,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'receiver_id': receiverUserId,
        'message': message,
        'other_communication_chat_navigation_details':
            otherCommunicationChatNavigationDetailsModel?.toJson(),
      });
      final dio = dioClient();
      return await dio.post('users/send_message', data: data).then((response) {
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
