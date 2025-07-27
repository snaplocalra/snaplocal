import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/saved_items/model/saved_item_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/saved_items/model/saved_post_type_enum.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../utility/constant/errors.dart';

class SavedItemsRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<SavedItemModel> fetchSavedItems({
    SavedPostTypeEnum? savedPostTypeEnum,
    String? query,
  }) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _fetchSavedItemsIsolate(
            accessToken: accessToken,
            savedPostTypeEnum: savedPostTypeEnum,
            query: query,
          );
        },
        {'accessToken': await authPref.getAccessToken()},
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<SavedItemModel> _fetchSavedItemsIsolate({
    required String accessToken,
    SavedPostTypeEnum? savedPostTypeEnum,
    String? query,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'keyword': query ?? "",
        'type': savedPostTypeEnum == null ? "" : savedPostTypeEnum.name,
      });
      final dio = dioClient();
      return await dio
          .post("v2/users/saved_items", data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return SavedItemModel.fromMap(response.data['data']);
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
