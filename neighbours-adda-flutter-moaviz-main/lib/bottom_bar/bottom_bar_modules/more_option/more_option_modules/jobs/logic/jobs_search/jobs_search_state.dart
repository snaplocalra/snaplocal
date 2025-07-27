part of 'jobs_search_cubit.dart';

class JobsSearchState extends Equatable {
  final bool isSearchDataLoading;
  final bool dataLoading;
  final JobsListModel? jobsListModel;
  final String? error;

  const JobsSearchState({
    this.isSearchDataLoading = false,
    this.dataLoading = false,
    this.jobsListModel,
    this.error,
  });

  @override
  List<Object?> get props =>
      [isSearchDataLoading, dataLoading, jobsListModel, error];

  JobsSearchState copyWith({
    JobsListModel? jobsListModel,
    bool? isSearchDataLoading,
    bool? dataLoading,
    String? error,
  }) {
    return JobsSearchState(
      jobsListModel: jobsListModel ?? this.jobsListModel,
      isSearchDataLoading: isSearchDataLoading ?? false,
      dataLoading: dataLoading ?? false,
      error: error,
    );
  }
}
