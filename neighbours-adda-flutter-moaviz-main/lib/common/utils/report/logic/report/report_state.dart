part of 'report_cubit.dart';

class ReportState extends Equatable {
  final bool dataLoading;
  final bool requestLoading;
  final bool requestSuccess;
  final String? error;
  final ReportReasonList reportReasonList;
  const ReportState({
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

  ReportState copyWith({
    bool? dataLoading,
    bool? requestLoading,
    bool? requestSuccess,
    String? error,
    ReportReasonList? reportReasonList,
  }) {
    return ReportState(
      dataLoading: dataLoading ?? false,
      requestLoading: requestLoading ?? false,
      requestSuccess: requestSuccess ?? false,
      error: error,
      reportReasonList: reportReasonList ?? this.reportReasonList,
    );
  }
}
