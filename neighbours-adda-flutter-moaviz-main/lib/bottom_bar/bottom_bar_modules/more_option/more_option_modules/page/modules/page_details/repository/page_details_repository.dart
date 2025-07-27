import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/models/page_detail_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../../../utility/constant/errors.dart';

class PageDetailsRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<PageDetailsModel> fetchPageDetails({
    int page = 1,
    required String pageId,
  }) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _fetchPageDetailsIsolate(
            accessToken: accessToken,
            page: page,
            pageId: pageId,
          );
        },
        {'accessToken': await authPref.getAccessToken()},
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<PageDetailsModel> _fetchPageDetailsIsolate({
    required String accessToken,
    required int page,
    required String pageId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'page_id': pageId,
        'page': page,
      });
      final dio = dioClient();
      return await dio.post("v2/pages/page/view", data: data).then((response) {
        if (response.data['status'] == "valid") {
          return PageDetailsModel.fromJson(response.data['data']);
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

  //toggle favourite page
  Future<void> toggleFavouritePage({
    required String pageId,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _toggleFavouritePageIsolate(
          accessToken: accessToken,
          pageId: pageId,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<void> _toggleFavouritePageIsolate({
    required String accessToken,
    required String pageId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'page_id': pageId,
      });
      final dio = dioClient();
      return await dio
          .post("pages/page/add_remove_favorite", data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return;
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
