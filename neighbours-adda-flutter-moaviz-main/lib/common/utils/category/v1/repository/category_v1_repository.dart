import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/utils/category/v1/model/category_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../utility/constant/errors.dart';

class CategoryV1Repository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<CategoryListModel> fetchCategory(String apiEndPoint) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) async {
        return _fetchCategoryIsolate(
          accesstoken: accessToken,
          apiEndPoint: apiEndPoint,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<CategoryListModel> _fetchCategoryIsolate({
    required String accesstoken,
    required String apiEndPoint,
  }) async {
    try {
      FormData data = FormData.fromMap({'access_token': accesstoken});
      final dio = dioClient();
      return await dio.post(apiEndPoint, data: data).then((response) {
        if (response.data['status'] == "valid") {
          return CategoryListModel.fromMap(response.data);
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
