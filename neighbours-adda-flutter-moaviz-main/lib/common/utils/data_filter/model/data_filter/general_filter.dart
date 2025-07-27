import 'package:snap_local/common/utils/category/v1/model/category_model.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/data_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter_strategy/data_filter_strategy.dart';

class GeneralFilter extends DataFilter {
  final List<CategoryModel> categories;

  final String jsonKey;

  GeneralFilter({
    required this.categories,
    required this.jsonKey,
    required super.filterName,
    super.isSelected = false,
    super.filterValue,
  }) : super(id: jsonKey); // Set id to the value of jsonKey

  //clear filter
  @override
  GeneralFilter clearFilter() {
    return GeneralFilter(
      jsonKey: jsonKey,
      //clear all the sub categories
      categories: categories.map((e) => e.copyWith(isSelected: false)).toList(),
      filterName: filterName,
      filterValue: null,
      isSelected: false,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final selectedElementIds =
        categories.where((element) => element.isSelected).map((e) => e.id);
    return {
      jsonKey: selectedElementIds.isEmpty ? null : selectedElementIds.join(',')
    };
  }

  GeneralFilter copyWith({
    List<CategoryModel>? categories,
    CategoryModel? selectedCategory,
    bool? isSelected,
    String? filterName,
    String? filterValue,
  }) {
    return GeneralFilter(
      jsonKey: jsonKey,
      categories: categories ?? this.categories,
      isSelected: isSelected ?? this.isSelected,
      filterName: filterName ?? this.filterName,
      filterValue: filterValue ?? this.filterValue,
    );
  }

  @override
  DataFilter setFilter(DataFilterStrategy strategy) {
    return strategy.applyFilter(this);
  }
}
