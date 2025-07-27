import 'package:snap_local/common/utils/category/v2/logic/category_controller/category_controller_cubit.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/data_filter.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter_strategy/data_filter_strategy.dart';

class CategoryFilter extends DataFilter {
  final String jsonKey;
  final String? filterId;
  final CategoryControllerCubit categoryControllerCubit;

  CategoryFilter({
    required this.categoryControllerCubit,
    required this.jsonKey,
    required super.filterName,
    super.isSelected = false,
    super.filterValue,
    this.filterId,
  }) : super(id: filterId ?? jsonKey); // Set id to the value of jsonKey

  //clear filter
  @override
  CategoryFilter clearFilter() {
    //clear all the sub categories
    categoryControllerCubit.clearAllSelection();

    return CategoryFilter(
      jsonKey: jsonKey,
      categoryControllerCubit: categoryControllerCubit,
      filterName: filterName,
      filterValue: null,
      isSelected: false,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final state = categoryControllerCubit.state;
    final List<Map<String, dynamic>> selectedCategories = [];
    if (state is CategoryControllerDataLoaded) {
      final categories = state.categories;
      //Insert the selected categories in the list
      selectedCategories.addAll(categories.data
          .where((category) => category.subCategories
              .any((subCategory) => subCategory.isSelected))
          .map((e) => e.selectedSubCategoryMap(ignoreOtherCategoryName: true))
          .toList());
    }
    return {jsonKey: selectedCategories.isEmpty ? null : selectedCategories};
  }

  CategoryFilter copyWith({
    CategoryControllerCubit? categoryControllerCubit,
    bool? isSelected,
    String? filterName,
    String? filterValue,
  }) {
    return CategoryFilter(
      jsonKey: jsonKey,
      categoryControllerCubit:
          categoryControllerCubit ?? this.categoryControllerCubit,
      isSelected: isSelected ?? this.isSelected,
      filterName: filterName ?? this.filterName,
      filterValue: filterValue ?? this.filterValue,
      filterId: filterId,
    );
  }

  @override
  DataFilter setFilter(DataFilterStrategy strategy) {
    return strategy.applyFilter(this);
  }
}
