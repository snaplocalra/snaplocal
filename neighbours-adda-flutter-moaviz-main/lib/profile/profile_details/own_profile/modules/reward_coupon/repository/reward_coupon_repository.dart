import 'package:designer/utility/theme_toast.dart';
import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/profile/profile_details/own_profile/modules/reward_coupon/models/reward_coupon_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../utility/constant/errors.dart';

class RewardCouponRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  //Fetch copouns list
  Future<RewardCouponDataModel> fetchCouponsList() async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck(
        _fetchShopPointsIsolate,
        accessToken,
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<RewardCouponDataModel> _fetchShopPointsIsolate(
      String accessToken) async {
    try {
      FormData data = FormData.fromMap({'access_token': accessToken});
      final dio = dioClient();
      return await dio
          .post('v2/myprofile/coupons', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return RewardCouponDataModel.fromMap(response.data['data']);
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

  //Redeem points
  Future<void> redeemPoints(String couponId) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) async {
        await _redeemPointsIsolate(
          accessToken: accessToken,
          couponId: couponId,
        );
      }, {}).then((response) {
        if (response != null) {
          ThemeToast.successToast(response.toString());
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _redeemPointsIsolate({
    required String accessToken,
    required String couponId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'coupon_id': couponId,
      });
      final dio = dioClient();
      return await dio
          .post('v2/myprofile/redeem_coupon', data: data)
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
