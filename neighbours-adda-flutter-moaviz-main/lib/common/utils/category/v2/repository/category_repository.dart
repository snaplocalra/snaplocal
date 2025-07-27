import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/utils/category/v2/model/category_model_v2.dart';
import 'package:snap_local/common/utils/category/v2/repository/category_repository_impl.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../utility/constant/errors.dart';

class CategoryRepository extends BaseApi implements CategoryRepositoryImpl {
  //Fetch categories from the server
  @override
  Future<CategoryListModelV2> fetchCategories(String apiEndpoint) async {
    try {
      final accessToken =
          await AuthenticationTokenSharedPref().getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _fetchCategoriesIsolate(
          accessToken: accessToken,
          apiEndpoint: apiEndpoint,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<CategoryListModelV2> _fetchCategoriesIsolate({
    required String accessToken,
    required String apiEndpoint,
  }) async {
    try {
      FormData data = FormData.fromMap({'access_token': accessToken});

      final dio = dioClient();
      return await dio.post(apiEndpoint, data: data).then((response) {
        if (response.data['status'] == "valid") {
          return CategoryListModelV2.fromMap(response.data['data']);
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
