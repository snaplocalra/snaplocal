import 'package:designer/utility/theme_toast.dart';
import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/sales_post_details/models/sale_post_mark_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/sales_post_details/models/sales_post_detail_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../../../utility/constant/errors.dart';

class SalesPostDetailsRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<SalesPostDetailModel> fetchSalesPostDetails(
      {required String salesPostId}) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _fetchSalesPostDetailsIsolate(
            accessToken: accessToken,
            salesPostId: salesPostId,
          );
        },
        {'accessToken': await authPref.getAccessToken()},
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<SalesPostDetailModel> _fetchSalesPostDetailsIsolate({
    required String accessToken,
    required String salesPostId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'post_id': salesPostId,
      });
      final dio = dioClient();
      return await dio
          .post("v3/market/market/view", data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return SalesPostDetailModel.fromJson(response.data['data']);
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

  Future<void> markAs({
    required String postId,
    required SalesPostMarkType salesPostMarkType,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _markAsIsolate(
          postId: postId,
          accessToken: accessToken,
          salesPostMarkType: salesPostMarkType,
        );
      }, {}).then((message) {
        if (message != null) {
          ThemeToast.successToast(message);
          return;
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _markAsIsolate({
    required String accessToken,
    required String postId,
    required SalesPostMarkType salesPostMarkType,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'post_id': postId,
      });

      final dio = dioClient();
      return await dio
          .post("v2/market/market/${salesPostMarkType.endPoint}", data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return response.data['message'];
        } else {
          throw response.data['message'];
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
