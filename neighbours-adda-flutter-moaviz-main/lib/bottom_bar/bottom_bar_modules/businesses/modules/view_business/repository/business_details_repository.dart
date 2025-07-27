import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/view_business/models/business_details_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../utility/constant/errors.dart';

class BusinessDetailsRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<BusinessDetailsModel> fetchBusinessDetails(String businessId) async {
    final dataMap = {
      "access_token": await authPref.getAccessToken(),
      "business_id": businessId
    };

    try {
      return await makeIsolateApiCallWithInternetCheck(
        _fetchBusinessDetailsIsolate,
        dataMap,
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<BusinessDetailsModel> _fetchBusinessDetailsIsolate(
      Map<String, String> dataMap) async {
    try {
      FormData data = FormData.fromMap(dataMap);

      final dio = dioClient();
      return await dio
          .post('business/business_page/view', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return BusinessDetailsModel.fromJson(response.data['data']);
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

  Future<BusinessDetailsModel?> checkBusinessDetails() async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        _checkBusinessDetailsIsolate,
        await authPref.getAccessToken(),
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<BusinessDetailsModel?> _checkBusinessDetailsIsolate(
      String accessToken) async {
    try {
      FormData data = FormData.fromMap({'access_token': accessToken});
      final dio = dioClient();
      return await dio
          .post('business/business_page/check', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return (response.data['data'] == null)
              ? null
              : BusinessDetailsModel.fromJson(response.data['data']);
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
