import 'package:designer/utility/theme_toast.dart';
import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/manage_business/models/business_manage_model.dart';
import 'package:snap_local/common/utils/category/v1/model/category_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../utility/constant/errors.dart';

class ManageBusinessRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<void> manageBusiness({
    required BusinessManageModel businessManageModel,
    required bool isEdit,
  }) async {
    try {
      final manageBusinessMap = businessManageModel.toMap();
      manageBusinessMap.addAll({
        'access_token': await authPref.getAccessToken(),
      });
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          return _manageBusinessIsolate(
            manageBusinessMap: params['manageBusinessMap'],
            isEdit: isEdit,
          );
        },
        {"manageBusinessMap": manageBusinessMap},
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

  Future<String?> _manageBusinessIsolate({
    required Map<String, dynamic> manageBusinessMap,
    required bool isEdit,
  }) async {
    try {
      FormData data = FormData.fromMap(manageBusinessMap);
      final dio = dioClient();
      return await dio
          .post("business/business_page/${isEdit ? 'update' : 'add'}",
              data: data)
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

  Future<CategoryListModel> fetchBusinessCategories() async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        _fetchBusinessCategoriesIsolate,
        await authPref.getAccessToken(),
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<CategoryListModel> _fetchBusinessCategoriesIsolate(
      String accessToken) async {
    try {
      FormData data = FormData.fromMap({'access_token': accessToken});

      final dio = dioClient();
      return await dio
          .post('business/business_categories', data: data)
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

//Delete business
  Future<void> deleteBusiness(String businessId) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck(
          (_) => _deleteBusinessIsolate(
                businessId: businessId,
                accessToken: accessToken,
              ),
          {}).then((response) {
        if (response != null) {
          ThemeToast.successToast(response);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _deleteBusinessIsolate({
    required String businessId,
    required String accessToken,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'business_id': businessId,
      });
      final dio = dioClient();
      return await dio
          .post("business/business_page/delete", data: data)
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
}
