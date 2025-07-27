import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/models/group_detail_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../utility/constant/errors.dart';

class GroupDetailsRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<GroupDetailsModel> fetchGroupDetails({
    int page = 1,
    required String groupId,
  }) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _fetchGroupDetailsIsolate(
            accessToken: accessToken,
            page: page,
            groupId: groupId,
          );
        },
        {'accessToken': await authPref.getAccessToken()},
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<GroupDetailsModel> _fetchGroupDetailsIsolate({
    required String accessToken,
    required int page,
    required String groupId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'group_id': groupId,
        'page': page,
      });
      final dio = dioClient();
      return await dio
          .post("v2/groups/group/view", data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return GroupDetailsModel.fromJson(response.data['data']);
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

  //delete group
  Future<void> deleteGroup({required String groupId}) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _deleteGroupIsolate(
            accessToken: accessToken,
            groupId: groupId,
          );
        },
        {'accessToken': await authPref.getAccessToken()},
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<void> _deleteGroupIsolate({
    required String accessToken,
    required String groupId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'group_id': groupId,
      });
      final dio = dioClient();
      return await dio.post("groups/group/delete", data: data).then((response) {
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

  //block group
  Future<void> toggleBlockGroup({required String groupId}) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _toggleBlockGroupIsolate(
            accessToken: accessToken,
            groupId: groupId,
          );
        },
        {'accessToken': await authPref.getAccessToken()},
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<void> _toggleBlockGroupIsolate({
    required String accessToken,
    required String groupId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'group_id': groupId,
      });
      final dio = dioClient();
      return await dio
          .post("groups/group/block_group", data: data)
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

  //toggle favorite group
  Future<void> toggleFavoriteGroup({required String groupId}) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _toggleFavoriteGroupIsolate(
          accessToken: accessToken,
          groupId: groupId,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<void> _toggleFavoriteGroupIsolate({
    required String accessToken,
    required String groupId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'group_id': groupId,
      });
      final dio = dioClient();
      return await dio
          .post("groups/group/add_remove_favorite", data: data)
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
