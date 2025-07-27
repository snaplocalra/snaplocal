import 'package:designer/utility/theme_toast.dart';
import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/manage_sale_post/models/sales_post_manage_model.dart';
import 'package:snap_local/common/utils/category/v1/model/category_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../../../utility/constant/errors.dart';

class ManageSalesRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<void> manageSalesPost({
    required SalesPostManageModel salesPostManageModel,
    required bool isEdit,
  }) async {
    try {
      final salesPostManageMap = salesPostManageModel.toMap();
      salesPostManageMap.addAll({
        'access_token': await authPref.getAccessToken(),
      });

      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          return _manageSalesIsolate(
            salesPostManageMap: params['salesPostManageMap'],
            isEdit: isEdit,
          );
        },
        {"salesPostManageMap": salesPostManageMap},
      ).then((response) {
        if (response != null) {
          ThemeToast.successToast(response);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _manageSalesIsolate({
    required Map<String, dynamic> salesPostManageMap,
    required bool isEdit,
  }) async {
    try {
      FormData data = FormData.fromMap(salesPostManageMap);
      final dio = dioClient();
      return await dio
          .post("v3/market/market/${isEdit ? 'update' : 'add'}", data: data)
          .then((response) {
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

  Future<CategoryListModel> fetchSalesCategories() async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        _fetchSalesCategoriesIsolate,
        await authPref.getAccessToken(),
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<CategoryListModel> _fetchSalesCategoriesIsolate(
      String accessToken) async {
    try {
      FormData data = FormData.fromMap({'access_token': accessToken});

      final dio = dioClient();
      return await dio
          .post('market/sales_item_categories', data: data)
          .then((response) {
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
