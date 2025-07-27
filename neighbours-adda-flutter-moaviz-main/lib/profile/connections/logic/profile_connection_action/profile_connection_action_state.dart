// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_connection_action_cubit.dart';

class ProfileConnectionActionState extends Equatable {
  final bool isAcceptConnectionLoading;
  final bool isRejectConnectionLoading;
  final bool isSendConnectionRequestLoading;
  final bool isFollowingLoading;
  final bool isRequestSuccess;
  final bool isFollowingSuccess;
  final bool toggleBlockLoading;
  final bool toggleBlockRequestSuccess;

  const ProfileConnectionActionState({
    this.isAcceptConnectionLoading = false,
    this.isRejectConnectionLoading = false,
    this.isSendConnectionRequestLoading = false,
    this.isFollowingLoading = false,
    this.isRequestSuccess = false,
    this.isFollowingSuccess = false,
    this.toggleBlockLoading = false,
    this.toggleBlockRequestSuccess = false,
  });

  ///If any of the loading state is active then this will return true
  bool get isLoading =>
      isAcceptConnectionLoading ||
      isRejectConnectionLoading ||
      toggleBlockLoading ||
      isFollowingLoading ||
      toggleBlockRequestSuccess ||
      isSendConnectionRequestLoading;

  @override
  List<Object> get props => [
        isAcceptConnectionLoading,
        isRejectConnectionLoading,
        isSendConnectionRequestLoading,
        toggleBlockLoading,
        toggleBlockRequestSuccess,
        isRequestSuccess,
        isFollowingLoading,
        isFollowingSuccess,
      ];

  ProfileConnectionActionState copyWith({
    bool? isAcceptConnectionLoading,
    bool? isRejectConnectionLoading,
    bool? isSendConnectionRequestLoading,
    bool? toggleBlockLoading,
    bool? toggleBlockRequestSuccess,
    bool stopAllLoading = false,
    bool? isRequestSuccess,
    bool? isFollowingLoading,
    bool? isFollowingSuccess,
  }) {
    return ProfileConnectionActionState(
      isAcceptConnectionLoading: stopAllLoading
          ? false
          : isAcceptConnectionLoading ?? this.isAcceptConnectionLoading,
      isRejectConnectionLoading: stopAllLoading
          ? false
          : isRejectConnectionLoading ?? this.isRejectConnectionLoading,
      isFollowingLoading: stopAllLoading
          ? false
          : isFollowingLoading ?? this.isFollowingLoading,
      isSendConnectionRequestLoading: stopAllLoading
          ? false
          : isSendConnectionRequestLoading ??
              this.isSendConnectionRequestLoading,
      isRequestSuccess: isRequestSuccess ?? false,
      isFollowingSuccess: isFollowingSuccess ?? false,
      toggleBlockLoading: stopAllLoading
          ? false
          : toggleBlockLoading ?? this.toggleBlockLoading,
      toggleBlockRequestSuccess: toggleBlockRequestSuccess ?? false,
    );
  }
}
