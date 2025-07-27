import 'package:designer/utility/theme_toast.dart';
import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/profile/connections/models/profile_connection_list_model.dart';
import 'package:snap_local/profile/connections/models/profile_connection_type.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../utility/constant/errors.dart';

class ProfileConnectionRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<ProfileConnectionListModel> fetchConnections({
    int page = 1,
    required ProfileConnectionType profileConnectionType,
  }) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _fetchConnectionsIsolate(
            accessToken: accessToken,
            page: page,
            profileConnectionType: profileConnectionType,
          );
        },
        {
          'accessToken': await authPref.getAccessToken(),
        },
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<ProfileConnectionListModel> _fetchConnectionsIsolate({
    required String accessToken,
    required int page,
    required ProfileConnectionType profileConnectionType,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'page': page,
      });
      final dio = dioClient();
      return await dio
          .post('users/${profileConnectionType.api}', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return ProfileConnectionListModel.fromJson(response.data);
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

  Future<ProfileConnectionListModel> searchConnections({
    int page = 1,
    required ProfileConnectionType profileConnectionType,
    required String query,
  }) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _searchConnectionsIsolate(
            query: query,
            accessToken: accessToken,
            page: page,
            profileConnectionType: profileConnectionType,
          );
        },
        {
          'accessToken': await authPref.getAccessToken(),
        },
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<ProfileConnectionListModel> _searchConnectionsIsolate({
    required String query,
    required String accessToken,
    required int page,
    required ProfileConnectionType profileConnectionType,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'keyword': query,
        'type': profileConnectionType.type,
        'page': page,
      });

      final dio = dioClient();
      return await dio
          .post('users/user_connections/search', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return ProfileConnectionListModel.fromJson(response.data);
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

  Future<void> acceptConnection({required String connectionId}) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _acceptConnectionIsolate(
            accessToken: accessToken,
            connectionId: connectionId,
          );
        },
        {
          'accessToken': await authPref.getAccessToken(),
        },
      ).then((response) => ThemeToast.successToast(response));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String> _acceptConnectionIsolate({
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
          .post('users/user_connections/accept', data: data)
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

  Future<void> rejectConnection({required String connectionId}) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _rejectConnectionIsolate(
            accessToken: accessToken,
            connectionId: connectionId,
          );
        },
        {
          'accessToken': await authPref.getAccessToken(),
        },
      ).then((response) => ThemeToast.successToast(response));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String> _rejectConnectionIsolate({
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
          .post('users/user_connections/reject', data: data)
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

  Future<void> sendConnectionRequest({required String targetingUserId}) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _sendConnectionRequestIsolate(
            accessToken: accessToken,
            targetingUserId: targetingUserId,
          );
        },
        {
          'accessToken': await authPref.getAccessToken(),
        },
      ).then((response) => ThemeToast.successToast(response));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String> _sendConnectionRequestIsolate({
    required String accessToken,
    required String targetingUserId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'targeting_user_id': targetingUserId,
      });

      final dio = dioClient();
      return await dio
          .post('users/user_connections/add', data: data)
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

  // Follow and Unfollow Account
  Future<void> followUnfollowOfficialAccount({required String userId}) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
            (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _followUnfollowOfficialAccountIsolate(
            accessToken: accessToken,
            userId: userId,
          );
        },
        {
          'accessToken': await authPref.getAccessToken(),
        },
      ).then((response) => ThemeToast.successToast(response));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<void> followUnfollowInfluencerAccount({required String userId}) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
            (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _followUnfollowInfluencerAccountIsolate(
            accessToken: accessToken,
            userId: userId,
          );
        },
        {
          'accessToken': await authPref.getAccessToken(),
        },
      ).then((response) => ThemeToast.successToast(response));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String> _followUnfollowOfficialAccountIsolate({
    required String accessToken,
    required String userId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'user_id': userId,
      });

      final dio = dioClient();
      return await dio
          .post('myprofile/follow_unfollow_official_account', data: data)
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

  Future<String> _followUnfollowInfluencerAccountIsolate({
    required String accessToken,
    required String userId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'influencer_id': userId,
      });

      final dio = dioClient();
      return await dio
          .post('influencers/follow_unfollow', data: data)
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

//Toggle block user
  Future<void> toggleBlockUser(String userId) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck(
          (_) => _toggleBlockUserIsolate(
                accessToken: accessToken,
                userId: userId,
              ),
          {}).then((response) => ThemeToast.successToast(response));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String> _toggleBlockUserIsolate({
    required String accessToken,
    required String userId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'user_id': userId,
      });

      final dio = dioClient();
      return await dio.post('users/block', data: data).then((response) {
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
