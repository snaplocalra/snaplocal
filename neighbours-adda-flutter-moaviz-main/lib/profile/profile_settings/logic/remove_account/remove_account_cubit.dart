import "package:firebase_crashlytics/firebase_crashlytics.dart";
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/authentication/logic/authentication_bloc/authentication_bloc.dart';
import 'package:snap_local/profile/profile_settings/repository/profile_settings_repository.dart';

part 'remove_account_state.dart';

class RemoveAccountCubit extends Cubit<RemoveAccountState> {
  final AuthenticationBloc authenticationBloc;
  final ProfileSettingsRepository profileSettingsRepository;

  RemoveAccountCubit({
    required this.authenticationBloc,
    required this.profileSettingsRepository,
  }) : super(const RemoveAccountState());

  void resetState() {
    emit(state.copyWith(openVerifyOTPWidget: false));
  }

  Future<void> removeAccount({required String removeReason}) async {
    try {
      emit(state.copyWith(sendOTPLoading: true));
      await profileSettingsRepository.removeAccount(removeReason: removeReason);
      emit(state.copyWith(isOTPSentSuccess: true, openVerifyOTPWidget: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      emit(state.copyWith());
      ThemeToast.errorToast(e.toString());
    }
  }

  Future<void> verifyOTP({required String otp}) async {
    try {
      emit(state.copyWith(verifyOTPLoading: true));
      await profileSettingsRepository.removeAccountOTPVerification(otp: otp);
      authenticationBloc.add(const LoggedOut());
      emit(state.copyWith(otpVerificationCompleted: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      emit(state.copyWith(otpVerificationFailed: true));
      ThemeToast.errorToast(e.toString());
    }
  }

  Future<void> resendOTP({required String phoneNumber}) async {
    try {
      emit(state.copyWith(resendOTPLoading: true));
      await profileSettingsRepository.removeAccountResendOTP(
          phoneNumber: phoneNumber);
      emit(state.copyWith(resendOTPSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      emit(state.copyWith());
      ThemeToast.errorToast(e.toString());
    }
  }
}
