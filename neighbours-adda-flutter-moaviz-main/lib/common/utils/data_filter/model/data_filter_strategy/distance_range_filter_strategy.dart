import 'package:snap_local/common/utils/data_filter/model/data_filter/data_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/distance_range_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter_strategy/data_filter_strategy.dart';
import 'package:snap_local/utility/extension_functions/number_formatter.dart';

//Distance range filter strategy
class DistanceRangeFilterStrategy implements DataFilterStrategy {
  final double selectedMaxDistance;

  DistanceRangeFilterStrategy({required this.selectedMaxDistance});

  @override
  DataFilter applyFilter(DataFilter existingFilter) {
    DistanceRangeFilter distanceRangeFilter =
        existingFilter as DistanceRangeFilter;

    final maxDistance = selectedMaxDistance.formatNumber();

    //update the distance range filter data
    distanceRangeFilter = distanceRangeFilter.copyWith(
      selectedMaxDistance: selectedMaxDistance,
      filterValue: 'Up to $maxDistance km',
      isSelected: true,
    );

    return distanceRangeFilter;
  }
}
