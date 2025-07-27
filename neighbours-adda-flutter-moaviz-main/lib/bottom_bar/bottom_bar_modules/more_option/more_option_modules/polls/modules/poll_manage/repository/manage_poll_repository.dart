import 'package:designer/utility/theme_toast.dart';
import 'package:dio/dio.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/model/manage_poll_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../../../../../../utility/constant/errors.dart';

class ManagePollRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  Future<void> managePoll({
    required ManagePollModel managePollModel,
    bool isEdit = false,
  }) async {
    try {
      final managePollModelMap = managePollModel.toMap();
      managePollModelMap
          .addAll({'access_token': await authPref.getAccessToken()});

      await makeIsolateApiCallWithInternetCheck((_) {
        return _managePollIsolate(
          managePollModelMap: managePollModelMap,
          isEdit: isEdit,
        );
      }, {}).then((response) {
        if (response != null) {
          ThemeToast.successToast(response);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _managePollIsolate({
    required Map<String, dynamic> managePollModelMap,
    bool isEdit = false,
  }) async {
    try {
      FormData data = FormData.fromMap(managePollModelMap);
      final dio = dioClient();
      return await dio
          .post("v2/polls/polls/${isEdit ? 'update' : 'add'}", data: data)
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

  // Future<void> deletePoll(String pollId) async {
  //   try {
  //     await makeIsolateApiCallWithInternetCheck(
  //       (Map<String, dynamic> params) {
  //         final accessToken = params['accessToken']! as String;
  //         return _deletePollIsolate(
  //           accessToken: accessToken,
  //           pollId: pollId,
  //         );
  //       },
  //       {'accessToken': await authPref.getAccessToken()},
  //     ).then((response) {
  //       if (response != null) {
  //         ThemeToast.successToast(response);
  //       }
  //     });
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Future<String?> _deletePollIsolate({
  //   required String accessToken,
  //   required String pollId,
  // }) async {
  //   try {
  //     FormData data = FormData.fromMap({
  //       'access_token': accessToken,
  //       'poll_id': pollId,
  //     });
  //     final dio = dioClient();
  //     return await dio.post("polls/polls/delete", data: data).then((response) {
  //       if (response.data['status'] == "valid") {
  //         return response.data['message'];
  //       } else {
  //         throw (response.data['message']);
  //       }
  //     });
  //   } catch (e) {
  //     if (e is DioException) {
  //       if (e.response?.statusCode == 500) {
  //         throw (ErrorConstants.serverError);
  //       }
  //     }
  //     rethrow;
  //   }
  // }

  Future<void> giveVoteOnPoll({
    required String pollId,
    required String optionId,
  }) async {
    try {
      await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          final accessToken = params['accessToken']! as String;
          return _giveVoteOnPollIsolate(
            accessToken: accessToken,
            pollId: pollId,
            optionId: optionId,
          );
        },
        {'accessToken': await authPref.getAccessToken()},
      ).then((response) {
        if (response != null) {
          ThemeToast.successToast(response);
        }
        return;
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String?> _giveVoteOnPollIsolate({
    required String accessToken,
    required String pollId,
    required String optionId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'poll_id': pollId,
        'option_id': optionId,
      });

      final dio = dioClient();
      return await dio.post("polls/vote", data: data).then((response) {
        if (response.data['status'] == "invalid") {
          return response.data['message'];
        }
        return null;
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
