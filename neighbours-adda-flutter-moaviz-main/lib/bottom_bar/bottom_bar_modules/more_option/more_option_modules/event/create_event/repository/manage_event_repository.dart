import 'package:designer/utility/theme_toast.dart';
import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/create_event/model/manage_event_model.dart';
import 'package:snap_local/common/utils/category/v1/model/category_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../../utility/constant/errors.dart';

class ManageEventRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  /////////Event post///////////
//Upload
  Future<void> uploadEventPost(ManageEventModel manageEventModel) async {
    try {
      final uploadPostDetailsMap = manageEventModel.toMap();
      uploadPostDetailsMap.addAll({
        'access_token': await authPref.getAccessToken(),
      });

      return await makeIsolateApiCallWithInternetCheck(
        _uploadEventPostIsolate,
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

  Future<String?> _uploadEventPostIsolate(Map<String, dynamic> mapData) async {
    try {
      FormData data = FormData.fromMap(mapData);
      final dio = dioClient();
      return await dio.post('v2/users/events/add', data: data).then((response) {
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
  Future<void> updateEventPost(ManageEventModel manageEventModel) async {
    try {
      final uploadPostDetailsMap = manageEventModel.toMap();
      uploadPostDetailsMap
          .addAll({'access_token': await authPref.getAccessToken()});
      return await makeIsolateApiCallWithInternetCheck(
        _updateEventPostIsolate,
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

  Future<String?> _updateEventPostIsolate(Map<String, dynamic> mapData) async {
    try {
      FormData data = FormData.fromMap(mapData);
      final dio = dioClient();
      return await dio
          .post('v2/users/events/update', data: data)
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

  Future<void> deleteEvent(String pollId) async {
    try {
      await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _deleteEventIsolate(
            accessToken: accessToken,
            pollId: pollId,
          );
        },
        {'accessToken': await authPref.getAccessToken()},
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

  Future<String?> _deleteEventIsolate({
    required String accessToken,
    required String pollId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'poll_id': pollId,
      });
      final dio = dioClient();
      return await dio.post("polls/polls/delete", data: data).then((response) {
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

//Event topics
  Future<CategoryListModel> fetchEventCategorys() async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        _fetchEventCategorysIsolate,
        await authPref.getAccessToken(),
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<CategoryListModel> _fetchEventCategorysIsolate(
      String accessToken) async {
    try {
      FormData data = FormData.fromMap({'access_token': accessToken});

      final dio = dioClient();
      return await dio
          .post('v2/users/events/topics', data: data)
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

  // Future<void> giveVoteOnEvent({
  //   required String pollId,
  //   required String optionId,
  // }) async {
  //   try {
  //     await makeIsolateApiCallWithInternetCheck(
  //       (Map<String, dynamic> params) {
  //         final accessToken = params['accessToken']! as String;
  //         return _giveVoteOnEventIsolate(
  //           accessToken: accessToken,
  //           pollId: pollId,
  //           optionId: optionId,
  //         );
  //       },
  //       {'accessToken': await authPref.getAccessToken()},
  //     ).then((response) {
  //       if (response != null) {
  //         ThemeToast.successToast(response);
  //       }
  //     });
  //   } catch (e) {
  // Record the error in Firebase Crashlytics
  //     rethrow;
  //   }
  // }

  // Future<String?> _giveVoteOnEventIsolate({
  //   required String accessToken,
  //   required String pollId,
  //   required String optionId,
  // }) async {
  //   try {
  //     FormData data = FormData.fromMap({
  //       'access_token': accessToken,
  //       'poll_id': pollId,
  //       'option_id': optionId,
  //     });

  //     final dio = dioClient();
  //     return await dio.post("polls/vote", data: data).then((response) {
  //       if (response.data['status'] == "valid") {
  //         return response.data['message'];
  //       } else {
  //         throw (response.data['message']);
  //       }
  //     });
  //   } catch (e) {
  // Record the error in Firebase Crashlytics
  //     if (e is DioException) {
  //       if (e.response?.statusCode == 500) {
  //         throw (ErrorConstants.serverError);
  //       }
  //     }
  //     rethrow;
  //   }
  // }
}
