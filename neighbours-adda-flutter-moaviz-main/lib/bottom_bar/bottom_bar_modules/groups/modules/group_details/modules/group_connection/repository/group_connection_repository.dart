import 'package:designer/utility/theme_toast.dart';
import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/group_connection/models/group_connection_list_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../../../utility/constant/errors.dart';

class GroupConnectionRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<GroupConnectionListModel> fetchPendingJoinRequest({
    int page = 1,
    required String groupId,
  }) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _fetchPendingJoinRequestIsolate(
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

  Future<GroupConnectionListModel> _fetchPendingJoinRequestIsolate({
    required String accessToken,
    required int page,
    required String groupId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'page': page,
        'group_id': groupId,
      });
      final dio = dioClient();
      return await dio
          .post('groups/group_connections/requested_list', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return GroupConnectionListModel.fromJson(response.data);
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

  Future<void> acceptJoinRequest({required String connectionId}) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _acceptJoinRequestIsolate(
            accessToken: accessToken,
            connectionId: connectionId,
          );
        },
        {'accessToken': await authPref.getAccessToken()},
      ).then((response) => ThemeToast.successToast(response));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String> _acceptJoinRequestIsolate({
    required String accessToken,
    required String connectionId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'connection_id': connectionId,
      });

      final dio = dioClient();
      return await dio
          .post('groups/group_connections/accept', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return response.data['message'];
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

  Future<void> rejectJoinRequest({required String connectionId}) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _rejectJoinRequestIsolate(
            accessToken: accessToken,
            connectionId: connectionId,
          );
        },
        {'accessToken': await authPref.getAccessToken()},
      ).then((response) => ThemeToast.successToast(response));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String> _rejectJoinRequestIsolate({
    required String accessToken,
    required String connectionId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'connection_id': connectionId,
      });

      final dio = dioClient();
      return await dio
          .post('groups/group_connections/reject', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return response.data['message'];
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

  Future<void> sendAndRemoveGroupJoinRequest({required String groupId}) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _sendAndRemoveGroupJoinRequestIsolate(
            accessToken: accessToken,
            groupId: groupId,
          );
        },
        {'accessToken': await authPref.getAccessToken()},
      ).then((response) => ThemeToast.successToast(response));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String> _sendAndRemoveGroupJoinRequestIsolate({
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
          .post('groups/group_connections/add', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return response.data['message'];
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

  Future<void> leaveGroup({required String groupId}) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _leaveGroupIsolate(
            accessToken: accessToken,
            groupId: groupId,
          );
        },
        {'accessToken': await authPref.getAccessToken()},
      ).then((response) => ThemeToast.successToast(response));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String> _leaveGroupIsolate({
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
          .post('groups/group_connections/leave', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return response.data['message'];
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
