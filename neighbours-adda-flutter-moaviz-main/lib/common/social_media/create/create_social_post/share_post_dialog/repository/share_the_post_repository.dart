import 'package:designer/utility/theme_toast.dart';
import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/social_media/create/create_social_post/share_post_dialog/model/share_post_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../utility/constant/errors.dart';

class ShareThePostRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<void> shareThePost(
      InAppSharePostDataModel inAppSharePostDataModel) async {
    try {
      final accessToken = await authPref.getAccessToken();

      return await makeIsolateApiCallWithInternetCheck(
          (_) => _shareThePostIsolate(
                accessToken: accessToken,
                inAppSharePostDataModel: inAppSharePostDataModel,
              ),
          {}).then((response) {
        ThemeToast.successToast(response);
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String> _shareThePostIsolate({
    required String accessToken,
    required InAppSharePostDataModel inAppSharePostDataModel,
  }) async {
    try {
      final Map<String, dynamic> dataMap = {'access_token': accessToken};
      dataMap.addAll(inAppSharePostDataModel.toMap());

      FormData data = FormData.fromMap(dataMap);
      final dio = dioClient();
      return await dio.post('v2/users/share_post', data: data).then((response) {
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

  Future<void> updateSharedPost(
      InAppSharePostDataModel inAppSharePostDataModel) async {
    try {
      final accessToken = await authPref.getAccessToken();

      return await makeIsolateApiCallWithInternetCheck(
          (_) => _updateSharedPostIsolate(
                accessToken: accessToken,
                inAppSharePostDataModel: inAppSharePostDataModel,
              ),
          {}).then((response) {
        ThemeToast.successToast(response);
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String> _updateSharedPostIsolate({
    required String accessToken,
    required InAppSharePostDataModel inAppSharePostDataModel,
  }) async {
    try {
      //For this time user can only update the caption
      final Map<String, dynamic> dataMap = {
        'access_token': accessToken,
        'caption': inAppSharePostDataModel.caption,
        'id': inAppSharePostDataModel.postId,
      };

      FormData data = FormData.fromMap(dataMap);
      final dio = dioClient();
      return await dio
          .post('v2/users/share_post/update', data: data)
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
