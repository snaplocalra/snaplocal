part of 'content_filter_tab_cubit.dart';

class ContentFilterTabState extends Equatable {
  final bool dataLoading;
  final bool allowFetchData;
  final bool showCategoryFilter;
  final List<ContentFilterTabCategory> viewFilters;

  ContentFilterTabCategory get selectedViewFilter {
    return viewFilters.firstWhere((element) => element.isSelected);
  }

  const ContentFilterTabState({
    this.dataLoading = false,
    this.allowFetchData = false,
    this.showCategoryFilter = false,
    required this.viewFilters,
  });

  @override
  List<Object> get props => [
        dataLoading,
        viewFilters,
        allowFetchData,
        showCategoryFilter,
      ];

  //copy with
  ContentFilterTabState copyWith({
    bool? dataLoading,
    List<ContentFilterTabCategory>? viewFilters,
    bool? allowFetchData,
    bool? showCategoryFilter,
  }) {
    return ContentFilterTabState(
      dataLoading: dataLoading ?? false,
      allowFetchData: allowFetchData ?? false,
      showCategoryFilter: showCategoryFilter ?? false,
      viewFilters: viewFilters ?? this.viewFilters,
    );
  }
}

enum ContentFilterTabType {
  all(displayText: (LocaleKeys.all), jsonValue: "all"),
  local(displayText: (LocaleKeys.local), jsonValue: "local"),
  trending(displayText: (LocaleKeys.trending), jsonValue: "trending"),
  categories(displayText: (LocaleKeys.categories), jsonValue: "categories"),

  //add more filter types here
  //state, national, international
  state(displayText: LocaleKeys.state, jsonValue: "state"),
  national(displayText: LocaleKeys.national, jsonValue: "national"),
  international(
      displayText: LocaleKeys.international, jsonValue: "international");

  final String displayText;
  final String jsonValue;

  const ContentFilterTabType({
    required this.displayText,
    required this.jsonValue,
  });
}

class ContentFilterTabCategory {
  final ContentFilterTabType viewFilterType;
  final bool isSelected;

  ContentFilterTabCategory({
    required this.viewFilterType,
    this.isSelected = false,
  });

  ContentFilterTabCategory copyWith({
    ContentFilterTabType? viewFilterType,
    bool? isSelected,
  }) {
    return ContentFilterTabCategory(
      viewFilterType: viewFilterType ?? this.viewFilterType,
      isSelected: isSelected ?? false,
    );
  }
}
