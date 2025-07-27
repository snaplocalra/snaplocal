import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/utils/helpline_numbers/model/helpline_number_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../utility/constant/errors.dart';

class HelpLineNumberRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<List<HelplineNumberModel>> fetchHelplineNumbers() async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck(
        _fetchHelplineNumbersIsolate,
        accessToken,
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<List<HelplineNumberModel>> _fetchHelplineNumbersIsolate(
      String accessToken) async {
    try {
      FormData data = FormData.fromMap({'access_token': accessToken});
      final dio = dioClient();
      return await dio
          .post('common/helpline_numbers', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return List.from(response.data['data']).map((e) {
            return HelplineNumberModel.fromJson(e);
          }).toList();
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
