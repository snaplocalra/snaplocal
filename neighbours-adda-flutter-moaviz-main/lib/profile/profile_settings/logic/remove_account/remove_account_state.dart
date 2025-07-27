// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'remove_account_cubit.dart';

class RemoveAccountState extends Equatable {
  final bool sendOTPLoading;
  final bool isOTPSentSuccess;
  final bool verifyOTPLoading;
  final bool otpVerificationCompleted;
  final bool resendOTPLoading;
  final bool resendOTPSuccess;
  final bool otpVerificationFailed;
  final bool openVerifyOTPWidget;
  const RemoveAccountState({
    this.sendOTPLoading = false,
    this.verifyOTPLoading = false,
    this.resendOTPLoading = false,
    this.resendOTPSuccess = false,
    this.isOTPSentSuccess = false,
    this.otpVerificationCompleted = false,
    this.otpVerificationFailed = false,
    this.openVerifyOTPWidget = false,
  });

  bool get isLoading => sendOTPLoading || verifyOTPLoading || resendOTPLoading;

  @override
  List<Object> get props {
    return [
      sendOTPLoading,
      isOTPSentSuccess,
      verifyOTPLoading,
      resendOTPSuccess,
      resendOTPLoading,
      otpVerificationCompleted,
      otpVerificationFailed,
      openVerifyOTPWidget,
    ];
  }

  RemoveAccountState copyWith({
    bool? sendOTPLoading,
    bool? isOTPSentSuccess,
    bool? verifyOTPLoading,
    bool? resendOTPSuccess,
    bool? resendOTPLoading,
    bool? otpVerificationCompleted,
    bool? otpVerificationFailed,
    bool? openVerifyOTPWidget,
  }) {
    return RemoveAccountState(
      sendOTPLoading: sendOTPLoading ?? false,
      isOTPSentSuccess: isOTPSentSuccess ?? false,
      verifyOTPLoading: verifyOTPLoading ?? false,
      resendOTPSuccess: resendOTPSuccess ?? false,
      resendOTPLoading: resendOTPLoading ?? false,
      otpVerificationCompleted: otpVerificationCompleted ?? false,
      otpVerificationFailed: otpVerificationFailed ?? false,
      openVerifyOTPWidget: openVerifyOTPWidget ?? this.openVerifyOTPWidget,
    );
  }
}
