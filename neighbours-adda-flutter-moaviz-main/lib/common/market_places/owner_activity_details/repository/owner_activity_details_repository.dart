import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/market_places/owner_activity_details/model/owner_activity_details_enum.dart';
import 'package:snap_local/common/market_places/owner_activity_details/model/owner_activity_details_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../utility/constant/errors.dart';

class OwnerActivityDetailsRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<OwnerActivityDetailsModel> fetchOwnerActivity({
    required String postId,
    required OwnerActivityType ownerActivityType,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck(
        (_) => _fetchOwnerActivityIsolate(
          postId: postId,
          accessToken: accessToken,
          ownerActivityType: ownerActivityType,
        ),
        {},
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<OwnerActivityDetailsModel> _fetchOwnerActivityIsolate({
    required String accessToken,
    required String postId,
    required OwnerActivityType ownerActivityType,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'post_id': postId,
        'activity_type': ownerActivityType.jsonName,
      });
      final dio = dioClient();
      return await dio
          .post('v2/common/owner_activity_details', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return OwnerActivityDetailsModel.getModelByType(
              response.data['data']);
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
