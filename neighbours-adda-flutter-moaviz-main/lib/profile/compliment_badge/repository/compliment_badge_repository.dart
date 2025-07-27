import 'dart:convert';

import 'package:designer/utility/theme_toast.dart';
import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/profile/compliment_badge/models/compliment_badge_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../utility/constant/errors.dart';

class ComplimentBadgeRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<List<ComplimentBadgeModel>> fetchComplimentBadgesSender({
    required String userId,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _fetchComplimentBadgesSenderIsolate(
          accessToken: accessToken,
          userId: userId,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<List<ComplimentBadgeModel>> _fetchComplimentBadgesSenderIsolate({
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
          .post('users/badges/badges_for_viewer', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return List.from(response.data['data']).map((badge) {
            return ComplimentBadgeSender.fromMap(badge);
          }).toList();
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

  Future<List<ComplimentBadgeModel>> fetchOwnProfileComplimentBadges() async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _fetchOwnProfileComplimentBadgesIsolate(
            accessToken: accessToken);
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<List<ComplimentBadgeModel>> _fetchOwnProfileComplimentBadgesIsolate({
    required String accessToken,
  }) async {
    try {
      FormData data = FormData.fromMap({'access_token': accessToken});
      final dio = dioClient();
      return await dio
          .post('users/badges/badges_for_owner', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return List.from(response.data['data']).map((badge) {
            return OwnProfileComplimentBadge.fromMap(badge);
          }).toList();
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

  Future<void> sendCompliment({
    required String receiverId,
    required List<String> badgeIdList,
  }) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _sendComplimentIsolate(
          accessToken: accessToken,
          receiverId: receiverId,
          badgeIdList: badgeIdList,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<void> _sendComplimentIsolate({
    required String accessToken,
    required String receiverId,
    required List<String> badgeIdList,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'user_id': receiverId,
        'badges': jsonEncode(badgeIdList),
      });
      final dio = dioClient();
      return await dio.post('users/badges/assign', data: data).then((response) async {
        if (response.data['status'] == "valid") {
          return;
        } else {
          print("objectobjectobject");
          print(response.data['message']);
          //ThemeToast.successToast("Message");
          //throw (response.data['message']);
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



  //Select profile badge
  Future<void> assignCompliment({required String badgeId}) async {
    try {
      final accessToken = await authPref.getAccessToken();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _assignComplimentIsolate(
          accessToken: accessToken,
          badgeId: badgeId,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<void> _assignComplimentIsolate({
    required String accessToken,
    required String badgeId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'badge_id': badgeId,
      });
      final dio = dioClient();
      return await dio
          .post('users/badges/apply_to_own_profile', data: data)
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
