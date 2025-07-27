import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/profile/compliment_badge/models/complimented_user_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../utility/constant/errors.dart';

class ComplimentedByUserRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<List<ComplimentedUserModel>> fetchComplimentedByUsers({
    required String userId,
    required String badgeId,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) async {
        return _fetchComplimentedByUsersIsolate(
          accessToken: accessToken,
          userId: userId,
          badgeId: badgeId,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<List<ComplimentedUserModel>> _fetchComplimentedByUsersIsolate({
    required String accessToken,
    required String userId,
    required String badgeId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'badge_id': badgeId,
        'user_id': userId,
      });
      final dio = dioClient();
      return await dio
          .post('users/badges/compliment_given_users_list', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return List.from(response.data['data']).map((user) {
            return ComplimentedUserModel.fromJson(user);
          }).toList();
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
