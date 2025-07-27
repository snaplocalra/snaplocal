import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';

class LevelDetailsRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  // Future<RewardDetailsModel> fetchRewardDetails() async {
  //   try {
  //     final accessToken = await authPref.getAccessToken();

  //     return await makeIsolateApiCallWithInternetCheck(
  //       _fetchRewardDetailsIsolate,
  //       accessToken,
  //     );
  //   } catch (e) {
  //     // Record the error in Firebase Crashlytics
  //     rethrow;
  //   }
  // }

  // Future<RewardDetailsModel> _fetchRewardDetailsIsolate(
  //   String accessToken,
  // ) async {
  //   try {
  //     FormData data = FormData.fromMap({'access_token': accessToken});
  //     final dio = dioClient();
  //     return await dio
  //         .post('v2/myprofile/reward_points_details', data: data)
  //         .then((response) {
  //       if (response.data['status'] == "valid") {
  //         return RewardDetailsModel.fromMap(response.data['data']);
  //       } else {
  //         throw (response.data['message']);
  //       }
  //     });
  //   } catch (e) {
  //     // Record the error in Firebase Crashlytics
  //     if (e is DioException) {
  //       if (e.response?.statusCode == 500) {
  //         throw (ErrorConstants.serverError);
  //       }
  //     }
  //     rethrow;
  //   }
  // }
}
