import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/common/utils/report/model/report_model.dart';
import 'package:snap_local/common/utils/report/model/report_screen_payload.dart';
import 'package:snap_local/common/utils/report/model/report_type.dart';
import 'package:snap_local/common/utils/report/repository/report_repository.dart';

part 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final ReportRepository reportRepository;
  ReportCubit(this.reportRepository)
      : super(const ReportState(reportReasonList: ReportReasonList()));

  Future<void> fetchReportReasons(ReportType reportType) async {
    try {
      //Only fetch and emit the data if the state is empty
      emit(state.copyWith(dataLoading: true));
      final reportModel = await reportRepository.fetchReportReasons(reportType);
      //Emit state to store initial data
      emit(state.copyWith(reportReasonList: reportModel));
      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      emit(state.copyWith(error: e.toString()));
      return;
    }
  }

  void selectReason(String reasonId) {
    if (state.reportReasonList.data.isNotEmpty) {
      emit(state.copyWith(dataLoading: true));
      ReportReasonModel? selectedData;
      for (var reason in state.reportReasonList.data) {
        if (reason.id == reasonId) {
          reason.isSelected = true;
          selectedData = reason;
        } else {
          reason.isSelected = false;
        }
      }

      emit(state.copyWith(
        reportReasonList:
            state.reportReasonList.copyWith(selectedData: selectedData),
      ));
    }
  }

  // Post report
  // Future<void> submitGeneralReport({
  //   required String targetId,
  //   required ReportType reportType,
  //   required String additionalDetails,
  // }) async {
  //   try {
  //     if (state.reportReasonList.selectedData != null) {
  //       emit(state.copyWith(requestLoading: true));
  //       await reportRepository.submitGeneralReport(
  //         targetId: targetId,
  //         reportType: reportType,
  //         additionalDetails: additionalDetails,
  //         reasonId: state.reportReasonList.selectedData!.id,
  //       );
  //       emit(state.copyWith(requestSuccess: true));
  //     } else {
  //       throw ("Please select a reason");
  //     }
  //     return;
  //   } catch (e) {
  //     // Record the error in Firebase Crashlytics
  //     FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
  //     if (isClosed) {
  //       return;
  //     }
  //     ThemeToast.errorToast(e.toString());
  //     emit(state.copyWith());
  //     return;
  //   }
  // }

  // Future<void> submitSocialPostReport({
  //   required String postId,
  //   required PostFrom postFrom,
  //   required PostType postType,
  //   required String additionalDetails,
  //   required ReportType reportType,
  // }) async {
  //   try {
  //     if (state.reportReasonList.selectedData != null) {
  //       emit(state.copyWith(requestLoading: true));
  //       await reportRepository.submitSocialPostReport(
  //         postId: postId,
  //         postFrom: postFrom,
  //         postType: postType,
  //         additionalDetails: additionalDetails,
  //         reasonId: state.reportReasonList.selectedData!.id,
  //       );
  //       emit(state.copyWith(requestSuccess: true));
  //     } else {
  //       throw ("Please select a reason");
  //     }
  //     return;
  //   } catch (e) {
  //     // Record the error in Firebase Crashlytics
  //     FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
  //     if (isClosed) {
  //       return;
  //     }
  //     ThemeToast.errorToast(e.toString());
  //     emit(state.copyWith());
  //     return;
  //   }
  // }

  //Submit report
  void submitReport({
    required ReportScreenPayload payload,
    required String additionalDetails,
  }) async {
    try {
      if (state.reportReasonList.selectedData != null) {
        emit(state.copyWith(requestLoading: true));
        await reportRepository.submitReport(
          payload: payload,
          additionalDetails: additionalDetails,
          reasonId: state.reportReasonList.selectedData!.id,
        );
        emit(state.copyWith(requestSuccess: true));
      } else {
        throw ("Please select a reason");
      }
      return;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (isClosed) {
        return;
      }
      ThemeToast.errorToast(e.toString());
      emit(state.copyWith());
      return;
    }
  }
}
