part of 'poll_vote_manage_cubit.dart';

class PollVoteManageState extends Equatable {
  final bool dataLoading;
  final bool refreshData;
  final PollPostModel pollPostModel;

  const PollVoteManageState({
    this.dataLoading = false,
    required this.pollPostModel,
    this.refreshData = false,
  });

  @override
  List<Object> get props => [pollPostModel, dataLoading, refreshData];

  PollVoteManageState copyWith({
    bool? dataLoading,
    PollPostModel? pollPostModel,
    bool? refreshData,
  }) {
    return PollVoteManageState(
      dataLoading: dataLoading ?? false,
      refreshData: refreshData ?? false,
      pollPostModel: pollPostModel ?? this.pollPostModel,
    );
  }
}
