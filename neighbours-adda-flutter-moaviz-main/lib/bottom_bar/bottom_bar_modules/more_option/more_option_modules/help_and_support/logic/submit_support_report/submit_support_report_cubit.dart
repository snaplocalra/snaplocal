import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/help_and_support/model/support_report_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/help_and_support/repository/help_support_repository.dart';

part 'submit_support_report_state.dart';

class SubmitSupportReportCubit extends Cubit<SubmitSupportReportState> {
  final HelpSupportRepository helpSupportRepository;
  SubmitSupportReportCubit(this.helpSupportRepository)
      : super(const SubmitSupportReportState());

  Future<void> submitSupportReport(
      SupportReportModel supportReportModel) async {
    try {
      emit(state.copyWith(requestLoading: true));
      await helpSupportRepository.submitSupportReport(supportReportModel);
      emit(state.copyWith(requestSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
      emit(state.copyWith());
    }
  }
}
