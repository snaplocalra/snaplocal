import 'package:snap_local/common/utils/data_filter/model/data_filter_strategy/data_filter_strategy.dart';

abstract class DataFilter {
  final String id;
  final String filterName;
  final String? filterValue;
  final bool isSelected;
  DataFilter({
    required this.id,
    required this.isSelected,
    required this.filterName,
    this.filterValue,
  });

  //toMap
  Map<String, dynamic> toMap();

  //clear filter
  DataFilter clearFilter();

  //set filter
  DataFilter setFilter(DataFilterStrategy strategy);
}
