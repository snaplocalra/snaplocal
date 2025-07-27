// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:snap_local/common/utils/data_filter/model/data_filter/data_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter_strategy/data_filter_strategy.dart';

class DateRangeFilter extends DataFilter {
  final DateTime? fromDate;
  final DateTime? toDate;
  DateRangeFilter({
    super.id = "4",
    super.isSelected = false,
    required super.filterName,
    super.filterValue,
    this.fromDate,
    this.toDate,
  });

  //clear filter
  @override
  DateRangeFilter clearFilter() {
    return DateRangeFilter(
      id: id,
      filterName: filterName,
      isSelected: false,
      filterValue: null,

      //Date
      fromDate: null,
      toDate: null,
    );
  }

  //toMap
  @override
  Map<String, dynamic> toMap() {
    return {
      'date_range': {
        'from': fromDate?.millisecondsSinceEpoch,
        'to': toDate?.millisecondsSinceEpoch,
      },
    };
  }

  DateRangeFilter copyWith({
    //Date
    DateTime? fromDate,
    DateTime? toDate,
    bool? isSelected,
    String? filterValue,
  }) {
    return DateRangeFilter(
      id: id,
      filterName: filterName,
      isSelected: isSelected ?? this.isSelected,
      filterValue: filterValue ?? this.filterValue,
      //Date
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }

  @override
  DataFilter setFilter(DataFilterStrategy strategy) {
    return strategy.applyFilter(this);
  }
}
