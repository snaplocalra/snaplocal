part of 'polls_list_cubit.dart';

class PollsListState extends Equatable {
  final bool isOngoingPollsDataLoading;
  final bool isYourPollsDataLoading;
  final bool isClosedPollsDataLoading;
  final String? error;
  final PollsTypeListModel pollsTypeListModel;
  const PollsListState({
    this.isOngoingPollsDataLoading = false,
    this.isYourPollsDataLoading = false,
    this.isClosedPollsDataLoading = false,
    required this.pollsTypeListModel,
    this.error,
  });

  @override
  List<Object?> get props => [
        isOngoingPollsDataLoading,
        isYourPollsDataLoading,
        isClosedPollsDataLoading,
        pollsTypeListModel,
        error
      ];

  PollsListState copyWith({
    bool? isOngoingPollsDataLoading,
    bool? isYourPollsDataLoading,
    bool? isClosedPollsDataLoading,
    PollsTypeListModel? pollsTypeListModel,
    String? error,
  }) {
    return PollsListState(
      isOngoingPollsDataLoading: isOngoingPollsDataLoading ?? false,
      isYourPollsDataLoading: isYourPollsDataLoading ?? false,
      isClosedPollsDataLoading: isClosedPollsDataLoading ?? false,
      pollsTypeListModel: pollsTypeListModel ?? this.pollsTypeListModel,
      error: error,
    );
  }
}
