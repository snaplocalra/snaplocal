import 'package:designer/utility/theme_toast.dart';
import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/create_group_post/models/manage_group_post_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../../../utility/constant/errors.dart';

class ManageGroupPostRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<void> uploadGroupPost(
      {required ManageGroupPostModel uploadGroupPostModel}) async {
    try {
      final uploadPostDetailsMap = uploadGroupPostModel.toMap();
      uploadPostDetailsMap.addAll({
        'access_token': await authPref.getAccessToken(),
      });

      return await makeIsolateApiCallWithInternetCheck(
        _uploadGroupPostIsolate,
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

  Future<String?> _uploadGroupPostIsolate(
      Map<String, dynamic> uploadPostDetailsMap) async {
    try {
      FormData data = FormData.fromMap(uploadPostDetailsMap);
      final dio = dioClient();
      return await dio.post('v2/groups/post/add', data: data).then((response) {
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

  Future<void> updateGroupPost(
      {required ManageGroupPostModel updatedGroupPostModel}) async {
    try {
      final updatedPostDetailsMap = updatedGroupPostModel.toMap();
      updatedPostDetailsMap.addAll({
        'access_token': await authPref.getAccessToken(),
      });

      return await makeIsolateApiCallWithInternetCheck(
        _updateGroupPostIsolate,
        updatedPostDetailsMap,
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

  Future<String?> _updateGroupPostIsolate(
      Map<String, dynamic> updatedPostDetailsMap) async {
    try {
      FormData data = FormData.fromMap(updatedPostDetailsMap);
      final dio = dioClient();
      return await dio
          .post('v2/groups/post/update', data: data)
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
