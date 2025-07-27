import 'package:designer/utility/theme_toast.dart';
import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/social_media/create/create_social_post/model/categories_post/lost_found_data_post_model.dart';
import 'package:snap_local/common/social_media/create/create_social_post/model/categories_post/regular_data_post_model.dart';
import 'package:snap_local/common/social_media/create/create_social_post/model/categories_post/safety_data_post_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../utility/constant/errors.dart';

class ManageGeneralPostRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  /////////Regular post//////////
  //Upload
  Future<void> uploadRegularPost(
      {required RegularDataPostModel regularDataPostModel}) async {
    try {
      final uploadPostDetailsMap = regularDataPostModel.toMap();
      uploadPostDetailsMap.addAll({
        'access_token': await authPref.getAccessToken(),
      });

      return await makeIsolateApiCallWithInternetCheck(
        _uploadRegularPostIsolate,
        uploadPostDetailsMap,
      ).then((response) {
        if (response != null) {
          ThemeToast.successToast(response);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _uploadRegularPostIsolate(
    Map<String, dynamic> uploadPostDetailsMap,
  ) async {
    try {
      FormData data = FormData.fromMap(uploadPostDetailsMap);
      final dio = dioClient();
      return await dio
          .post('v2/users/regular_post/add', data: data)
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

  //Update
  Future<void> updateRegularPost(
      {required RegularDataPostModel regularDataPostModel}) async {
    try {
      final uploadPostDetailsMap = regularDataPostModel.toMap();
      uploadPostDetailsMap.addAll({
        'access_token': await authPref.getAccessToken(),
      });
      return await makeIsolateApiCallWithInternetCheck(
        _updateRegularPostIsolate,
        uploadPostDetailsMap,
      ).then((response) {
        if (response != null) {
          ThemeToast.successToast(response);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _updateRegularPostIsolate(
      Map<String, dynamic> uploadPostDetailsMap) async {
    try {
      FormData data = FormData.fromMap(uploadPostDetailsMap);
      final dio = dioClient();
      return await dio
          .post('v2/users/regular_post/update', data: data)
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

  /////////Safety post///////////
  //Upload
  Future<void> uploadSafetyPost(
      {required SafetyDataPostModel safetyDataPostModel}) async {
    try {
      final uploadPostDetailsMap = safetyDataPostModel.toMap();
      uploadPostDetailsMap.addAll({
        'access_token': await authPref.getAccessToken(),
      });

      return await makeIsolateApiCallWithInternetCheck(
        _uploadSafetyPostIsolate,
        uploadPostDetailsMap,
      ).then((response) {
        if (response != null) {
          ThemeToast.successToast(response);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _uploadSafetyPostIsolate(Map<String, dynamic> mapData) async {
    try {
      FormData data = FormData.fromMap(mapData);
      final dio = dioClient();
      return await dio
          .post('v2/users/safety_alert/add', data: data)
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

  //Update
  Future<void> updateSafetyPost(SafetyDataPostModel safetyDataPostModel) async {
    try {
      final uploadPostDetailsMap = safetyDataPostModel.toMap();
      uploadPostDetailsMap
          .addAll({'access_token': await authPref.getAccessToken()});
      return await makeIsolateApiCallWithInternetCheck(
        _updateSafetyPostIsolate,
        uploadPostDetailsMap,
      ).then((response) {
        if (response != null) {
          ThemeToast.successToast(response);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _updateSafetyPostIsolate(Map<String, dynamic> mapData) async {
    try {
      FormData data = FormData.fromMap(mapData);
      final dio = dioClient();
      return await dio
          .post('v2/users/safety_alert/update', data: data)
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

  /////////Lost found post///////////
  //Upload
  Future<void> uploadLostFoundPost(
      {required LostFoundDataPostModel lostFoundDataPostModel}) async {
    try {
      final mapData = lostFoundDataPostModel.toMap();
      mapData.addAll({'access_token': await authPref.getAccessToken()});

      return await makeIsolateApiCallWithInternetCheck(
        _uploadLostFoundPostIsolate,
        mapData,
      ).then((response) {
        if (response != null) {
          ThemeToast.successToast(response);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _uploadLostFoundPostIsolate(
      Map<String, dynamic> mapData) async {
    try {
      FormData data = FormData.fromMap(mapData);
      final dio = dioClient();
      return await dio
          .post('v2/users/lost_found/add', data: data)
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

  //Update
  Future<void> updateLostFoundPost({
    required LostFoundDataPostModel lostFoundDataPostModel,
  }) async {
    try {
      final mapData = lostFoundDataPostModel.toMap();
      mapData.addAll({'access_token': await authPref.getAccessToken()});
      return await makeIsolateApiCallWithInternetCheck(
        _updateLostFoundPostIsolate,
        mapData,
      ).then((response) {
        if (response != null) {
          ThemeToast.successToast(response);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _updateLostFoundPostIsolate(
      Map<String, dynamic> mapData) async {
    try {
      FormData data = FormData.fromMap(mapData);
      final dio = dioClient();
      return await dio
          .post('v2/users/lost_found/update', data: data)
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
