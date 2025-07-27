part of 'post_action_cubit.dart';

class PostActionState extends Equatable {
  final bool isSharePermissionLoading;
  final bool isCommentPermissionLoading;
  final bool isSaveRequestLoading;
  final bool isSaveRequestSuccess;
  final bool isDeleteRequestLoading;
  final bool isDeleteRequestSuccess;
  final bool isRequestFailed;
  final bool isChangeCommentRequestFailed;
  final bool isChangeShareRequestFailed;

  //follow
  final bool isFollowRequestLoading;
  final bool isFollowRequestSuccess;

  //close poll
  final bool isClosePollRequestLoading;
  final bool isClosePollRequestSuccess;
  const PostActionState({
    this.isSharePermissionLoading = false,
    this.isCommentPermissionLoading = false,
    this.isSaveRequestLoading = false,
    this.isSaveRequestSuccess = false,
    this.isDeleteRequestLoading = false,
    this.isDeleteRequestSuccess = false,
    this.isRequestFailed = false,
    this.isChangeCommentRequestFailed = false,
    this.isChangeShareRequestFailed = false,
    this.isClosePollRequestLoading = false,
    this.isClosePollRequestSuccess = false,
    this.isFollowRequestLoading = false,
    this.isFollowRequestSuccess = false,
  });

  @override
  List<Object> get props => [
        isSharePermissionLoading,
        isCommentPermissionLoading,
        isSaveRequestLoading,
        isSaveRequestSuccess,
        isDeleteRequestLoading,
        isDeleteRequestSuccess,
        isRequestFailed,
        isChangeCommentRequestFailed,
        isChangeShareRequestFailed,
        isClosePollRequestLoading,
        isClosePollRequestSuccess,
        isFollowRequestLoading,
        isFollowRequestSuccess,
      ];

  PostActionState copyWith({
    bool? isSharePermissionLoading,
    bool? isCommentPermissionLoading,
    bool? isSaveRequestLoading,
    bool? isSaveRequestSuccess,
    bool? isDeleteRequestLoading,
    bool? isDeleteRequestSuccess,
    bool? isRequestFailed,
    bool? isChangeCommentRequestFailed,
    bool? isChangeShareRequestFailed,
    bool? isClosePollRequestLoading,
    bool? isClosePollRequestSuccess,
    bool? isFollowRequestLoading,
    bool? isFollowRequestSuccess,
  }) {
    return PostActionState(
      isSharePermissionLoading: isSharePermissionLoading ?? false,
      isCommentPermissionLoading: isCommentPermissionLoading ?? false,
      isSaveRequestLoading: isSaveRequestLoading ?? false,
      isSaveRequestSuccess: isSaveRequestSuccess ?? false,
      isDeleteRequestLoading: isDeleteRequestLoading ?? false,
      isDeleteRequestSuccess: isDeleteRequestSuccess ?? false,
      isRequestFailed: isRequestFailed ?? false,
      isChangeCommentRequestFailed: isChangeCommentRequestFailed ?? false,
      isChangeShareRequestFailed: isChangeShareRequestFailed ?? false,
      isClosePollRequestLoading: isClosePollRequestLoading ?? false,
      isClosePollRequestSuccess: isClosePollRequestSuccess ?? false,
      isFollowRequestLoading: isFollowRequestLoading ?? false,
      isFollowRequestSuccess: isFollowRequestSuccess ?? false,
    );
  }
}
