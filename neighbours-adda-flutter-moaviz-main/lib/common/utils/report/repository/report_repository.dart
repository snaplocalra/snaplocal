import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/utils/report/model/report_model.dart';
import 'package:snap_local/common/utils/report/model/report_screen_payload.dart';
import 'package:snap_local/common/utils/report/model/report_type.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../utility/constant/errors.dart';

class ReportRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<ReportReasonList> fetchReportReasons(ReportType reportType) async {
    try {
      // final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _fetchReportReasonsIsolate(reportType);
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<ReportReasonList> _fetchReportReasonsIsolate(
      ReportType reportType) async {
    try {
      final dio = dioClient();
      FormData data = FormData.fromMap({'type': reportType.jsonName});
      return await dio
          .post("v2/common/report_reasons", data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return ReportReasonList.fromMap(response.data);
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

  //Submit report
  Future<void> submitReport({
    required ReportScreenPayload payload,
    required String additionalDetails,
    required String reasonId,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();

      FormData data = FormData.fromMap(
        payload.payloadMap()
          ..addAll({
            'access_token': accessToken,
            'reason_id': reasonId,
            'additional_details': additionalDetails,
          }),
      );

      final dio = dioClient();
      return await dio.post(payload.submitApi, data: data).then((response) {
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
