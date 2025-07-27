part of 'page_search_cubit.dart';

class PageSearchState extends Equatable {
  final bool isSearchDataLoading;
  final bool dataLoading;
  final PageListModel? pageSearchList;
  final String? error;

  const PageSearchState({
    this.isSearchDataLoading = false,
    this.dataLoading = false,
    this.pageSearchList,
    this.error,
  });

  @override
  List<Object?> get props =>
      [isSearchDataLoading, dataLoading, pageSearchList, error];

  PageSearchState copyWith({
    PageListModel? pageSearchList,
    bool? isSearchDataLoading,
    bool? dataLoading,
    String? error,
  }) {
    return PageSearchState(
      pageSearchList: pageSearchList ?? this.pageSearchList,
      isSearchDataLoading: isSearchDataLoading ?? false,
      dataLoading: dataLoading ?? false,
      error: error,
    );
  }
}
