// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'jobs_details_cubit.dart';

class JobDetailsState extends Equatable {
  final JobDetailModel? jobDetailModel;
  final String? error;
  final bool dataLoading;
  final bool requestLoading;

  const JobDetailsState({
    this.jobDetailModel,
    this.error,
    this.dataLoading = false,
    this.requestLoading = false,
  });

  bool get isJobDetailAvailable => jobDetailModel != null;

  @override
  List<Object?> get props => [
        jobDetailModel,
        error,
        dataLoading,
        requestLoading,
      ];

  JobDetailsState copyWith({
    JobDetailModel? jobDetailModel,
    String? error,
    bool? dataLoading,
    bool? requestLoading,
  }) {
    return JobDetailsState(
      jobDetailModel: jobDetailModel ?? this.jobDetailModel,
      error: error,
      dataLoading: dataLoading ?? false,
      requestLoading: requestLoading ?? false,
    );
  }
}
