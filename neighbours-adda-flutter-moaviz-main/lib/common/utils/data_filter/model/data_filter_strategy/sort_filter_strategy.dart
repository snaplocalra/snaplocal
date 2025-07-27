import 'package:snap_local/common/utils/data_filter/model/data_filter/data_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/sort_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter_strategy/data_filter_strategy.dart';

//Sort filter strategy
class SortFilterStrategy implements DataFilterStrategy {
  final int targetSortFilterIndex;

  SortFilterStrategy({required this.targetSortFilterIndex});

  @override
  DataFilter applyFilter(DataFilter existingFilter) {
    SortFilter sortFilter = existingFilter as SortFilter;
    for (var i = 0; i < sortFilter.sortFilterOptions.length; i++) {
      // Get the sort filter data from the sort filter
      SortFilterOption sortFilterOption = sortFilter.sortFilterOptions[i];

      // Check if the index is the same as the sort filter index
      if (i == targetSortFilterIndex) {
        // Set the sort filter data to selected
        sortFilter = sortFilter.copyWith(
          filterValue: sortFilterOption.sortType.displayValue,
          isSelected: true,
          selectedSortFilterOption: sortFilterOption,
        );

        // Set the sort filter option to selected
        sortFilter.sortFilterOptions[i] =
            sortFilterOption.copyWith(isSelected: true);
      } else {
        //update the sort filter option
        sortFilter.sortFilterOptions[i] =
            sortFilterOption.copyWith(isSelected: false);
      }
    }
    return sortFilter;
  }
}
