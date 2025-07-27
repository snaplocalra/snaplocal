import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/model/dynamic_category_field_models/dynamic_category_field.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/model/dynamic_category_post_from.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../utility/constant/errors.dart';

class DynamicCategoryFieldRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<List<DynamicCategoryField>> fetchDynamicCategoryFields({
    required String categoryId,
    required DynamicCategoryPostFrom dynamicCategoryPostFrom,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _fetchDynamicCategoryFieldsIsolate(
          accessToken: accessToken,
          categoryId: categoryId,
          dynamicCategoryPostFrom: dynamicCategoryPostFrom,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<List<DynamicCategoryField>> _fetchDynamicCategoryFieldsIsolate({
    required String accessToken,
    required String categoryId,
    required DynamicCategoryPostFrom dynamicCategoryPostFrom,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'category_id': categoryId,
        'post_from': dynamicCategoryPostFrom.jsonValue,
      });
      final dio = dioClient();
      return await dio
          .post("common/get_category_fields", data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return List<DynamicCategoryField>.from(
            response.data['data'].map((x) => DynamicCategoryField.fromType(x)),
          );
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
