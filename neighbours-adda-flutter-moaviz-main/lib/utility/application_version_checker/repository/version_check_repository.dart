import 'dart:io';

import 'package:dio/dio.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/application_version_checker/model/application_version_checker_model.dart';

import '../../constant/errors.dart';

class VersionCheckRepository extends BaseApi {
  VersionCheckRepository();

  Future<ApplicationVersionCheckerModel> checkVersionData() async {
    try {
      FormData data = FormData.fromMap({
        "device_type": Platform.isAndroid ? "android" : "ios",
      });
      final dio = dioClient();
      return await dio.post('app_version', data: data).then((response) {
        if (response.data['status'] == "valid") {
          return ApplicationVersionCheckerModel.fromMap(response.data['data']);
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      print("|||||||||||||||||||||Error|||||||||||||||||");
      print(e.toString());
      // Record the error in Firebase Crashlytics
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw (ErrorConstants.serverError);
        } else {
          throw ("Unable to fetch data");
        }
      } else {
        rethrow;
      }
    }
  }
}
