// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'manage_jobs_cubit.dart';

class ManageJobsState extends Equatable {
  final bool isLoading;
  final bool isRequestSuccess;
  const ManageJobsState({
    this.isLoading = false,
    this.isRequestSuccess = false,
  });

  @override
  List<Object> get props => [isLoading, isRequestSuccess];

  ManageJobsState copyWith({
    bool? isLoading,
    bool? isRequestSuccess,
  }) {
    return ManageJobsState(
      isLoading: isLoading ?? false,
      isRequestSuccess: isRequestSuccess ?? false,
    );
  }
}
