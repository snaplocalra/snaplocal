import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/models/sales_post_short_details_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_list/models/event_post_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_list/models/event_post_short_details_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../../utility/constant/errors.dart';

class EventPostRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<EventPostListModel> fetchEventPosts({
    int page = 1,
    required EventPostListType eventPostListType,
    String? filterJson,
    String? searchKeyword,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _fetchEventPostsIsolate(
          accessToken: accessToken,
          page: page,
          eventPostListType: eventPostListType,
          filterJson: filterJson,
          searchKeyword: searchKeyword,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<EventPostListModel> _fetchEventPostsIsolate({
    required String accessToken,
    required int page,
    required EventPostListType eventPostListType,
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
      return await dio.post(eventPostListType.api, data: data).then((response) {
        if (response.data['status'] == "valid") {
          return EventPostListModel.fromJson(response.data);
        } else if (response.data['status'] == "invalid") {
          return EventPostListModel.emptyModel();
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

  Future<SalesPostListModel> searchEventPosts({
    int page = 1,
    required String query,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();

      return await makeIsolateApiCallWithInternetCheck((_) {
        return _searchEventPostsIsolate(
          page: page,
          query: query,
          accessToken: accessToken,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<SalesPostListModel> _searchEventPostsIsolate({
    required int page,
    required String query,
    required String accessToken,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'page': page,
        'keyword': query,
        'access_token': accessToken,
      });

      final dio = dioClient();
      return await dio
          .post("market/market/search", data: data)
          .then((response) {
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
