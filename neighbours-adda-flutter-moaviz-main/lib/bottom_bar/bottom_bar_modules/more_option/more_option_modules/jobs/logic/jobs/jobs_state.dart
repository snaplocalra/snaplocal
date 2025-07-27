part of 'jobs_cubit.dart';

class JobsState extends Equatable {
  final bool isJobsByNeighboursDataLoading;
  final bool isJobsByYouDataLoading;
  final String? error;
  final JobsDataModel jobsDataModel;
  const JobsState({
    this.isJobsByNeighboursDataLoading = false,
    this.isJobsByYouDataLoading = false,
    required this.jobsDataModel,
    this.error,
  });

  @override
  List<Object?> get props => [
        isJobsByNeighboursDataLoading,
        isJobsByYouDataLoading,
        jobsDataModel,
        error
      ];

  JobsState copyWith({
    bool? isJobsByNeighboursDataLoading,
    bool? isJobsByYouDataLoading,
    JobsDataModel? jobsDataModel,
    String? error,
  }) {
    return JobsState(
      isJobsByNeighboursDataLoading: isJobsByNeighboursDataLoading ?? false,
      isJobsByYouDataLoading: isJobsByYouDataLoading ?? false,
      jobsDataModel: jobsDataModel ?? this.jobsDataModel,
      error: error,
    );
  }
}
