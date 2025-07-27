// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:snap_local/common/utils/data_filter/model/data_filter/data_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter_strategy/data_filter_strategy.dart';

class DistanceRangeFilter extends DataFilter {
  final double allowedMaxDistance;
  final double _selectedMinDistance;
  final double selectedMaxDistance;

  DistanceRangeFilter({
    super.id = "2",
    required this.allowedMaxDistance,
    required this.selectedMaxDistance,
    super.isSelected = false,
    required super.filterName,
    super.filterValue,
  }) : _selectedMinDistance = 0.0; //default min distance

  //clear filter
  @override
  DistanceRangeFilter clearFilter() {
    return DistanceRangeFilter(
      id: id,
      filterName: filterName,
      allowedMaxDistance: allowedMaxDistance,
      selectedMaxDistance: allowedMaxDistance,
      isSelected: false,
      filterValue: null,
    );
  }

  //toMap
  @override
  Map<String, dynamic> toMap() {
    return {
      'distance_range': {
        'min_distance': _selectedMinDistance,
        'max_distance': selectedMaxDistance,
      },
    };
  }

  DistanceRangeFilter copyWith({
    double? selectedMaxDistance,
    double? allowedMaxDistance,
    bool? isSelected,
    String? filterValue,
  }) {
    return DistanceRangeFilter(
      id: id,
      filterName: filterName,
      isSelected: isSelected ?? this.isSelected,
      filterValue: filterValue ?? this.filterValue,
      allowedMaxDistance: allowedMaxDistance ?? this.allowedMaxDistance,
      selectedMaxDistance: selectedMaxDistance ?? this.selectedMaxDistance,
    );
  }

  @override
  DataFilter setFilter(DataFilterStrategy strategy) {
    return strategy.applyFilter(this);
  }
}
