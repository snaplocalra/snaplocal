import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/profile/profile_settings/modules/reset_password/repository/reset_password_repository.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPasswordRepository resetPasswordRepository;
  ResetPasswordCubit(this.resetPasswordRepository)
      : super(const ResetPasswordState());

  Future<void> resetPassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      emit(state.copyWith(requestLoading: true));
      await resetPasswordRepository.resetPassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      emit(state.copyWith(requestSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
      emit(state.copyWith());
    }
  }
}
