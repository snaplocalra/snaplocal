import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:designer/utility/theme_toast.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/authentication/models/authenticated_user_details.dart';
import 'package:snap_local/authentication/models/login_response_model.dart';
import 'package:snap_local/authentication/models/register_user_model.dart';
import 'package:snap_local/authentication/models/social_login_response.dart';
import 'package:snap_local/authentication/models/social_login_type.dart';
import 'package:snap_local/authentication/models/user_check_model.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';
import 'package:snap_local/utility/push_notification/firebase_messaging_service/service/firebase_message_service.dart';

import '../../utility/constant/errors.dart';

class AuthRepository extends BaseApi {
  AuthRepository();
  final authPref = AuthenticationTokenSharedPref();

  Future<String?> _getDeviceId() async {
    if (Platform.isAndroid) {
      return await const AndroidId().getId();
    } else if (Platform.isIOS) {
      final deviceInfo = await DeviceInfoPlugin().iosInfo;
      return deviceInfo.identifierForVendor;
    }
    return null;
  }

  Future<Map<String, dynamic>> _notificationDetails() async {
    final deviceId = await _getDeviceId();
    final notificationDetailsMap = <String, dynamic>{};
    if (deviceId != null) {
      notificationDetailsMap.addAll({
        'device_id': deviceId,
        'push_notification_token': await FirebaseMessageService().generateFirebaseMessageToken(),
        //'push_notification_token': "hjghggfghfhghgghkjghghkhhgh",
        'device_type': Platform.operatingSystem,
      });
    }
    return notificationDetailsMap;
  }

