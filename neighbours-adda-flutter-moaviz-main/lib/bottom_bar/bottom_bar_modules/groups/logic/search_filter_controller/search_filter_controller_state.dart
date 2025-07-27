part of 'search_filter_controller_cubit.dart';

class SearchFilterControllerState extends Equatable {
  final bool dataLoading;
  final List<SearchFilterTypeCategory> searchFilterTypeCategories;
  const SearchFilterControllerState({
    this.dataLoading = false,
    required this.searchFilterTypeCategories,
  });

  @override
  List<Object> get props => [dataLoading, searchFilterTypeCategories];

  SearchFilterTypeCategory? get selectedSearchFilterTypeCategory {
    for (final searchFilterTypeCategory in searchFilterTypeCategories) {
      if (searchFilterTypeCategory.isSelected) {
        return searchFilterTypeCategory;
      }
    }
    return null;
  }

  SearchFilterControllerState copyWith({
    bool? dataLoading,
    List<SearchFilterTypeCategory>? searchFilterTypeCategories,
  }) {
    return SearchFilterControllerState(
      dataLoading: dataLoading ?? false,
      searchFilterTypeCategories:
          searchFilterTypeCategories ?? this.searchFilterTypeCategories,
    );
  }
}
