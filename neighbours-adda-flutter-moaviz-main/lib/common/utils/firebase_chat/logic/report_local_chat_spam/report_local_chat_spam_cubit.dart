import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/common/utils/firebase_chat/model/report_local_chat_spam_model.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/report_local_chat_spam_repository.dart';

part 'report_local_chat_spam_state.dart';

class ReportLocalChatSpamCubit extends Cubit<ReportLocalChatSpamState> {
  final ReportLocalChatSpamRepository repository;
  ReportLocalChatSpamCubit(this.repository)
      : super(const ReportLocalChatSpamState(reportReasonList: ReportLocalChatSpamReasonList()));

  Future<void> fetchReportReasons() async {
    try {
      emit(state.copyWith(dataLoading: true));
      final reportModel = await repository.fetchReportReasons();
      emit(state.copyWith(reportReasonList: reportModel));
      return;
    } catch (e) {
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
      ReportLocalChatSpamReasonModel? selectedData;
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

  Future<void> submitReport({
    required String flaggedUserId,
    required String reasonId,
    String? additionalDetails,
    String? image,
    String? reportMessage
  }) async {
    try {
      if (state.reportReasonList.selectedData != null) {
        emit(state.copyWith(requestLoading: true));
        await repository.submitReport(
          flaggedUserId: flaggedUserId,
          reasonId: reasonId,
          additionalDetails: additionalDetails,
          image: image,
          reportMessage: reportMessage,
        );
        emit(state.copyWith(requestSuccess: true));
      } else {
        throw ("Please select a reason");
      }
      return;
    } catch (e) {
      if (isClosed) {
        return;
      }
      emit(state.copyWith(error: e.toString()));
      return;
    }
  }
} 