import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/models/search_filter_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/models/page_list_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/models/page_list_type.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../utility/constant/errors.dart';

class PageListRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<PageListModel> fetchPages({
    int page = 1,
    required PageListType pageListType,
  }) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _fetchPagesIsolate(
            accessToken: accessToken,
            page: page,
            pageListType: pageListType,
          );
        },
        {'accessToken': await authPref.getAccessToken()},
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<PageListModel> _fetchPagesIsolate({
    required String accessToken,
    required int page,
    required PageListType pageListType,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'page': page,
      });
      final dio = dioClient();
      return await dio.post(pageListType.api, data: data).then((response) {
        if (response.data['status'] == "valid") {
          return PageListModel.fromJson(response.data);
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

  Future<PageListModel> searchPages({
    int page = 1,
    required String query,
    String? filterJson,
  }) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _searchPagesIsolate(
            page: page,
            query: query,
            accessToken: accessToken,
            filterJson: filterJson,
          );
        },
        {'accessToken': await authPref.getAccessToken()},
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<PageListModel> _searchPagesIsolate({
    required String query,
    required int page,
    required String accessToken,
    required String? filterJson,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'page': page,
        'keyword': query,
        'access_token': accessToken,
        'filter': filterJson,
      });
      final dio = dioClient();
      return await dio.post("pages/page/search", data: data).then((response) {
        if (response.data['status'] == "valid") {
          return PageListModel.fromJson(response.data);
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

  //Fetch page home data
  Future<List<PageModel>> fetchPageHomeData({
    required SearchFilterTypeEnum searchFilterType,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _fetchPageHomeDataIsolate(
          accessToken: accessToken,
          searchFilterType: searchFilterType,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<List<PageModel>> _fetchPageHomeDataIsolate({
    required String accessToken,
    required SearchFilterTypeEnum searchFilterType,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'filter_type': searchFilterType.jsonValue,
      });
      final dio = dioClient();
      return await dio.post("pages/page", data: data).then((response) {
        if (response.data['status'] == "valid") {
          return List.from(response.data['data'])
              .map((e) => PageModel.fromMap(e))
              .toList();
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
