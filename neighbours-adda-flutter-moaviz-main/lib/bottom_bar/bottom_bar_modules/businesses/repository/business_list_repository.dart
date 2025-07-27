import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/models/business_list_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/models/business_view_type.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../utility/constant/errors.dart';

class BusinessListRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<BusinessListModel> fetchBusiness({
    int page = 1,
    required String? filterJson,
    required String searchKeyword,
    required BusinessViewType businessViewType,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _fetchBusinessIsolate(
          accessToken: accessToken,
          page: page,
          filterJson: filterJson,
          searchKeyword: searchKeyword,
          businessViewType: businessViewType,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<BusinessListModel> _fetchBusinessIsolate({
    required String accessToken,
    required int page,
    required String? filterJson,
    required String searchKeyword,
    required BusinessViewType businessViewType,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'page': page,
        'filter': filterJson,
        'search_keyword': searchKeyword,
        'type': businessViewType.name,
      });
      final dio = dioClient();
      return await dio
          .post("business/business_page", data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return BusinessListModel.fromJson(response.data);
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

  Future<BusinessListModel> searchBusiness({
    int page = 1,
    required String query,
    required String businessCategoryId,
    required BusinessViewType businessViewType,
  }) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _searchBusinessIsolate(
            page: page,
            query: query,
            accessToken: accessToken,
            businessViewType: businessViewType,
            businessCategoryId: businessCategoryId,
          );
        },
        {'accessToken': await authPref.getAccessToken()},
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<BusinessListModel> _searchBusinessIsolate({
    required String query,
    required int page,
    required String accessToken,
    required String businessCategoryId,
    required BusinessViewType businessViewType,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'page': page,
        'keyword': query,
        'access_token': accessToken,
        'type': businessViewType.name,
        'business_category_id': businessCategoryId,
      });
      final dio = dioClient();
      return await dio
          .post("business/business_page/search", data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return BusinessListModel.fromJson(response.data);
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
