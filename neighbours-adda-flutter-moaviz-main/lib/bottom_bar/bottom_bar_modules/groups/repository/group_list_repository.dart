import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/models/group_list_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/models/group_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/models/search_filter_type.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../utility/constant/errors.dart';

class GroupListRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<GroupListModel> fetchGroupsByType({
    int page = 1,
    required GroupListType groupListType,
  }) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _fetchGroupsByTypeIsolate(
            accessToken: accessToken,
            page: page,
            groupListType: groupListType,
          );
        },
        {'accessToken': await authPref.getAccessToken()},
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<GroupListModel> _fetchGroupsByTypeIsolate({
    required String accessToken,
    required int page,
    required GroupListType groupListType,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'page': page,
      });
      final dio = dioClient();
      return await dio.post(groupListType.api, data: data).then((response) {
        if (response.data['status'] == "valid") {
          return GroupListModel.fromJson(response.data);
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

  Future<GroupListModel> searchGroups({
    int page = 1,
    required String query,
    String? filterJson,
  }) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _searchGroupsIsolate(
            page: page,
            query: query,
            filterJson: filterJson,
            accessToken: accessToken,
          );
        },
        {'accessToken': await authPref.getAccessToken()},
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<GroupListModel> _searchGroupsIsolate({
    required String query,
    required int page,
    required String accessToken,
    String? filterJson,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'page': page,
        'keyword': query,
        'access_token': accessToken,
        'filter': filterJson,
      });
      final dio = dioClient();
      return await dio.post("groups/group/search", data: data).then((response) {
        if (response.data['status'] == "valid") {
          return GroupListModel.fromJson(response.data);
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

  //Fetch group home data
  Future<List<GroupModel>> fetchGroupHomeData({
    required SearchFilterTypeEnum searchFilterType,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _fetchGroupHomeDataIsolate(
          accessToken: accessToken,
          searchFilterType: searchFilterType,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<List<GroupModel>> _fetchGroupHomeDataIsolate({
    required String accessToken,
    required SearchFilterTypeEnum searchFilterType,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'filter_type': searchFilterType.jsonValue,
      });
      final dio = dioClient();
      return await dio.post("groups/group", data: data).then((response) {
        if (response.data['status'] == "valid") {
          return List.from(response.data['data'])
              .map((e) => GroupModel.fromMap(e))
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
