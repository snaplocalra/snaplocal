import 'package:snap_local/common/utils/data_filter/model/data_filter/data_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/date_range_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter_strategy/data_filter_strategy.dart';
import 'package:snap_local/utility/tools/time_formatter.dart';

// Date range filter strategy
class DateRangeFilterStrategy implements DataFilterStrategy {
  final DateTime? fromDate;
  final DateTime? toDate;

  DateRangeFilterStrategy({
    required this.fromDate,
    required this.toDate,
  });

  @override
  DataFilter applyFilter(DataFilter existingFilter) {
    DateRangeFilter dateRangeFilter = existingFilter as DateRangeFilter;

    //update the date range filter data
    dateRangeFilter = dateRangeFilter.copyWith(
      fromDate: fromDate,
      toDate: toDate,
      filterValue:
          '${FormatDate.selectedDateDDMMYYYY(fromDate!)} to ${FormatDate.selectedDateDDMMYYYY(toDate!)}',
      isSelected: true,
    );

    return dateRangeFilter;
  }
}
