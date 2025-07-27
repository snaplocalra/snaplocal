import 'package:designer/utility/theme_toast.dart';
import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/manage_group/models/create_group_model.dart';
import 'package:snap_local/common/utils/category/v1/model/category_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../utility/constant/errors.dart';

class ManageGroupRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<void> createGroup({
    required CreateGroupModel createGroupModel,
    String? groupCoverImageUrl,
  }) async {
    try {
      final createGroupDetailsMap = createGroupModel.toMap();
      createGroupDetailsMap.addAll({
        'access_token': await authPref.getAccessToken(),
      });
      if (groupCoverImageUrl != null) {
        createGroupDetailsMap.addAll({'image': groupCoverImageUrl});
      }
      return await makeIsolateApiCallWithInternetCheck(
        _createGroupIsolate,
        createGroupDetailsMap,
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

  Future<String?> _createGroupIsolate(
      Map<String, dynamic> createGroupDetailsMap) async {
    try {
      FormData data = FormData.fromMap(createGroupDetailsMap);
      final dio = dioClient();
      return await dio.post('groups/group/add', data: data).then((response) {
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

  Future<void> updateGroup({
    required CreateGroupModel updatedGroupDetailsModel,
    String? groupCoverImageUrl,
    required String groupId,
  }) async {
    try {
      final updatedGroupDetailsMap = updatedGroupDetailsModel.toMap();
      updatedGroupDetailsMap.addAll({
        'access_token': await authPref.getAccessToken(),
        'id': groupId,
      });
      if (groupCoverImageUrl != null) {
        updatedGroupDetailsMap.addAll({'image': groupCoverImageUrl});
      }
      return await makeIsolateApiCallWithInternetCheck(
        _updateGroupIsolate,
        updatedGroupDetailsMap,
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

  Future<String?> _updateGroupIsolate(
      Map<String, dynamic> updateGroupDetailsMap) async {
    try {
      FormData data = FormData.fromMap(updateGroupDetailsMap);
      final dio = dioClient();
      return await dio.post('groups/group/update', data: data).then((response) {
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

  Future<CategoryListModel> fetchGroupCategories() async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        _fetchGroupCategoriesIsolate,
        await authPref.getAccessToken(),
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<CategoryListModel> _fetchGroupCategoriesIsolate(
      String accessToken) async {
    try {
      FormData data = FormData.fromMap({'access_token': accessToken});

      final dio = dioClient();
      return await dio
          .post('groups/group_categories', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return CategoryListModel.fromMap(response.data);
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
