part of 'data_filter_cubit.dart';

class DataFilterState extends Equatable {
  final bool isLoading;
  final bool showFilter;
  final bool filterApplied;
  final List<DataFilter> dataFilter;
  const DataFilterState({
    required this.dataFilter,
    this.isLoading = false,
    this.filterApplied = false,
    this.showFilter = false,
  });

  //If the filter map is empty, then return empty string
  String get filterJson {
    if (filterMap.isEmpty) {
      return '';
    }
    return jsonEncode(filterMap);
  }

  Map<String, dynamic> get filterMap {
    // Combine all filters into a single map
    return dataFilter.fold<Map<String, dynamic>>({}, (combinedFilter, filter) {
      // Convert each filter to a map and add to the combined filter
      final filterMap = filter.toMap();

      // Add the filter to the combined filter if it is not null
      filterMap.forEach((key, value) {
        if (value != null) {
          // Add the filter to the combined filter
          combinedFilter[key] = value;
        }
      });
      return combinedFilter;
    });
  }

  @override
  List<Object> get props => [dataFilter, isLoading, filterApplied, showFilter];

  DataFilterState copyWith({
    bool? isLoading,
    bool? filterApplied,
    bool? showFilter,
    List<DataFilter>? dataFilter,
  }) {
    return DataFilterState(
      isLoading: isLoading ?? false,
      showFilter: showFilter ?? this.showFilter,
      filterApplied: filterApplied ?? false,
      dataFilter: dataFilter ?? this.dataFilter,
    );
  }
}
