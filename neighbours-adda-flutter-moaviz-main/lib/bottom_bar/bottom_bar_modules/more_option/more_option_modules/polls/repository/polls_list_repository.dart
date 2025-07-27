import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/models/polls_list_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/models/polls_list_type.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../utility/constant/errors.dart';

class PollsListRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<PollsListModel> fetchPolls({
    int page = 1,
    required PollsListType pollsListType,
    String? filterJson,
    String? searchKeyword,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _fetchPollsIsolate(
          accessToken: accessToken,
          page: page,
          pollsListType: pollsListType,
          filterJson: filterJson,
          searchKeyword: searchKeyword,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<PollsListModel> _fetchPollsIsolate({
    required String accessToken,
    required int page,
    required PollsListType pollsListType,
    String? filterJson,
    String? searchKeyword,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'page': page,
        'search_keyword': searchKeyword,
        'filter': filterJson,
      });
      final dio = dioClient();
      return await dio.post(pollsListType.api, data: data).then((response) {
        if (response.data['status'] == "valid") {
          return PollsListModel.fromJson(response.data);
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
