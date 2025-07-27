part of 'group_search_cubit.dart';

class GroupSearchState extends Equatable {
  final bool isSearchDataLoading;
  final bool dataLoading;
  final GroupListModel? groupSearchList;
  final String? error;

  const GroupSearchState({
    this.isSearchDataLoading = false,
    this.dataLoading = false,
    this.groupSearchList,
    this.error,
  });

  @override
  List<Object?> get props =>
      [isSearchDataLoading, dataLoading, groupSearchList, error];

  GroupSearchState copyWith({
    GroupListModel? groupSearchList,
    bool? isSearchDataLoading,
    bool? dataLoading,
    String? error,
  }) {
    return GroupSearchState(
      groupSearchList: groupSearchList ?? this.groupSearchList,
      isSearchDataLoading: isSearchDataLoading ?? false,
      dataLoading: dataLoading ?? false,
      error: error,
    );
  }
}
