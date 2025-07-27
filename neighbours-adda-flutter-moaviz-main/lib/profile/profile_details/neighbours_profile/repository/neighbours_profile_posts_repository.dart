import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/profile/profile_details/neighbours_profile/model/neighbours_profile_posts_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../utility/constant/errors.dart';

class NeighboursProfileRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<NeighboursProfileModel> fetchNeighboursProfile(
      {required String userId}) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck(
        (_) {
          return _fetchNeighboursProfileAndPostsIsolate(
            accessToken: accessToken,
            userId: userId,
          );
        },
        {},
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<NeighboursProfileModel> _fetchNeighboursProfileAndPostsIsolate({
    required String accessToken,
    required String userId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'user_id': userId,
      });
      final dio = dioClient();
      return await dio
          .post('v2/users/other_user_profile', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return NeighboursProfileModel.fromMap(response.data["data"]);
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
