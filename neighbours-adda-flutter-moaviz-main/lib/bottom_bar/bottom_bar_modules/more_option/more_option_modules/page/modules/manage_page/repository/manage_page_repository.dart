import 'package:designer/utility/theme_toast.dart';
import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/manage_page/models/create_page_model.dart';
import 'package:snap_local/common/utils/category/v1/model/category_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../../../utility/constant/errors.dart';

class ManagePageRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<void> createPage({
    required CreatePageModel createPageModel,
    String? pageCoverImageUrl,
  }) async {
    try {
      final createPageDetailsMap = createPageModel.toMap();
      createPageDetailsMap.addAll({
        'access_token': await authPref.getAccessToken(),
      });
      if (pageCoverImageUrl != null) {
        createPageDetailsMap.addAll({'image': pageCoverImageUrl});
      }
      return await makeIsolateApiCallWithInternetCheck(
        _createPageIsolate,
        createPageDetailsMap,
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

  Future<String?> _createPageIsolate(
      Map<String, dynamic> createPageDetailsMap) async {
    try {
      FormData data = FormData.fromMap(createPageDetailsMap);
      final dio = dioClient();
      return await dio.post('v2/pages/page/add', data: data).then((response) {
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

  Future<void> updatePage({
    required CreatePageModel updatedPageDetailsModel,
    String? pageCoverImageUrl,
    required String pageId,
  }) async {
    try {
      final updatedPageDetailsMap = updatedPageDetailsModel.toMap();
      updatedPageDetailsMap.addAll({
        'access_token': await authPref.getAccessToken(),
        'id': pageId,
      });
      if (pageCoverImageUrl != null) {
        updatedPageDetailsMap.addAll({'image': pageCoverImageUrl});
      }
      return await makeIsolateApiCallWithInternetCheck(
        _updatePageIsolate,
        updatedPageDetailsMap,
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

  Future<String?> _updatePageIsolate(
      Map<String, dynamic> updatePageDetailsMap) async {
    try {
      FormData data = FormData.fromMap(updatePageDetailsMap);
      final dio = dioClient();
      return await dio
          .post('v2/pages/page/update', data: data)
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

  Future<CategoryListModel> fetchPageCategories() async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        _fetchPageCategoriesIsolate,
        await authPref.getAccessToken(),
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<CategoryListModel> _fetchPageCategoriesIsolate(
      String accessToken) async {
    try {
      FormData data = FormData.fromMap({'access_token': accessToken});

      final dio = dioClient();
      return await dio
          .post('pages/page_categories', data: data)
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

  //delete page
  Future<void> deletePage({required String pageId}) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _deletePageIsolate(
            accessToken: accessToken,
            pageId: pageId,
          );
        },
        {'accessToken': await authPref.getAccessToken()},
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<void> _deletePageIsolate({
    required String accessToken,
    required String pageId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'page_id': pageId,
      });
      final dio = dioClient();
      return await dio.post("pages/page/delete", data: data).then((response) {
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

  //block page
  Future<void> toggleBlockPage({required String pageId}) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _toggleBlockPageIsolate(
            accessToken: accessToken,
            pageId: pageId,
          );
        },
        {'accessToken': await authPref.getAccessToken()},
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<void> _toggleBlockPageIsolate({
    required String accessToken,
    required String pageId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'page_id': pageId,
      });
      final dio = dioClient();
      return await dio
          .post("pages/page/block_page", data: data)
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
