part of 'group_list_cubit.dart';

class GroupListState extends Equatable {
  final bool isGroupYouJoinedDataLoading;
  final bool isManagedByYouDataLoading;
  final String? error;
  final GroupTypeListModel groupTypeListModel;
  const GroupListState({
    this.isGroupYouJoinedDataLoading = false,
    this.isManagedByYouDataLoading = false,
    required this.groupTypeListModel,
    this.error,
  });

  @override
  List<Object?> get props => [
        isGroupYouJoinedDataLoading,
        isManagedByYouDataLoading,
        groupTypeListModel,
        error
      ];

  GroupListState copyWith({
    bool? isGroupYouJoinedDataLoading,
    bool? isManagedByYouDataLoading,
    GroupTypeListModel? groupTypeListModel,
    String? error,
  }) {
    return GroupListState(
      isGroupYouJoinedDataLoading: isGroupYouJoinedDataLoading ?? false,
      isManagedByYouDataLoading: isManagedByYouDataLoading ?? false,
      groupTypeListModel: groupTypeListModel ?? this.groupTypeListModel,
      error: error,
    );
  }
}
