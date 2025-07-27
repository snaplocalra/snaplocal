import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/market_places/interested_people_list/model/interested_people_model.dart';
import 'package:snap_local/common/market_places/models/market_place_type.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../utility/constant/errors.dart';

class InterestedPeopleRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<InterestedPeopleListModel> fetchInterestedPeopleList({
    int page = 1,
    required String postId,
    required MarketPlaceType marketPlaceType,
    String? query,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();

      return await makeIsolateApiCallWithInternetCheck((_) {
        return _fetchEventDetailsIsolate(
          accessToken: accessToken,
          page: page,
          postId: postId,
          marketPlaceType: marketPlaceType,
          query: query,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<InterestedPeopleListModel> _fetchEventDetailsIsolate({
    required int page,
    required String accessToken,
    required String postId,
    required MarketPlaceType marketPlaceType,
    String? query,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'post_id': postId,
        'type': marketPlaceType.jsonName,
        'keyword': query,
        'page': page,
      });
      final dio = dioClient();
      return await dio
          .post("v2/interested_user_list", data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return InterestedPeopleListModel.fromJson(response.data);
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
