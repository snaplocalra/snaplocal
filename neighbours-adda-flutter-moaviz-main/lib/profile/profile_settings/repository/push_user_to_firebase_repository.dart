import 'package:designer/utility/theme_toast.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/utils/firebase_chat/model/firebase_user_profile_details_model.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/firebase_user_repository.dart';
import 'package:snap_local/firebase_options.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/config/env/env.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';

import '../../../utility/constant/errors.dart';

class PushUserToFirebaseRepository extends BaseApi {
  final authPref = AuthenticationTokenSharedPref();

  //Fetch users from server
  Future<List<FirebaseUserProfileDetailsModel>> _fetchUsersFromServer() async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        _fetchUsersFromServerIsolate,
        await authPref.getAccessToken(),
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<List<FirebaseUserProfileDetailsModel>> _fetchUsersFromServerIsolate(
      String accessToken) async {
    try {
      const url = devServerHostName;
      final dio = dioClient();
      return await dio.post("$url/api/fetch_users").then((response) {
        if (response.data['status'] == "valid") {
          return List<FirebaseUserProfileDetailsModel>.from(
            response.data['data'].map(
              (user) => FirebaseUserProfileDetailsModel.fromJson(user),
            ),
          );
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

  //Push user to firebase
  Future<void> _pushUserToFirebase(
    List<FirebaseUserProfileDetailsModel> users,
  ) async {
    //Firebase setup
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    //
    try {
      for (final user in users) {
        await FirebaseUserRepository().manageUser(user);
      }
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  //Call both the functions
  Future<void> pushUserToFirebaseFromServer() async {
    try {
      final users = await _fetchUsersFromServer();
      await _pushUserToFirebase(users);
    } catch (e) {
      // Record the error in Firebase Crashlytics
      ThemeToast.errorToast(e.toString());
      return;
    }
  }
}
