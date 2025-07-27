import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/authentication/logic/authentication_bloc/authentication_bloc.dart';
import 'package:snap_local/authentication/models/authenticated_user_details.dart';
import 'package:snap_local/authentication/models/login_type_enum.dart';
import 'package:snap_local/authentication/models/register_user_model.dart';
import 'package:snap_local/authentication/models/user_check_model.dart';
import 'package:snap_local/authentication/repository/auth_repository.dart';
import 'package:snap_local/authentication/repository/firebase_login.dart';
import 'package:snap_local/common/utils/introduction/helper/introduction_shared_pref.dart';
import 'package:snap_local/common/utils/tutorial_coach/shared_pref/tutorial_coach_shared_pref.dart';
import 'package:snap_local/utility/local_storage/flutter_secure_storage.dart';
import 'package:snap_local/utility/local_storage/model/storage_keys_enum.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationBloc authenticationBloc;
  final AuthRepository authRepository;
  LoginBloc({
    required this.authenticationBloc,
    required this.authRepository,
  }) : super(const LoginState()) {
    on<LoginEvent>((event, emit) async {
      if (event is VerifyUserName) {
        try {
          emit(state.copyWith(phoneVerifyLoading: true));
          final userCheckData =
              await authRepository.verifyUserName(userName: event.userName);
          emit(state.copyWith(userCheckModel: userCheckData));
          return;
        } catch (e) {
          // Record the error in Firebase Crashlytics
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
          emit(state.copyWith());
          ThemeToast.errorToast(e.toString());
          return;
        }
      }
      else if (event is RegisterUser) {
        try {
          emit(state.copyWith(signupLoading: true));
          //Standard registration
          if (event.registrationType == RegistrationType.standard) {
            await authRepository.registerUser(event.registerUserModel);
            emit(state.copyWith(signupCompleted: true));
          }
          //Update the user profile for social login
          else if (event.registrationType == RegistrationType.social) {
            final authenticatedUserDetails = await authRepository
                .socialLoginUserProfileUpdate(event.registerUserModel);

            //If the user is already registered, then login the user
            await login(authenticatedUserDetails);

            //Save the user name and password in secure storage
            await saveUserNameAndPassword(
              userName: event.registerUserModel.userName,
              password: event.registerUserModel.password,
            );

            emit(state.copyWith(socialLoginVerified: true));
          }
        } catch (e) {
          // Record the error in Firebase Crashlytics
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
          emit(state.copyWith());
          ThemeToast.errorToast(e.toString());
        }
      }
      else if (event is LogInUser) {
        try {
          emit(state.copyWith(loginLoading: true));
          final loginResponseModel = await authRepository.login(
            userName: event.userName,
            password: event.password,
          );
          if (loginResponseModel.otpVerified) {
            await login(loginResponseModel.authenticatedUserDetails);

            //Save the user name and password in secure storage
            await saveUserNameAndPassword(
              userName: event.userName,
              password: event.password,
            );
          }
          emit(state.copyWith(
            loginCompleted: true,
            otpVerified: loginResponseModel.otpVerified,
          ));

          return;
        } catch (e) {
          // Record the error in Firebase Crashlytics
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
          emit(state.copyWith());
          ThemeToast.errorToast(e.toString());
          return;
        }
      }
      //This verify otp event will handle both regular and forgot password otp verification
      else if (event is VerifyOTP) {
        try {
          emit(state.copyWith(verifyOTPLoading: true));
          final authenticatedUserDetails = await authRepository.verifyOTP(
            otp: event.otp,
            userName: event.userName,
            isForgotPassword: event.isForgotPassword,
          );
          if (event.isForgotPassword) {
            emit(state.copyWith(
              otpVerified: true,
              forgotPasswordOTPverified: true,
            ));
          } else {
            await Future.wait([
              TutorialCoachSharedPref().deleteCoachStatus(),
              IntroductionSharedPref().deleteIntroductionStatus(),
              login(authenticatedUserDetails),
            ]);
            emit(state.copyWith(
              otpVerified: true,
              //Show the verify otp loading till the authbloc state update
              verifyOTPLoading: true,
            ));
          }
          return;
        } catch (e) {
          // Record the error in Firebase Crashlytics
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
          ThemeToast.errorToast(e.toString());
          emit(state.copyWith(failedOTPVerification: true));
          return;
        }
      } else if (event is ResendOTP) {
        try {
          emit(state.copyWith(sendOTPLoading: true));
          await authRepository.reSendOtp(
            userName: event.userName,
            isForgotPassword: event.isForgotPassword,
          );
          emit(state.copyWith(otpResent: true));
          return;
        } catch (e) {
          // Record the error in Firebase Crashlytics
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
          ThemeToast.errorToast(e.toString());
          return;
        }
      }
      //Forget password
      else if (event is ForgotPassword) {
        try {
          emit(state.copyWith(sendOTPLoading: true));
          // final userId =
          await authRepository.forgetPasswordSendOTP(userName: event.userName);
          emit(state.copyWith(forgotPasswordRequestSent: true));
          return;
        } catch (e) {
          // Record the error in Firebase Crashlytics
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
          emit(state.copyWith());
          ThemeToast.errorToast(e.toString());
          return;
        }
      }
      //Change password
      else if (event is ChangePassword) {
        try {
          emit(state.copyWith(changePasswordLoading: true));
          await authRepository.changePassword(
            userName: event.userName,
            password: event.newPassword,
          );
          emit(state.copyWith(changePasswordRequestSent: true));
          return;
        } catch (e) {
          // Record the error in Firebase Crashlytics
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
          emit(state.copyWith());
          ThemeToast.errorToast(e.toString());
          return;
        }
      }
    });
  }

  ///trigger the login event
  Future<void> login(AuthenticatedUserDetails authenticatedUserDetails) async {
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        await FirebaseLoginRepository().anonymousLogin();
      }

      authenticationBloc.add(LoggedIn(
        accessToken: authenticatedUserDetails.accessToken,
        userId: authenticatedUserDetails.userId,
      ));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  //Save the user name and password in secure storage
  Future<void> saveUserNameAndPassword({
    required String userName,
    required String? password,
  }) async {
    try {
      await Future.wait([
        FlutterSecureStorageImpl().saveKey(
          StorageKey.userName,
          userName,
        ),
        if (password != null)
          FlutterSecureStorageImpl().saveKey(
            StorageKey.password,
            password,
          ),
      ]);
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }
}
