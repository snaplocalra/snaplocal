part of 'report_local_chat_spam_cubit.dart';

class ReportLocalChatSpamState extends Equatable {
  final bool dataLoading;
  final bool requestLoading;
  final bool requestSuccess;
  final String? error;
  final ReportLocalChatSpamReasonList reportReasonList;
  const ReportLocalChatSpamState({
    this.dataLoading = false,
    this.requestLoading = false,
    this.requestSuccess = false,
    this.error,
    required this.reportReasonList,
  });

  @override
  List<Object?> get props => [
        reportReasonList,
        dataLoading,
        error,
        requestLoading,
        requestSuccess,
      ];

  ReportLocalChatSpamState copyWith({
    bool? dataLoading,
    bool? requestLoading,
    bool? requestSuccess,
    String? error,
    ReportLocalChatSpamReasonList? reportReasonList,
  }) {
    return ReportLocalChatSpamState(
      dataLoading: dataLoading ?? false,
      requestLoading: requestLoading ?? false,
      requestSuccess: requestSuccess ?? false,
      error: error,
      reportReasonList: reportReasonList ?? this.reportReasonList,
    );
  }
} 