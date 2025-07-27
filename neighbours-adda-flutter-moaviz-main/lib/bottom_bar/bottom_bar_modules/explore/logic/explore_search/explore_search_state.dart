part of 'explore_search_cubit.dart';

class ExploreState extends Equatable {
  final bool isSearchDataLoading;
  final bool dataLoading;
  final GroupListModel? groupSearchList;
  final PageListModel? pageSearchList;
  final SocialPostsList? feedPostsSearchList;
  final SocialPostsList? connectionPostsSearchList;
  final NeighboursListModel? neighboursSearchList;

  final String? error;

  const ExploreState({
    this.isSearchDataLoading = false,
    this.dataLoading = false,
    this.error,
    this.groupSearchList,
    this.pageSearchList,
    this.neighboursSearchList,
    this.connectionPostsSearchList,
    this.feedPostsSearchList,
  });

  @override
  List<Object?> get props => [
        isSearchDataLoading,
        dataLoading,
        groupSearchList,
        pageSearchList,
        neighboursSearchList,
        feedPostsSearchList,
        connectionPostsSearchList,
        error,
      ];

  ExploreState copyWith({
    PageListModel? pageSearchList,
    GroupListModel? groupSearchList,
    NeighboursListModel? neighboursSearchList,
    SocialPostsList? feedPostsSearchList,
    SocialPostsList? connectionPostsSearchList,
    bool? isSearchDataLoading,
    bool? dataLoading,
    String? error,
  }) {
    return ExploreState(
      pageSearchList: pageSearchList ?? this.pageSearchList,
      groupSearchList: groupSearchList ?? this.groupSearchList,
      neighboursSearchList: neighboursSearchList ?? this.neighboursSearchList,
      feedPostsSearchList: feedPostsSearchList ?? this.feedPostsSearchList,
      connectionPostsSearchList: connectionPostsSearchList ?? this.connectionPostsSearchList,
      isSearchDataLoading: isSearchDataLoading ?? false,
      dataLoading: dataLoading ?? false,
      error: error,
    );
  }
}
