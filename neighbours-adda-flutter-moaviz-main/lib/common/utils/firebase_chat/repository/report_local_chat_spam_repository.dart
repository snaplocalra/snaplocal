import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/utils/firebase_chat/model/local_chat_flag_response.dart';
import 'package:snap_local/common/utils/firebase_chat/model/report_local_chat_spam_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';
import 'dart:convert';

import '../../../../utility/constant/errors.dart';

class ReportLocalChatSpamRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<ReportLocalChatSpamReasonList> fetchReportReasons() async {
    try {
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _fetchReportReasonsIsolate();
      }, {});
    } catch (e) {
      rethrow;
    }
  }

  Future<ReportLocalChatSpamReasonList> _fetchReportReasonsIsolate() async {
    try {
      final dio = dioClient();
      FormData data = FormData.fromMap({'type': 'chat'});
      return await dio
          .post("v2/common/report_reasons", data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return ReportLocalChatSpamReasonList.fromMap(response.data);
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw (ErrorConstants.serverError);
        }
      }
      rethrow;
    }
  }

  Future<void> submitReport({
    required String flaggedUserId,
    required String reasonId,
    String? additionalDetails,
    String? image,
    String? reportMessage,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();

      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'reason_id': reasonId,
        'additional_details': additionalDetails,
        'flagged_user_id': flaggedUserId,
        'reported_message': reportMessage,
      });

      // If image is provided, convert base64 to bytes and add as multipart file
      if (image != null) {
        final bytes = base64Decode(image);
        final multipartFile = MultipartFile.fromBytes(
          bytes,
          filename: 'screenshot.png',
        );
        data.files.add(MapEntry('image', multipartFile));
      }

      final dio = dioClient();
      return await dio.post('common/local_chat_report', data: data).then((response) {
        if (response.data['status'] == "valid") {
          return response.data['message'];
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<LocalChatFlagResponse> getFlagCount(String userId) async {
    try {
      final dio = dioClient();
      final accessToken = await authPref.getAccessToken();

      final response = await dio.post(
        'common/local_chat_flaged_count',
        data: FormData.fromMap({
          'access_token': accessToken,
          'user_id': userId,
        }),
      );

      if (response.data != null) {
        return LocalChatFlagResponse.fromJson(response.data);
      }
      throw Exception('Invalid response format');
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 500) {
        throw Exception('Server error');
      }
      rethrow;
    }
  }

  Future<void> updateFlagCount({
    required String userId,
    required String messageId,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();

      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'user_id': userId,
        'message_id': messageId,
      });

      final dio = dioClient();
      return await dio
          .post('common/update_local_chat_flag_count', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return response.data['message'];
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      rethrow;
    }
  }
}