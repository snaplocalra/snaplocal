import 'package:designer/utility/theme_toast.dart';
import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/help_and_support/model/support_report_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../utility/constant/errors.dart';

class HelpSupportRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<void> submitSupportReport(
      SupportReportModel supportReportModel) async {
    try {
      final supportReportDataMap = supportReportModel.toMap();
      supportReportDataMap
          .addAll({'access_token': await authPref.getAccessToken()});
      return await makeIsolateApiCallWithInternetCheck(
              _submitSupportReportIsolate, supportReportDataMap)
          .then((response) {
        if (response != null) {
          ThemeToast.successToast(response);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _submitSupportReportIsolate(
      Map<String, dynamic> supportReportDataMap) async {
    try {
      FormData data = FormData.fromMap(supportReportDataMap);
      final dio = dioClient();
      return await dio.post('support_help', data: data).then((response) {
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
