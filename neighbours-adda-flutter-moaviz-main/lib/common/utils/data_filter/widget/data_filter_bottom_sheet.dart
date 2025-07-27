import 'package:flutter/material.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/category_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/data_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/date_range_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/distance_range_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/general_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/sort_filter.dart';
import 'package:snap_local/common/utils/data_filter/widget/filters/category_filter_widget.dart';
import 'package:snap_local/common/utils/data_filter/widget/filters/date_range_filter_widget.dart';
import 'package:snap_local/common/utils/data_filter/widget/filters/dsitance_range_filter_widget.dart';
import 'package:snap_local/common/utils/data_filter/widget/filters/general_filter_widget.dart';
import 'package:snap_local/common/utils/data_filter/widget/filters/sort_filter_widget.dart';
import 'package:snap_local/common/utils/widgets/custom_bottom_sheet.dart';

class DataFilterBottomSheet extends StatelessWidget {
  final DataFilter filter;
  final int filterIndex;
  const DataFilterBottomSheet({
    super.key,
    required this.filter,
    required this.filterIndex,
  });

  @override
  Widget build(BuildContext context) {
    //as per the filter type show the filter options
    // the runtime type of the filter can be checked and the options can be shown accordingly

    switch (filter.runtimeType) {
      // Sort Filter
      case const (SortFilter):
        final sortFilter = filter as SortFilter;
        return CustomBottomSheet(
          child: SortFilterWidget(
            sortFilter: sortFilter,
            filterIndex: filterIndex,
          ),
        );

      // Distance Range Filter
      case const (DistanceRangeFilter):
        final distanceFilter = filter as DistanceRangeFilter;
        return CustomBottomSheet(
          child: DistanceRangeFilterWidget(
            filter: distanceFilter,
            filterIndex: filterIndex,
          ),
        );

      //General Filter
      case const (GeneralFilter):
        final generalFilter = filter as GeneralFilter;
        return CustomBottomSheet(
          child: GeneralFilterWidget(
            generalFilter: generalFilter,
            filterIndex: filterIndex,
          ),
        );

      //Category Filter
      case const (CategoryFilter):
        final categoryFilter = filter as CategoryFilter;
        return CategoryFilterWidget(
          categoryFilter: categoryFilter,
          filterIndex: filterIndex,
        );
      //Date Range Filter
      case const (DateRangeFilter):
        final dateRangeFilter = filter as DateRangeFilter;
        return CustomBottomSheet(
          child: DateRangeFilterWidget(
            selectedFromDate: dateRangeFilter.fromDate,
            selectedToDate: dateRangeFilter.toDate,
            filterIndex: filterIndex,
          ),
        );

      default:
        throw Exception("Invalid filter type");
    }
  }
}
