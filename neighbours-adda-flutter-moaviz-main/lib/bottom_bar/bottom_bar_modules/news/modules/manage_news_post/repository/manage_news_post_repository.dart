import 'package:designer/utility/theme_toast.dart';
import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_post/model/manage_news_post_model.dart';
import 'package:snap_local/common/utils/category/v1/model/category_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../utility/constant/errors.dart';

class ManageNewsPostRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<void> createNews({
    required ManageNewsPostModel createNewsModel,
  }) async {
    try {
      final createNewsDetailsMap = createNewsModel.toMap();
      createNewsDetailsMap.addAll({
        'access_token': await authPref.getAccessToken(),
      });
      return await makeIsolateApiCallWithInternetCheck(
        _createNewsIsolate,
        createNewsDetailsMap,
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

  Future<String?> _createNewsIsolate(
      Map<String, dynamic> createNewsDetailsMap) async {
    try {
      FormData data = FormData.fromMap(createNewsDetailsMap);
      final dio = dioClient();
      return await dio.post('channels/news/add', data: data).then((response) {
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

  Future<void> updateNews({
    required ManageNewsPostModel updatedNewsDetailsModel,
  }) async {
    try {
      final updatedNewsDetailsMap = updatedNewsDetailsModel.toMap();
      updatedNewsDetailsMap
          .addAll({'access_token': await authPref.getAccessToken()});

      return await makeIsolateApiCallWithInternetCheck(
        _updateNewsIsolate,
        updatedNewsDetailsMap,
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

  Future<String?> _updateNewsIsolate(
      Map<String, dynamic> updateNewsDetailsMap) async {
    try {
      FormData data = FormData.fromMap(updateNewsDetailsMap);
      final dio = dioClient();
      return await dio
          .post('channels/news/update', data: data)
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

  Future<CategoryListModel> fetchNewsCategories() async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        _fetchNewsCategoriesIsolate,
        await authPref.getAccessToken(),
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<CategoryListModel> _fetchNewsCategoriesIsolate(
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

  //delete news
  Future<void> deleteNews({required String newsId}) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _deleteNewsIsolate(
            accessToken: accessToken,
            newsId: newsId,
          );
        },
        {'accessToken': await authPref.getAccessToken()},
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<void> _deleteNewsIsolate({
    required String accessToken,
    required String newsId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'news_id': newsId,
      });
      final dio = dioClient();
      //TODO:Ned to change api
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
}
