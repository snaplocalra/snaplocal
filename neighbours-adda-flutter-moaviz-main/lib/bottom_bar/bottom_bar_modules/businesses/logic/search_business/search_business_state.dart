part of 'search_business_cubit.dart';

class SearchBusinessState extends Equatable {
  final bool dataLoading;
  final bool isSearchLoading;
  final String? error;
  final BusinessListModel? availableBusinessList;
  const SearchBusinessState({
    this.dataLoading = false,
    this.isSearchLoading = false,
    this.error,
    this.availableBusinessList,
  });

  bool get businessListNotAvailable =>
      availableBusinessList == null || availableBusinessList!.data.isEmpty;

  @override
  List<Object?> get props =>
      [availableBusinessList, error, dataLoading, isSearchLoading];

  SearchBusinessState copyWith({
    bool? dataLoading,
    bool? isSearchLoading,
    String? error,
    BusinessListModel? availableBusinessList,
  }) {
    return SearchBusinessState(
      dataLoading: dataLoading ?? false,
      isSearchLoading: isSearchLoading ?? false,
      error: error,
      availableBusinessList:
          availableBusinessList ?? this.availableBusinessList,
    );
  }
}
