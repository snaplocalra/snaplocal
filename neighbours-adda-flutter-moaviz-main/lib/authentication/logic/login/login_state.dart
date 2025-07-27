// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'login_bloc.dart';

class LoginState extends Equatable {
  //Social login
  final bool socialProfileRegisterLoading;
  final bool socialProfileRegistered;

  //Verify User
  final bool phoneVerifyLoading;
  final UserCheckModel? userCheckModel;

  //SignUp
  final bool signupLoading;
  final bool signupCompleted;

  //Login
  final bool loginLoading;
  final bool loginCompleted;

  //OTP
  final bool sendOTPLoading;
  final bool verifyOTPLoading;
  final bool otpVerified;
  final bool failedOTPVerification;
  final bool otpResent;

  //Forgot password
  final bool forgotPasswordOTPverified;
  final bool forgotPasswordRequestSent;
  final bool changePasswordLoading;
  final bool changePasswordRequestSent;

  //Social login
  final bool socialLoginVerified;

  const LoginState({
    this.socialProfileRegisterLoading = false,
    this.socialProfileRegistered = false,
    this.phoneVerifyLoading = false,
    this.userCheckModel,
    this.sendOTPLoading = false,
    this.verifyOTPLoading = false,
    this.otpVerified = false,
    this.failedOTPVerification = false,
    this.otpResent = false,
    this.loginLoading = false,
    this.loginCompleted = false,
    this.signupLoading = false,
    this.signupCompleted = false,
    this.forgotPasswordOTPverified = false,
    this.forgotPasswordRequestSent = false,
    this.changePasswordLoading = false,
    this.changePasswordRequestSent = false,
    this.socialLoginVerified = false,
  });

  @override
  List<Object?> get props => [
        socialProfileRegisterLoading,
        socialProfileRegistered,
        phoneVerifyLoading,
        userCheckModel,
        sendOTPLoading,
        verifyOTPLoading,
        otpVerified,
        otpResent,
        failedOTPVerification,
        loginLoading,
        loginCompleted,
        signupLoading,
        signupCompleted,
        forgotPasswordOTPverified,
        forgotPasswordRequestSent,
        changePasswordLoading,
        changePasswordRequestSent,
        socialLoginVerified,
      ];

  LoginState copyWith({
    bool? socialProfileRegisterLoading,
    bool? socialProfileRegistered,
    bool? phoneVerifyLoading,
    bool? isUserRegistered,
    bool? sendOTPLoading,
    bool? verifyOTPLoading,
    bool? otpVerified,
    bool? otpResent,
    bool? failedOTPVerification,
    bool? loginLoading,
    bool? loginCompleted,
    bool? signupLoading,
    bool? signupCompleted,
    bool? forgotPasswordOTPverified,
    bool? forgotPasswordRequestSent,
    bool? changePasswordLoading,
    bool? changePasswordRequestSent,
    bool? socialLoginVerified,
    UserCheckModel? userCheckModel,
  }) {
    return LoginState(
      socialProfileRegisterLoading: socialProfileRegisterLoading ?? false,
      socialProfileRegistered: socialProfileRegistered ?? false,
      phoneVerifyLoading: phoneVerifyLoading ?? false,
      userCheckModel: userCheckModel,
      sendOTPLoading: sendOTPLoading ?? false,
      verifyOTPLoading: verifyOTPLoading ?? false,
      otpVerified: otpVerified ?? false,
      otpResent: otpResent ?? false,
      failedOTPVerification: failedOTPVerification ?? false,
      loginLoading: loginLoading ?? false,
      loginCompleted: loginCompleted ?? false,
      signupLoading: signupLoading ?? false,
      signupCompleted: signupCompleted ?? false,
      forgotPasswordOTPverified: forgotPasswordOTPverified ?? false,
      forgotPasswordRequestSent: forgotPasswordRequestSent ?? false,
      changePasswordLoading: changePasswordLoading ?? false,
      changePasswordRequestSent: changePasswordRequestSent ?? false,
      socialLoginVerified: socialLoginVerified ?? false,
    );
  }
}
