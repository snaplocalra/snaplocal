import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/models/sales_post_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/models/sales_post_short_details_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../utility/constant/errors.dart';

class SalesPostRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<SalesPostListModel> fetchNeighboursPostedSalesPosts({
    int page = 1,
    required SalesPostListType salesPostListType,
    required String? filterJson,
    required String? searchKeyword,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _fetchNeighboursPostedSalesPostsIsolate(
          accessToken: accessToken,
          page: page,
          salesPostListType: salesPostListType,
          filterJson: filterJson,
          searchKeyword: searchKeyword,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<SalesPostListModel> _fetchNeighboursPostedSalesPostsIsolate({
    required String accessToken,
    required int page,
    required SalesPostListType salesPostListType,
    required String? filterJson,
    required String? searchKeyword,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'page': page,
        'search_keyword': searchKeyword,
        'filter': filterJson,
      });

      final dio = dioClient();
      return await dio.post(salesPostListType.api, data: data).then((response) {
        if (response.data['status'] == "valid") {
          return SalesPostListModel.fromJson(response.data);
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

  Future<SalesPostListModel> fetchOwnPostedSalesPosts({
    int page = 1,
    required SalesPostListType salesPostListType,
    required String? filterJson,
    required String? searchKeyword,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _fetchOwnPostedSalesPostsIsolate(
          accessToken: accessToken,
          page: page,
          salesPostListType: salesPostListType,
          filterJson: filterJson,
          searchKeyword: searchKeyword,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<SalesPostListModel> _fetchOwnPostedSalesPostsIsolate({
    required String accessToken,
    required int page,
    required SalesPostListType salesPostListType,
    required String? filterJson,
    required String? searchKeyword,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'page': page,
        'search_keyword': searchKeyword,
        'filter': filterJson,
      });
      final dio = dioClient();
      return await dio.post(salesPostListType.api, data: data).then((response) {
        if (response.data['status'] == "valid") {
          return SalesPostListModel.fromJson(response.data);
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
