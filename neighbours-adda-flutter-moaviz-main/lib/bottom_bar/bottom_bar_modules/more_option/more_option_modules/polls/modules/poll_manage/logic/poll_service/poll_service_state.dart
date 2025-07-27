part of 'poll_service_cubit.dart';

class PollServiceState extends Equatable {
  final bool isRequestLoading;
  final bool isManagePollRequestSuccess;
  final bool isVotingRequestSuccess;
  final bool isDeleteRequestSuccess;
  final bool isRequestFailed;
  const PollServiceState({
    this.isRequestLoading = false,
    this.isManagePollRequestSuccess = false,
    this.isVotingRequestSuccess = false,
    this.isDeleteRequestSuccess = false,
    this.isRequestFailed = false,
  });

  @override
  List<Object> get props => [
        isRequestLoading,
        isManagePollRequestSuccess,
        isVotingRequestSuccess,
        isDeleteRequestSuccess,
        isRequestFailed,
      ];

  PollServiceState copyWith({
    bool? isRequestLoading,
    bool? isManagePollRequestSuccess,
    bool? isVotingRequestSuccess,
    bool? isDeleteRequestSuccess,
    bool? isRequestFailed,
  }) {
    return PollServiceState(
      isRequestLoading: isRequestLoading ?? false,
      isManagePollRequestSuccess: isManagePollRequestSuccess ?? false,
      isVotingRequestSuccess: isVotingRequestSuccess ?? false,
      isDeleteRequestSuccess: isDeleteRequestSuccess ?? false,
      isRequestFailed: isRequestFailed ?? false,
    );
  }
}
