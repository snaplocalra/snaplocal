// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'submit_support_report_cubit.dart';

class SubmitSupportReportState extends Equatable {
  final bool requestLoading;
  final bool requestSuccess;
  const SubmitSupportReportState({
    this.requestLoading = false,
    this.requestSuccess = false,
  });

  @override
  List<Object> get props => [requestLoading, requestSuccess];

  SubmitSupportReportState copyWith({
    bool? requestLoading,
    bool? requestSuccess,
  }) {
    return SubmitSupportReportState(
      requestLoading: requestLoading ?? false,
      requestSuccess: requestSuccess ?? false,
    );
  }
}
