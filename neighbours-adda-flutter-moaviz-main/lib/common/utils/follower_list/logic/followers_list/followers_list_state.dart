part of 'followers_list_cubit.dart';

 class FollowersListState extends Equatable {
  final bool dataLoading;
  final bool isSearchLoading;
  final String? error;
  final FollowerListModel? followerList;
  final bool toggleBlockSuccess;
  const FollowersListState({
    this.dataLoading = false,
    this.isSearchLoading = false,
    this.error,
    this.followerList,
    this.toggleBlockSuccess = false,
  });
  bool get followerListNotAvailable =>
      followerList == null || followerList!.data.isEmpty;

  @override
  List<Object?> get props => [
    dataLoading,
    isSearchLoading,
    error,
    followerList,
    toggleBlockSuccess
  ];

  FollowersListState copyWith({
    bool? dataLoading,
    bool? isSearchLoading,
    String? error,
    FollowerListModel? followerList,
    bool? toggleBlockSuccess,
  }) {
    return FollowersListState(
      dataLoading: dataLoading ?? false,
      isSearchLoading: isSearchLoading ?? false,
      error: error,
      followerList: followerList ?? this.followerList,
      toggleBlockSuccess: toggleBlockSuccess ?? false,
    );
  }
}