  //Social login
  Future<SocialLoginResponse> socialLogin({
    required User firebaseUser,
    required SocialRegistrationType socialRegistrationType,
  }) async {
    try {
      final Map<String, dynamic> socialLoginDetails = {
        'social_login_id': firebaseUser.uid,
        'email': firebaseUser.email,
        'social_login_type': socialRegistrationType.name,
        //assign the notification details
        ...await _notificationDetails(),
      };
      return await makeIsolateApiCallWithInternetCheck(
          _socialLoginIsolate, socialLoginDetails);
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<SocialLoginResponse> _socialLoginIsolate(
      Map<String, dynamic> socialLoginDetails) async {
    try {
      FormData data = FormData.fromMap(socialLoginDetails);
      final dio = dioClient();
      return await dio.post("social_login", data: data).then((response) {
        if (response.data['status'] == "valid") {
          ThemeToast.successToast(response.data['message']);
          return SocialLoginResponse.fromMap(response.data['data']);
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw (ErrorConstants.serverError);
        } else {
          throw ("Unable to login");
        }
      } else {
        rethrow;
      }
    }
  }

  Future<AuthenticatedUserDetails> socialLoginUserProfileUpdate(
      RegisterUserModel socialLoginUserRegisterModel) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        _socialLoginUserProfileUpdateIsolate,
        socialLoginUserRegisterModel.toMap(),
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<AuthenticatedUserDetails> _socialLoginUserProfileUpdateIsolate(
    Map<String, dynamic> socialLoginUserProfileDetails,
  ) async {
    try {
      FormData data = FormData.fromMap(socialLoginUserProfileDetails);
      final dio = dioClient();
      return await dio
          .post('social_login_profile_update', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return AuthenticatedUserDetails.fromMap(response.data['data']);
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw (ErrorConstants.serverError);
        } else {
          throw ("Unable to register user");
        }
      } else {
        rethrow;
      }
    }
  }

  //Standard login
  Future<UserCheckModel> verifyUserName({required String userName}) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
          _verifyUserNameIsolate, userName);
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<UserCheckModel> _verifyUserNameIsolate(String userName) async {
    try {
      FormData data = FormData.fromMap({'username': userName});
      final dio = dioClient();
      return await dio.post('login/check_user', data: data).then((response) {
        if (response.data['status'] == "valid") {
          return UserCheckModel.fromMap(response.data);
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw (ErrorConstants.serverError);
        } else {
          throw ("Unable to verify phone");
        }
      } else {
        rethrow;
      }
    }
  }

  Future<void> registerUser(RegisterUserModel registerUserModel) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          return _registerUserIsolate(
            registerUserModel:
                params['registerUserModel']! as RegisterUserModel,
            notificationDetails:
                params['notificationDetails'] as Map<String, dynamic>,
          );
        },
        {
          "registerUserModel": registerUserModel,
          "notificationDetails": await _notificationDetails(),
        },
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<void> _registerUserIsolate({
    required RegisterUserModel registerUserModel,
    required Map<String, dynamic> notificationDetails,
  }) async {
    try {
      Map<String, dynamic> registerMap = {};

      //assign the register user details
      registerMap.addAll(registerUserModel.toMap());

      //assign the notification details
      registerMap.addAll(notificationDetails);

      FormData data = FormData.fromMap(registerMap);
      final dio = dioClient();
      await dio.post('registration', data: data).then((response) {
        if (response.data['status'] == "valid") {
          ThemeToast.successToast(response.data['message']);
        } else {
          throw (response.data['message']);
        }
      });
      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw (ErrorConstants.serverError);
        } else {
          throw ("Unable to register user");
        }
      } else {
        rethrow;
      }
    }
  }

  Future<LoginResponseModel> login({
    required String userName,
    required String password,
  }) async {
    try {
      final notificationDetails = await _notificationDetails();
      return await makeIsolateApiCallWithInternetCheck((_) {
        return _loginIsolate(
          userName: userName,
          password: password,
          notificationDetails: notificationDetails,
        );
      }, {});
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<LoginResponseModel> _loginIsolate({
    required String userName,
    required String password,
    required Map<String, dynamic> notificationDetails,
  }) async {
    try {
      final loginUserMap = <String, dynamic>{
        'username': userName,
        'password': password,
      };

      //assign the notification details
      loginUserMap.addAll(notificationDetails);

      FormData data = FormData.fromMap(loginUserMap);
      final dio = dioClient();
      return await dio.post('login', data: data).then((response) {
        if (response.data['status'] == "valid") {
          ThemeToast.successToast(response.data['message']);
          return LoginResponseModel.fromMap(response.data);
        } else {
          ThemeToast.successToast(response.data['message']);
          throw (response.data['message']);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          throw ("Invalid credentials");
        } else if (e.response?.statusCode == 500) {
          throw (ErrorConstants.serverError);
        } else {
          throw ("Unable to login");
        }
      } else {
        rethrow;
      }
    }
  }

  Future<AuthenticatedUserDetails> verifyOTP({
    required String otp,
    required String userName,
    bool isForgotPassword = false,
  }) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          return _verifyOTPIsolate(
            otp: params['otp']! as String,
            userName: params['userName']! as String,
            isForgotPassword: params['isForgotPassword']! as bool,
          );
        },
        {
          "otp": otp,
          "userName": userName,
          "isForgotPassword": isForgotPassword,
        },
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<AuthenticatedUserDetails> _verifyOTPIsolate({
    required String otp,
    required String userName,
    bool isForgotPassword = false,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'otp': otp,
        'username': userName,
      });
      final dio = dioClient();
      return await dio
          .post(isForgotPassword ? 'forgot_password/verify_otp' : 'verify_otp',
              data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          ThemeToast.successToast(response.data['message']);
          return AuthenticatedUserDetails.fromMap(response.data['data']);
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw (ErrorConstants.serverError);
        } else {
          throw ("Unable to verify OTP");
        }
      } else {
        rethrow;
      }
    }
  }

  Future<void> reSendOtp({
    required String userName,
    bool isForgotPassword = false,
  }) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          return _reSendOtpIsolate(
            userName: params['userName']! as String,
            isForgotPassword: params['isForgotPassword']! as bool,
          );
        },
        {
          "userName": userName,
          "isForgotPassword": isForgotPassword,
        },
      );
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<void> _reSendOtpIsolate({
    required String userName,
    bool isForgotPassword = false,
  }) async {
    try {
      FormData data = FormData.fromMap({'username': userName});
      final dio = dioClient();
      return await dio
          .post(
        isForgotPassword ? 'forgot_password/resend_otp' : 'resend_otp',
        data: data,
      )
          .then((response) {
        if (response.data['status'] == "valid") {
          ThemeToast.successToast(response.data['message']);
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw (ErrorConstants.serverError);
        } else {
          throw ("Unable to send OTP");
        }
      } else {
        rethrow;
      }
    }
  }

  Future<void> forgetPasswordSendOTP({
    required String userName,
  }) async {
    try {
      await makeIsolateApiCallWithInternetCheck(
          _forgetPasswordSendOTPIsolate, userName);
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<void> _forgetPasswordSendOTPIsolate(String userName) async {
    try {
      FormData data = FormData.fromMap({"username": userName});

      final dio = dioClient();
      return await dio.post('forgot_password', data: data).then((response) {
        if (response.data['status'] == 'valid') {
          ThemeToast.successToast(response.data['message']);
          return;
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<void> changePassword({
    required String userName,
    required String password,
  }) async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          return _changePasswordIsolate(
            userName: params['userName']! as String,
            password: params['password']! as String,
          );
        },
        {
          "userName": userName,
          "password": password,
        },
      ).then((response) {
        ThemeToast.successToast(response);
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String> _changePasswordIsolate({
    required String userName,
    required String password,
  }) async {
    try {
      FormData data = FormData.fromMap({
        "username": userName,
        "password": password,
        "confirm_password": password,
      });
      final dio = dioClient();
      return await dio
          .post('forgot_password/update', data: data)
          .then((response) {
        if (response.data['status'] == "valid") {
          return response.data['message'];
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<void> _deleteSavedTokens() async {
    await FirebaseMessageService().deleteFirebaseMessageToken();
    await AuthenticationTokenSharedPref().deleteCreds();
    return;
  }

  Future<void> logout() async {
    try {
      return await makeIsolateApiCallWithInternetCheck(
        (Map<String, dynamic> params) {
          return _logoutIsolate(
            accessToken: params['accessToken']!,
            deviceId: params['deviceId'],
          );
        },
        {
          "accessToken": await authPref.getAccessToken(),
          "deviceId": await _getDeviceId(),
        },
      ).then((response) async {
        await _deleteSavedTokens();
        ThemeToast.successToast(response);
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      rethrow;
    }
  }

  Future<String> _logoutIsolate({
    required String accessToken,
    required String deviceId,
  }) async {
    try {
      FormData data = FormData.fromMap({
        'access_token': accessToken,
        'device_id': deviceId,
      });
      final dio = dioClient();
      return await dio.post('logout', data: data).then((response) async {
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
        } else {
          throw ("Unable to Logout");
        }
      } else {
        rethrow;
      }
    }
  }
}
