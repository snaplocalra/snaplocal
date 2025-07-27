part of 'job_short_view_controller_cubit.dart';

class JobShortViewControllerState extends Equatable {
  final bool dataLoading;
  final JobShortDetailsModel jobShortDetailsModel;
  final PostActionCubit? postActionCubit;
  const JobShortViewControllerState({
    this.dataLoading = false,
    required this.jobShortDetailsModel,
    required this.postActionCubit,
  });

  @override
  List<Object?> get props => [dataLoading, jobShortDetailsModel,postActionCubit];

  JobShortViewControllerState copyWith({
    bool? dataLoading,
    JobShortDetailsModel? jobShortDetailsModel,
    PostActionCubit? postActionCubit,
  }) {
    return JobShortViewControllerState(
      dataLoading: dataLoading ?? this.dataLoading,
      jobShortDetailsModel: jobShortDetailsModel ?? this.jobShortDetailsModel,
      postActionCubit: postActionCubit ?? this.postActionCubit,
    );
  }
}
