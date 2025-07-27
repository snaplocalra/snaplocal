// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'group_connection_action_cubit.dart';

class GroupConnectionActionState extends Equatable {
  final bool isAcceptConnectionLoading;
  final bool isRejectConnectionLoading;
  final bool isSendAndRemoveGroupJoinRequestLoading;
  final bool isGroupJoinCancelRequestLoading;
  final bool isExitGroupRequestLoading;
  final bool isRequestSuccess;

  const GroupConnectionActionState({
    this.isAcceptConnectionLoading = false,
    this.isRejectConnectionLoading = false,
    this.isSendAndRemoveGroupJoinRequestLoading = false,
    this.isGroupJoinCancelRequestLoading = false,
    this.isExitGroupRequestLoading = false,
    this.isRequestSuccess = false,
  });

  ///If any of the loading state is active then this will return true
  bool get isLoading =>
      isAcceptConnectionLoading ||
      isRejectConnectionLoading ||
      isSendAndRemoveGroupJoinRequestLoading ||
      isGroupJoinCancelRequestLoading ||
      isExitGroupRequestLoading;

  @override
  List<Object> get props => [
        isAcceptConnectionLoading,
        isRejectConnectionLoading,
        isSendAndRemoveGroupJoinRequestLoading,
        isGroupJoinCancelRequestLoading,
        isExitGroupRequestLoading,
        isRequestSuccess,
      ];

  GroupConnectionActionState copyWith({
    bool? isAcceptConnectionLoading,
    bool? isRejectConnectionLoading,
    bool? isSendAndRemoveGroupJoinRequestLoading,
    bool? isGroupJoinCancelRequestLoading,
    bool? isExitGroupRequestLoading,
    bool stopAllLoading = false,
    bool? isRequestSuccess,
  }) {
    return GroupConnectionActionState(
      isAcceptConnectionLoading: stopAllLoading
          ? false
          : isAcceptConnectionLoading ?? this.isAcceptConnectionLoading,
      isRejectConnectionLoading: stopAllLoading
          ? false
          : isRejectConnectionLoading ?? this.isRejectConnectionLoading,
      isSendAndRemoveGroupJoinRequestLoading: stopAllLoading
          ? false
          : isSendAndRemoveGroupJoinRequestLoading ?? this.isSendAndRemoveGroupJoinRequestLoading,
      isGroupJoinCancelRequestLoading: stopAllLoading
          ? false
          : isGroupJoinCancelRequestLoading ??
              this.isGroupJoinCancelRequestLoading,
      isExitGroupRequestLoading: stopAllLoading
          ? false
          : isExitGroupRequestLoading ?? this.isExitGroupRequestLoading,
      isRequestSuccess: isRequestSuccess ?? false,
    );
  }
}
