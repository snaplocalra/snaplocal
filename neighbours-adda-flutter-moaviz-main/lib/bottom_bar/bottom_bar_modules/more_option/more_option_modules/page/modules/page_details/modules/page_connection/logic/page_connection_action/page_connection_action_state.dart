// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'page_connection_action_cubit.dart';

class PageConnectionActionState extends Equatable {
  final bool isAcceptConnectionLoading;
  final bool isRejectConnectionLoading;
  final bool isSendAndRemovePageFollowRequestLoading;
  final bool isPageFollowCancelRequestLoading;
  final bool isExitPageRequestLoading;
  final bool isRequestSuccess;

  const PageConnectionActionState({
    this.isAcceptConnectionLoading = false,
    this.isRejectConnectionLoading = false,
    this.isSendAndRemovePageFollowRequestLoading = false,
    this.isPageFollowCancelRequestLoading = false,
    this.isExitPageRequestLoading = false,
    this.isRequestSuccess = false,
  });

  ///If any of the loading state is active then this will return true
  bool get isLoading =>
      isAcceptConnectionLoading ||
      isRejectConnectionLoading ||
      isSendAndRemovePageFollowRequestLoading ||
      isPageFollowCancelRequestLoading ||
      isExitPageRequestLoading;

  @override
  List<Object> get props => [
        isAcceptConnectionLoading,
        isRejectConnectionLoading,
        isSendAndRemovePageFollowRequestLoading,
        isPageFollowCancelRequestLoading,
        isExitPageRequestLoading,
        isRequestSuccess,
      ];

  PageConnectionActionState copyWith({
    bool? isAcceptConnectionLoading,
    bool? isRejectConnectionLoading,
    bool? isSendAndRemovePageFollowRequestLoading,
    bool? isPageFollowCancelRequestLoading,
    bool? isExitPageRequestLoading,
    bool stopAllLoading = false,
    bool? isRequestSuccess,
  }) {
    return PageConnectionActionState(
      isAcceptConnectionLoading: stopAllLoading
          ? false
          : isAcceptConnectionLoading ?? this.isAcceptConnectionLoading,
      isRejectConnectionLoading: stopAllLoading
          ? false
          : isRejectConnectionLoading ?? this.isRejectConnectionLoading,
      isSendAndRemovePageFollowRequestLoading: stopAllLoading
          ? false
          : isSendAndRemovePageFollowRequestLoading ??
              this.isSendAndRemovePageFollowRequestLoading,
      isPageFollowCancelRequestLoading: stopAllLoading
          ? false
          : isPageFollowCancelRequestLoading ??
              this.isPageFollowCancelRequestLoading,
      isExitPageRequestLoading: stopAllLoading
          ? false
          : isExitPageRequestLoading ?? this.isExitPageRequestLoading,
      isRequestSuccess: isRequestSuccess ?? false,
    );
  }
}
